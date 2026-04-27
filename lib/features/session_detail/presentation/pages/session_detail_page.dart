// lib/features/session_detail/presentation/pages/session_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ispm_attendance/features/schedule/domain/entities/course.dart';
import '../../../../core/theme/app_theme.dart';
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

class _SessionDetailView extends StatelessWidget {
  final Course course;
  const _SessionDetailView({required this.course});

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    final dateFmt = DateFormat('EEEE dd MMMM yyyy', 'fr_FR');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      appBar: AppBar(
        title: Text(
          course.title,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: ISPMColors.white,
        foregroundColor: ISPMColors.black,
        elevation: 0,
        actions: [
          BlocBuilder<SessionDetailBloc, SessionDetailState>(
            builder: (ctx, state) {
              if (state is! SessionDetailLoaded) return const SizedBox();
              return state.isExporting
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: ISPMColors.green),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.picture_as_pdf_rounded),
                      tooltip: 'Exporter PV PDF',
                      onPressed: () =>
                          ctx.read<SessionDetailBloc>().add(const ExportPdfEvent()),
                    );
            },
          ),
        ],
      ),
      body: BlocConsumer<SessionDetailBloc, SessionDetailState>(
        listener: (_, state) {
          if (state is SessionDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ISPMColors.error,
              ),
            );
          }
        },
        builder: (_, state) {
          if (state is SessionDetailLoading || state is SessionDetailInitial) {
            return const Center(
                child: CircularProgressIndicator(color: ISPMColors.green));
          }
          if (state is SessionDetailError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: ISPMColors.error)),
            );
          }
          if (state is SessionDetailLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── En-tête cours ──────────────────────────────────
                _CourseHeaderCard(
                  course: course,
                  dateFmt: dateFmt,
                  timeFmt: timeFmt,
                ),
                const SizedBox(height: 16),

                // ── 4 compteurs ────────────────────────────────────
                _FourCounters(attendance: state.attendance, course: course),
                const SizedBox(height: 16),

                // ── Fiche présence ─────────────────────────────────
                _AttendanceCard(
                    attendance: state.attendance, timeFmt: timeFmt),
                const SizedBox(height: 24),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// ── En-tête cours ──────────────────────────────────────────────────────────

class _CourseHeaderCard extends StatelessWidget {
  final Course course;
  final DateFormat dateFmt;
  final DateFormat timeFmt;

  const _CourseHeaderCard({
    required this.course,
    required this.dateFmt,
    required this.timeFmt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ISPMColors.greenSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.class_rounded,
                    color: ISPMColors.green, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: ISPMColors.black)),
                    Text(course.fieldOfStudy,
                        style: const TextStyle(
                            color: ISPMColors.grey400, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: ISPMColors.grey100),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: dateFmt.format(course.startTime),
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label:
                '${timeFmt.format(course.startTime)} — ${timeFmt.format(course.endTime)}',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: ISPMColors.grey400),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: ISPMColors.grey600, fontSize: 13)),
      ],
    );
  }
}

// ── 4 compteurs ────────────────────────────────────────────────────────────

class _FourCounters extends StatelessWidget {
  final SessionAttendance? attendance;
  final Course course;

  const _FourCounters({required this.attendance, required this.course});

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    final statusLabel = attendance == null
        ? 'Non scanné'
        : attendance!.status == AttendanceStatus.onTime
            ? 'À l\'heure'
            : 'Absent';
    final statusColor = attendance == null
        ? ISPMColors.grey400
        : attendance!.status == AttendanceStatus.onTime
            ? ISPMColors.success
            : ISPMColors.error;

    final scanLabel = attendance?.scanTime != null
        ? timeFmt.format(attendance!.scanTime!)
        : '--:--';

    final duration = course.endTime.difference(course.startTime);
    final durationLabel =
        '${duration.inHours}h${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}';

    final invigilator = attendance?.invigilatorName ?? 'Aucun';

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        _CounterTile(
          icon: Icons.how_to_reg_rounded,
          label: 'Statut',
          value: statusLabel,
          color: statusColor,
        ),
        _CounterTile(
          icon: Icons.qr_code_scanner_rounded,
          label: 'Heure de scan',
          value: scanLabel,
          color: ISPMColors.green,
        ),
        _CounterTile(
          icon: Icons.timer_rounded,
          label: 'Durée',
          value: durationLabel,
          color: ISPMColors.grey600,
        ),
        _CounterTile(
          icon: Icons.person_pin_rounded,
          label: 'Surveillant',
          value: invigilator,
          color: ISPMColors.grey600,
          smallText: true,
        ),
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

  const _CounterTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.smallText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: smallText ? 13 : 16,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(
                color: ISPMColors.grey400, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Fiche présence ─────────────────────────────────────────────────────────

class _AttendanceCard extends StatelessWidget {
  final SessionAttendance? attendance;
  final DateFormat timeFmt;

  const _AttendanceCard(
      {required this.attendance, required this.timeFmt});

  @override
  Widget build(BuildContext context) {
    final isPresent = attendance?.status == AttendanceStatus.onTime;
    final isAbsent = attendance?.status == AttendanceStatus.absent;

    Color bgColor;
    Color textColor;
    IconData statusIcon;
    String statusTitle;

    if (attendance == null) {
      bgColor = ISPMColors.grey100;
      textColor = ISPMColors.grey600;
      statusIcon = Icons.help_outline_rounded;
      statusTitle = 'Aucun enregistrement';
    } else if (isPresent) {
      bgColor = ISPMColors.greenSoft;
      textColor = ISPMColors.green;
      statusIcon = Icons.check_circle_rounded;
      statusTitle = 'Présence confirmée';
    } else {
      bgColor = ISPMColors.errorSoft;
      textColor = ISPMColors.error;
      statusIcon = Icons.cancel_rounded;
      statusTitle = 'Absence enregistrée';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ISPMColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Détail de la séance',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: ISPMColors.black)),
          const SizedBox(height: 14),

          // Badge statut
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: textColor, size: 22),
                const SizedBox(width: 10),
                Text(statusTitle,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Détails
          if (attendance?.scanTime != null) ...[
            _DetailRow(
              label: 'Heure de scan',
              value: timeFmt.format(attendance!.scanTime!),
              icon: Icons.access_time_rounded,
            ),
            const SizedBox(height: 8),
          ],
          if (attendance?.invigilatorName != null) ...[
            _DetailRow(
              label: 'Validé par',
              value: attendance!.invigilatorName!,
              icon: Icons.person_rounded,
            ),
            const SizedBox(height: 8),
          ],
          if (attendance?.invigilatorEmail != null) ...[
            _DetailRow(
              label: 'Contact',
              value: attendance!.invigilatorEmail!,
              icon: Icons.email_rounded,
            ),
          ],
          if (attendance == null)
            const Text(
              'Aucun scan n\'a été enregistré pour cette séance. '
              'Le professeur est marqué absent par défaut.',
              style:
                  TextStyle(color: ISPMColors.grey600, fontSize: 13, height: 1.5),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: ISPMColors.grey400),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(label,
              style: TextStyle(
                  color: ISPMColors.grey600, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: ISPMColors.black)),
        ),
      ],
    );
  }
}
