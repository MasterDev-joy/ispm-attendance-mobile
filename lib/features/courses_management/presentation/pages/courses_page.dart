// lib/features/admin/courses/presentation/pages/courses_page.dart
//
// ✅ AVANT : http.Client direct + _AdminCourse local + FlutterSecureStorage
//    APRÈS : CourseBloc (freezed) + AdminCourse domain entity
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../../../core/presentation/widgets/ispm_button.dart';
import '../../domain/entities/admin_course.dart';
import '../blocs/course_bloc.dart';
import '../../../../core/presentation/shared_widgets/admin_shared_widgets.dart';

const _kAmber = Color(0xFFBA7517);

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with SingleTickerProviderStateMixin {
  final _search = TextEditingController();
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    // ✅ Event freezed au lieu de _loadCourses() avec http direct
    context.read<CourseBloc>().add(const CourseEvent.load());

    _search.addListener(() {
      context.read<CourseBloc>().add(CourseEvent.filterChanged(_search.text));
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _openForm([AdminCourse? course]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CourseBloc>(),
        child: _CourseFormSheet(course: course),
      ),
    );
  }

  Future<void> _confirmDelete(AdminCourse course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.60),
      builder: (_) => _DeleteDialog(title: course.title),
    );
    if (confirmed == true) {
      // ✅ Event freezed
      context.read<CourseBloc>().add(CourseEvent.delete(course.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: IspmGlowBlob.circle(
              radius: 190,
              primaryColor: _kAmber.withOpacity(0.09),
              secondaryColor: Colors.transparent,
            ),
          ),
          const Positioned.fill(child: IspmMeshGrid()),

          SafeArea(
            bottom: false,
            child: BlocConsumer<CourseBloc, CourseState>(
              listener: (context, state) {
                state.whenOrNull(
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          message,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        backgroundColor: ISPMColors.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                );
              },
              builder: (context, state) {
                final count =
                    state.whenOrNull(
                      loaded: (courses, filtered, query) => courses.length,
                    ) ??
                    0;

                return Column(
                  children: [
                    AdminAppBar(
                      title: 'Emplois du temps',
                      subtitle: '$count cours planifiés',
                      onBack: () => Navigator.pop(context),
                      action: ActionBtn(
                        icon: Icons.add_rounded,
                        onTap: () => _openForm(),
                      ),
                    ),

                    // Barre de recherche
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: ISPMColors.grey900,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: ISPMColors.white.withOpacity(0.07),
                          ),
                        ),
                        child: TextField(
                          controller: _search,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: ISPMColors.white,
                          ),
                          cursorColor: _kAmber,
                          decoration: InputDecoration(
                            hintText: 'Rechercher un cours…',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: ISPMColors.white.withOpacity(0.30),
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: ISPMColors.white.withOpacity(0.40),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ✅ state.when() au lieu de if (_loading) / if (_error.isNotEmpty)
                    Expanded(child: _buildBody(context, state)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CourseState state) => state.when(
    initial: () => const Center(
      child: CircularProgressIndicator(color: _kAmber, strokeWidth: 2.5),
    ),
    loading: () => const Center(
      child: CircularProgressIndicator(color: _kAmber, strokeWidth: 2.5),
    ),
    saving: () => const Center(
      child: CircularProgressIndicator(color: _kAmber, strokeWidth: 2.5),
    ),
    saveDone: () => const SizedBox.shrink(),
    error: (message) => AdminErrorPanel(
      message: message,
      onRetry: () => context.read<CourseBloc>().add(const CourseEvent.load()),
      accent: _kAmber,
    ),
    loaded: (courses, filtered, query) => filtered.isEmpty
        ? const AdminEmptyPanel(accent: _kAmber)
        : _CourseList(
            courses: filtered,
            animCtrl: _animCtrl,
            onEdit: _openForm,
            onDelete: _confirmDelete,
          ),
  );
}

// ── Liste cours ───────────────────────────────────────────────────────────────

class _CourseList extends StatelessWidget {
  final List<AdminCourse> courses;
  final AnimationController animCtrl;
  final void Function(AdminCourse) onEdit;
  final void Function(AdminCourse) onDelete;
  const _CourseList({
    required this.courses,
    required this.animCtrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
    physics: const BouncingScrollPhysics(),
    itemCount: courses.length,
    itemBuilder: (_, i) {
      final c = courses[i];
      final start = (0.07 * i).clamp(0.0, 0.7);
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animCtrl,
          curve: Interval(start, 1.0, curve: Curves.easeOut),
        ),
        child: _CourseCard(course: c, onEdit: onEdit, onDelete: onDelete),
      );
    },
  );
}

class _CourseCard extends StatelessWidget {
  final AdminCourse course;
  final void Function(AdminCourse) onEdit;
  final void Function(AdminCourse) onDelete;
  const _CourseCard({
    required this.course,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: course.isNow ? _kAmber.withOpacity(0.08) : ISPMColors.grey900,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: course.isNow
            ? _kAmber.withOpacity(0.40)
            : ISPMColors.white.withOpacity(0.06),
        width: course.isNow ? 1.5 : 1.0,
      ),
    ),
    child: Row(
      children: [
        // Date bloc
        Container(
          width: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: course.isNow
                ? _kAmber.withOpacity(0.15)
                : ISPMColors.grey800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                '${course.startTime.day}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: course.isNow ? _kAmber : ISPMColors.white,
                ),
              ),
              Text(
                [
                  'jan',
                  'fév',
                  'mar',
                  'avr',
                  'mai',
                  'jun',
                  'jul',
                  'aoû',
                  'sep',
                  'oct',
                  'nov',
                  'déc',
                ][course.startTime.month - 1],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: ISPMColors.white.withOpacity(0.40),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (course.isNow) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _kAmber,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'EN COURS',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: ISPMColors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ISPMColors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${course.fieldOfStudy} · ${course.professorName}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: ISPMColors.white.withOpacity(0.38),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: ISPMColors.white.withOpacity(0.30),
                  ),
                  const SizedBox(width: 4),
                  // ✅ course.timeRange depuis l'entity (computed pur)
                  Text(
                    course.timeRange,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: ISPMColors.white.withOpacity(0.40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            _SmallBtn(
              icon: Icons.edit_rounded,
              color: _kAmber,
              onTap: () => onEdit(course),
            ),
            const SizedBox(height: 6),
            _SmallBtn(
              icon: Icons.delete_outline_rounded,
              color: ISPMColors.error,
              onTap: () => onDelete(course),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SmallBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Icon(icon, size: 15, color: color),
    ),
  );
}

// ── Dialog de confirmation de suppression ─────────────────────────────────────

class _DeleteDialog extends StatelessWidget {
  final String title;
  const _DeleteDialog({required this.title});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: ISPMColors.grey900,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: ISPMColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: ISPMColors.error.withOpacity(0.28)),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: ISPMColors.error,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Supprimer le cours',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ISPMColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Voulez-vous supprimer « $title » ? Cette action est irréversible.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: ISPMColors.white.withOpacity(0.50),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    foregroundColor: ISPMColors.white.withOpacity(0.50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: ISPMColors.white.withOpacity(0.12),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ISPMColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ISPMColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ── Formulaire cours (BottomSheet) ────────────────────────────────────────────

class _CourseFormSheet extends StatefulWidget {
  final AdminCourse? course;
  const _CourseFormSheet({this.course});

  @override
  State<_CourseFormSheet> createState() => _CourseFormSheetState();
}

class _CourseFormSheetState extends State<_CourseFormSheet> {
  final _title = TextEditingController();
  final _field = TextEditingController();
  final _profId = TextEditingController();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(hours: 2));

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _title.text = widget.course!.title;
      _field.text = widget.course!.fieldOfStudy;
      _profId.text = widget.course!.professorId;
      _start = widget.course!.startTime;
      _end = widget.course!.endTime;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _field.dispose();
    _profId.dispose();
    super.dispose();
  }

  String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _start : _end),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _kAmber,
            onSurface: ISPMColors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        final base = isStart ? _start : _end;
        final dt = DateTime(
          base.year,
          base.month,
          base.day,
          picked.hour,
          picked.minute,
        );
        if (isStart)
          _start = dt;
        else
          _end = dt;
      });
    }
  }

  void _submit() {
    if (_title.text.isEmpty || _field.text.isEmpty) return;
    // ✅ Event freezed — plus de http direct
    context.read<CourseBloc>().add(
      CourseEvent.save(
        id: widget.course?.id,
        title: _title.text.trim(),
        fieldOfStudy: _field.text.trim(),
        professorId: _profId.text.trim(),
        startTime: _start,
        endTime: _end,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<CourseBloc, CourseState>(
      listenWhen: (prev, curr) =>
          curr.whenOrNull(saveDone: () => true, error: (_) => true) != null,
      listener: (context, state) {
        state.whenOrNull(
          saveDone: () => Navigator.pop(context),
          error: (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: ISPMColors.error,
            ),
          ),
        );
      },
      builder: (context, state) {
        final isLoading = state.whenOrNull(saving: () => true) ?? false;

        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
          decoration: const BoxDecoration(
            color: ISPMColors.grey900,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ISPMColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isEdit ? 'Modifier le cours' : 'Nouveau cours',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ISPMColors.white,
                ),
              ),
              const SizedBox(height: 18),
              _SimpleField(
                label: 'Titre du cours',
                controller: _title,
                icon: Icons.menu_book_rounded,
              ),
              _SimpleField(
                label: 'Filière / Classe',
                controller: _field,
                icon: Icons.group_outlined,
              ),
              _SimpleField(
                label: 'ID du professeur',
                controller: _profId,
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 4),
              Text(
                'HORAIRES',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: ISPMColors.white.withOpacity(0.45),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _TimeSelector(
                      label: 'Début',
                      time: _fmtTime(_start),
                      onTap: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeSelector(
                      label: 'Fin',
                      time: _fmtTime(_end),
                      onTap: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              IspmButton(
                text: _isEdit ? 'Enregistrer' : 'Créer le cours',
                onPressed: isLoading ? null : _submit,
                isLoading: isLoading,
                icon: _isEdit ? Icons.save_rounded : Icons.add_rounded,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SimpleField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  const _SimpleField({
    required this.label,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      decoration: BoxDecoration(
        color: ISPMColors.grey800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ISPMColors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: ISPMColors.white,
        ),
        cursorColor: _kAmber,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: ISPMColors.white.withOpacity(0.35),
          ),
          prefixIcon: Icon(
            icon,
            size: 17,
            color: ISPMColors.white.withOpacity(0.40),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    ),
  );
}

class _TimeSelector extends StatelessWidget {
  final String label, time;
  final VoidCallback onTap;
  const _TimeSelector({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ISPMColors.grey800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ISPMColors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 16,
            color: _kAmber.withOpacity(0.70),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: ISPMColors.white.withOpacity(0.40),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ISPMColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
