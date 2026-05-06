// lib/features/session_detail/presentation/pages/session_detail_page.dart
//
// Détail d'une séance — style dark cohérent avec la HomePage.
// Suppression de la dépendance intl → formatage manuel.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../schedule/domain/entities/course.dart';
import '../blocs/session_detail_bloc.dart';
import '../blocs/session_detail_event.dart';
import '../blocs/session_detail_state.dart';
import '../../domain/entities/session_attendance.dart';

class SessionDetailPage extends StatelessWidget {
  final Course course;
  const SessionDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      SessionDetailBloc()..add(LoadSessionDetailEvent(course)),
      child: _SessionDetailView(course: course),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SessionDetailView extends StatelessWidget {
  final Course course;
  const _SessionDetailView({required this.course});

  String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _fmtDate(DateTime dt) {
    const days   = ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];
    const months = ['janvier','février','mars','avril','mai','juin',
      'juillet','août','septembre','octobre','novembre','décembre'];
    return '${days[dt.weekday - 1]} ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          Positioned(top: -80, right: -60,
              child: IspmGlowBlob.circle(radius: 200,
                  primaryColor: ISPMColors.greenDark.withOpacity(0.09),
                  secondaryColor: Colors.transparent)),
          const Positioned.fill(child: IspmMeshGrid()),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // AppBar
                _DetailAppBar(
                  title: course.title,
                  onBack: () => Navigator.pop(context),
                  onExport: () => context
                      .read<SessionDetailBloc>()
                      .add(const ExportPdfEvent()),
                ),

                // Corps
                Expanded(
                  child: BlocConsumer<SessionDetailBloc, SessionDetailState>(
                    listener: (ctx, state) {
                      if (state is SessionDetailError) {
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                          content: Text(state.message,
                              style: const TextStyle(fontFamily: 'Poppins')),
                          backgroundColor: ISPMColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ));
                      }
                    },
                    builder: (_, state) {
                      if (state is SessionDetailLoading ||
                          state is SessionDetailInitial) {
                        return const Center(child: CircularProgressIndicator(
                            color: ISPMColors.green, strokeWidth: 2.5));
                      }
                      if (state is SessionDetailError) {
                        return Center(child: Text(state.message,
                            style: const TextStyle(fontFamily: 'Poppins',
                                color: ISPMColors.error)));
                      }
                      if (state is SessionDetailLoaded) {
                        return ListView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _CourseHeaderCard(
                              course: course,
                              date: _fmtDate(course.startTime),
                              start: _fmtTime(course.startTime),
                              end: _fmtTime(course.endTime),
                              isExporting: state.isExporting,
                            ),
                            const SizedBox(height: 14),
                            _FourCounters(
                              attendance: state.attendance,
                              course: course,
                              fmtTime: _fmtTime,
                            ),
                            const SizedBox(height: 14),
                            _AttendanceDetailCard(
                              attendance: state.attendance,
                              fmtTime: _fmtTime,
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  AppBar détail
// ─────────────────────────────────────────────────────────────────────────────

class _DetailAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onExport;

  const _DetailAppBar({
    required this.title, required this.onBack, required this.onExport});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(children: [
        GestureDetector(
          onTap: onBack,
          child: Container(width: 40, height: 40,
              decoration: BoxDecoration(
                  color: ISPMColors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ISPMColors.white.withOpacity(0.09))),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: ISPMColors.white)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(title,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 15,
                fontWeight: FontWeight.w600, color: ISPMColors.white),
            overflow: TextOverflow.ellipsis)),
        GestureDetector(
          onTap: onExport,
          child: Container(width: 40, height: 40,
              decoration: BoxDecoration(
                  color: ISPMColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ISPMColors.green.withOpacity(0.30))),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  size: 17, color: ISPMColors.green)),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte en-tête cours
// ─────────────────────────────────────────────────────────────────────────────

class _CourseHeaderCard extends StatelessWidget {
  final Course course;
  final String date;
  final String start;
  final String end;
  final bool   isExporting;

  const _CourseHeaderCard({
    required this.course, required this.date, required this.start,
    required this.end, required this.isExporting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ISPMColors.green.withOpacity(0.30), width: 1.5),
          boxShadow: [BoxShadow(color: ISPMColors.green.withOpacity(0.07),
              blurRadius: 20, offset: const Offset(0, 5))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44,
              decoration: BoxDecoration(
                  color: ISPMColors.green.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: ISPMColors.green.withOpacity(0.30))),
              child: const Icon(Icons.menu_book_rounded,
                  size: 22, color: ISPMColors.green)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.title,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 16,
                        fontWeight: FontWeight.w700, color: ISPMColors.white)),
                Text(course.fieldOfStudy,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                        color: ISPMColors.white.withOpacity(0.40))),
              ])),
          if (isExporting)
            const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(
                    color: ISPMColors.green, strokeWidth: 2)),
        ]),
        const SizedBox(height: 14),
        Divider(color: ISPMColors.white.withOpacity(0.06), height: 0),
        const SizedBox(height: 12),
        _InfoRow(icon: Icons.calendar_today_rounded, label: date),
        const SizedBox(height: 6),
        _InfoRow(icon: Icons.schedule_rounded, label: '$start — $end'),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: ISPMColors.white.withOpacity(0.35)),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
          color: ISPMColors.white.withOpacity(0.55))),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Grille 4 compteurs
// ─────────────────────────────────────────────────────────────────────────────

class _FourCounters extends StatelessWidget {
  final SessionAttendance? attendance;
  final Course course;
  final String Function(DateTime) fmtTime;

  const _FourCounters({
    required this.attendance, required this.course, required this.fmtTime});

  @override
  Widget build(BuildContext context) {
    final statusLabel = attendance == null
        ? 'Non scanné'
        : attendance!.status == AttendanceStatus.onTime
        ? 'À l\'heure' : 'Absent';
    final statusColor = attendance == null
        ? ISPMColors.white.withOpacity(0.35)
        : attendance!.status == AttendanceStatus.onTime
        ? ISPMColors.green : ISPMColors.error;
    final scanLabel = attendance?.scanTime != null
        ? fmtTime(attendance!.scanTime!) : '--:--';
    final duration   = course.endTime.difference(course.startTime);
    final durationLbl = '${duration.inHours}h'
        '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}';
    final invigilator = attendance?.supervisorName ?? 'Aucun';

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        _CounterTile(icon: Icons.how_to_reg_rounded,
            label: 'Statut', value: statusLabel, color: statusColor),
        _CounterTile(icon: Icons.qr_code_scanner_rounded,
            label: 'Heure scan', value: scanLabel, color: ISPMColors.green),
        _CounterTile(icon: Icons.timer_rounded,
            label: 'Durée', value: durationLbl,
            color: ISPMColors.white.withOpacity(0.55)),
        _CounterTile(icon: Icons.person_pin_rounded,
            label: 'Surveillant', value: invigilator,
            color: ISPMColors.white.withOpacity(0.55), smallText: true),
      ],
    );
  }
}

class _CounterTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool smallText;

  const _CounterTile({required this.icon, required this.label,
    required this.value, required this.color, this.smallText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ISPMColors.white.withOpacity(0.06))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
                child: Text(value,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: smallText ? 12 : 16,
                        fontWeight: FontWeight.w700, color: color))),
            Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                color: ISPMColors.white.withOpacity(0.35))),
          ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte détail présence
// ─────────────────────────────────────────────────────────────────────────────

class _AttendanceDetailCard extends StatelessWidget {
  final SessionAttendance? attendance;
  final String Function(DateTime) fmtTime;

  const _AttendanceDetailCard({required this.attendance, required this.fmtTime});

  @override
  Widget build(BuildContext context) {
    final isPresent = attendance?.status == AttendanceStatus.onTime;
    final isAbsent  = attendance?.status == AttendanceStatus.absent;

    final Color color;
    final IconData statusIcon;
    final String statusTitle;

    if (attendance == null) {
      color = ISPMColors.white.withOpacity(0.35);
      statusIcon  = Icons.help_outline_rounded;
      statusTitle = 'Aucun enregistrement';
    } else if (isPresent) {
      color = ISPMColors.green;
      statusIcon  = Icons.check_circle_rounded;
      statusTitle = 'Présence confirmée';
    } else {
      color = ISPMColors.error;
      statusIcon  = Icons.cancel_rounded;
      statusTitle = 'Absence enregistrée';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.28), width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.07),
              blurRadius: 20, offset: const Offset(0, 5))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Détail de la séance',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14,
                fontWeight: FontWeight.w700, color: ISPMColors.white)),
        const SizedBox(height: 14),

        // Badge statut
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.28))),
          child: Row(children: [
            Icon(statusIcon, color: color, size: 22),
            const SizedBox(width: 10),
            Text(statusTitle,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14,
                    fontWeight: FontWeight.w600, color: color)),
          ]),
        ),

        const SizedBox(height: 16),

        if (attendance?.scanTime != null) ...[
          _DetailRow(icon: Icons.access_time_rounded,
              label: 'Heure de scan',
              value: fmtTime(attendance!.scanTime!)),
          const SizedBox(height: 10),
        ],
        if (attendance?.supervisorName != null) ...[
          _DetailRow(icon: Icons.person_rounded,
              label: 'Validé par',
              value: attendance!.supervisorName!),
          const SizedBox(height: 10),
        ],
        if (attendance?.supervisorEmail != null)
          _DetailRow(icon: Icons.email_rounded,
              label: 'Contact',
              value: attendance!.supervisorEmail!),

        if (attendance == null) ...[
          Divider(color: ISPMColors.white.withOpacity(0.06)),
          const SizedBox(height: 8),
          Text(
              'Aucun scan enregistré pour cette séance. '
                  'Le professeur est marqué absent par défaut.',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                  color: ISPMColors.white.withOpacity(0.38), height: 1.6)),
        ],
      ]),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 15, color: ISPMColors.white.withOpacity(0.35)),
      const SizedBox(width: 10),
      SizedBox(width: 100,
          child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
              color: ISPMColors.white.withOpacity(0.40)))),
      Expanded(child: Text(value,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
              fontWeight: FontWeight.w600, color: ISPMColors.white),
          overflow: TextOverflow.ellipsis)),
    ]);
  }
}