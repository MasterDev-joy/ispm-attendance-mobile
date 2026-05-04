// lib/features/admin/presentation/pages/courses_page.dart
//
// Page Emplois du temps — Admin uniquement.
// Vue globale de tous les cours de tous les professeurs.
// Permet : ajouter · modifier · supprimer un cours.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/presentation/widgets/ispm_glow_blob.dart';
import '../../../../core/presentation/widgets/ispm_mesh_grid.dart';
import '../../../../core/presentation/widgets/ispm_button.dart';
import 'users_page.dart' show AdminAppBar, ActionBtn, ErrorPanel, EmptyPanel;

const _kAmber = Color(0xFFBA7517);

// ── Modèle cours admin ────────────────────────────────────────────────────────

class _AdminCourse {
  final String id;
  final String title;
  final String fieldOfStudy;
  final String professorName;
  final String professorId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isActive;

  const _AdminCourse({
    required this.id, required this.title,
    required this.fieldOfStudy, required this.professorName,
    required this.professorId, required this.startTime,
    required this.endTime, required this.isActive,
  });

  String get timeRange =>
      '${_fmt(startTime)} – ${_fmt(endTime)}';

  static String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String get dateLabel {
    const days   = ['Lun','Mar','Mer','Jeu','Ven','Sam','Dim'];
    const months = ['jan','fév','mar','avr','mai','jun',
      'jul','aoû','sep','oct','nov','déc'];
    return '${days[startTime.weekday - 1]} ${startTime.day} ${months[startTime.month - 1]}';
  }

  factory _AdminCourse.fromJson(Map<String, dynamic> j) => _AdminCourse(
    id:            j['id'] ?? '',
    title:         j['title'] ?? '',
    fieldOfStudy:  j['fieldOfStudy'] ?? '',
    professorName: j['professorName'] ?? '',
    professorId:   j['professorId'] ?? '',
    startTime:     DateTime.parse(j['startTime'] ?? DateTime.now().toIso8601String()),
    endTime:       DateTime.parse(j['endTime']   ?? DateTime.now().toIso8601String()),
    isActive:      j['isActive'] ?? true,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with SingleTickerProviderStateMixin {

  List<_AdminCourse> _courses  = [];
  List<_AdminCourse> _filtered = [];
  bool   _loading = true;
  String _error   = '';
  final  _search  = TextEditingController();
  late   AnimationController _animCtrl;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 600))..forward();
    _loadCourses();
    _search.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<String?> get _token => _storage.read(key: 'jwt_token');

  Future<void> _loadCourses() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final token = await _token;
      final res   = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/admin/courses'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        _courses = data.map((j) => _AdminCourse.fromJson(j)).toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        _applyFilter();
        setState(() => _loading = false);
      } else {
        setState(() { _error = 'Erreur ${res.statusCode}'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _applyFilter() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty ? List.from(_courses) : _courses.where((c) =>
      c.title.toLowerCase().contains(q) ||
          c.professorName.toLowerCase().contains(q) ||
          c.fieldOfStudy.toLowerCase().contains(q)).toList();
    });
  }

  Future<void> _deleteCourse(_AdminCourse c) async {
    final confirmed = await _confirmDelete(c.title);
    if (!confirmed) return;
    try {
      final token = await _token;
      await http.delete(
        Uri.parse('${AppConfig.baseUrl}/api/admin/courses/${c.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      _loadCourses();
    } catch (_) {}
  }

  Future<bool> _confirmDelete(String title) async {
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.60),
      builder: (_) => Dialog(
        backgroundColor: ISPMColors.grey900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(padding: const EdgeInsets.all(22),
            child: Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 38, height: 38,
                        decoration: BoxDecoration(
                            color: ISPMColors.error.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: ISPMColors.error.withOpacity(0.28))),
                        child: const Icon(Icons.delete_outline_rounded,
                            size: 18, color: ISPMColors.error)),
                    const SizedBox(width: 12),
                    const Text('Supprimer le cours',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16,
                            fontWeight: FontWeight.w700, color: ISPMColors.white)),
                  ]),
                  const SizedBox(height: 14),
                  Text('Voulez-vous supprimer « $title » ? Cette action est irréversible.',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                          color: ISPMColors.white.withOpacity(0.50), height: 1.5)),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                            foregroundColor: ISPMColors.white.withOpacity(0.50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: ISPMColors.white.withOpacity(0.12)))),
                        child: const Text('Annuler',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13)))),
                    const SizedBox(width: 10),
                    Expanded(child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ISPMColors.error, elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text('Supprimer',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                                fontWeight: FontWeight.w600, color: ISPMColors.white)))),
                  ]),
                ])),
      ),
    ) ?? false;
  }

  Future<void> _openForm([_AdminCourse? course]) async {
    final token  = await _token;
    final result = await showModalBottomSheet<bool>(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CourseFormSheet(course: course, token: token ?? ''),
    );
    if (result == true) _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ISPMColors.black,
      body: Stack(children: [
        Positioned(top: -80, left: -60,
            child: IspmGlowBlob.circle(radius: 190,
                primaryColor: _kAmber.withOpacity(0.09),
                secondaryColor: Colors.transparent)),
        const Positioned.fill(child: IspmMeshGrid()),

        SafeArea(bottom: false, child: Column(children: [
          AdminAppBar(
            title: 'Emplois du temps',
            subtitle: '${_courses.length} cours planifiés',
            onBack: () => Navigator.pop(context),
            action: ActionBtn(icon: Icons.add_rounded, onTap: _openForm),
          ),

          // Barre recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(height: 44,
                decoration: BoxDecoration(
                    color: ISPMColors.grey900,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: ISPMColors.white.withOpacity(0.07))),
                child: TextField(
                  controller: _search,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
                      color: ISPMColors.white),
                  cursorColor: _kAmber,
                  decoration: InputDecoration(
                      hintText: 'Rechercher un cours…',
                      hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                          color: ISPMColors.white.withOpacity(0.30)),
                      prefixIcon: Icon(Icons.search_rounded, size: 18,
                          color: ISPMColors.white.withOpacity(0.40)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12)),
                )),
          ),

          Expanded(child: _loading
              ? const Center(child: CircularProgressIndicator(
              color: _kAmber, strokeWidth: 2.5))
              : _error.isNotEmpty
              ? ErrorPanel(message: _error, onRetry: _loadCourses,
              accent: _kAmber)
              : _filtered.isEmpty
              ? EmptyPanel(accent: _kAmber)
              : _CourseList(
            courses: _filtered, animCtrl: _animCtrl,
            onEdit: (c) => _openForm(c),
            onDelete: _deleteCourse,
          )),
        ])),
      ]),
    );
  }
}

// ── Liste cours ───────────────────────────────────────────────────────────────

class _CourseList extends StatelessWidget {
  final List<_AdminCourse> courses;
  final AnimationController animCtrl;
  final void Function(_AdminCourse) onEdit;
  final void Function(_AdminCourse) onDelete;
  const _CourseList({required this.courses, required this.animCtrl,
    required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      physics: const BouncingScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (_, i) {
        final c     = courses[i];
        final start = (0.07 * i).clamp(0.0, 0.7);
        return FadeTransition(
            opacity: CurvedAnimation(parent: animCtrl,
                curve: Interval(start, 1.0, curve: Curves.easeOut)),
            child: _CourseCard(
                course: c, onEdit: onEdit, onDelete: onDelete));
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final _AdminCourse course;
  final void Function(_AdminCourse) onEdit;
  final void Function(_AdminCourse) onDelete;
  const _CourseCard({required this.course, required this.onEdit,
    required this.onDelete});

  bool get _isNow {
    final now = DateTime.now();
    return now.isAfter(course.startTime) && now.isBefore(course.endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: _isNow ? _kAmber.withOpacity(0.08) : ISPMColors.grey900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: _isNow ? _kAmber.withOpacity(0.40) : ISPMColors.white.withOpacity(0.06),
              width: _isNow ? 1.5 : 1.0)),
      child: Row(children: [
        // Date bloc
        Container(width: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: _isNow ? _kAmber.withOpacity(0.15) : ISPMColors.grey800,
                borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text(course.startTime.day.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _isNow ? _kAmber : ISPMColors.white)),
              Text(['jan','fév','mar','avr','mai','jun','jul',
                'aoû','sep','oct','nov','déc'][course.startTime.month - 1],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                      color: ISPMColors.white.withOpacity(0.40))),
            ])),

        const SizedBox(width: 13),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                if (_isNow) ...[
                  Container(padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: _kAmber,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text('EN COURS',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 8,
                              fontWeight: FontWeight.w700, color: ISPMColors.white,
                              letterSpacing: 0.4))),
                  const SizedBox(width: 6),
                ],
                Expanded(child: Text(course.title,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14,
                        fontWeight: FontWeight.w600, color: ISPMColors.white),
                    overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 4),
              Text('${course.fieldOfStudy} · ${course.professorName}',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                      color: ISPMColors.white.withOpacity(0.38)),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.access_time_rounded, size: 12,
                    color: ISPMColors.white.withOpacity(0.30)),
                const SizedBox(width: 4),
                Text(course.timeRange, style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 11, color: ISPMColors.white.withOpacity(0.40))),
              ]),
            ])),

        Column(children: [
          _SmallBtn(icon: Icons.edit_rounded, color: _kAmber,
              onTap: () => onEdit(course)),
          const SizedBox(height: 6),
          _SmallBtn(icon: Icons.delete_outline_rounded, color: ISPMColors.error,
              onTap: () => onDelete(course)),
        ]),
      ]),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SmallBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(width: 32, height: 32,
          decoration: BoxDecoration(
              color: color.withOpacity(0.11), borderRadius: BorderRadius.circular(9),
              border: Border.all(color: color.withOpacity(0.25))),
          child: Icon(icon, size: 15, color: color)));
}

// ── Formulaire cours (BottomSheet) ────────────────────────────────────────────

class _CourseFormSheet extends StatefulWidget {
  final _AdminCourse? course;
  final String token;
  const _CourseFormSheet({this.course, required this.token});

  @override
  State<_CourseFormSheet> createState() => _CourseFormSheetState();
}

class _CourseFormSheetState extends State<_CourseFormSheet> {
  final _title  = TextEditingController();
  final _field  = TextEditingController();
  final _profId = TextEditingController();
  DateTime _start = DateTime.now();
  DateTime _end   = DateTime.now().add(const Duration(hours: 2));
  bool _loading   = false;

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _title.text  = widget.course!.title;
      _field.text  = widget.course!.fieldOfStudy;
      _profId.text = widget.course!.professorName;
      _start       = widget.course!.startTime;
      _end         = widget.course!.endTime;
    }
  }

  @override
  void dispose() {
    _title.dispose(); _field.dispose(); _profId.dispose();
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
                  primary: _kAmber, onSurface: ISPMColors.white)),
          child: child!),
    );
    if (picked != null) {
      setState(() {
        final base = isStart ? _start : _end;
        final dt = DateTime(base.year, base.month, base.day,
            picked.hour, picked.minute);
        if (isStart) _start = dt; else _end = dt;
      });
    }
  }

  Future<void> _submit() async {
    if (_title.text.isEmpty || _field.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final body = jsonEncode({
        'title':       _title.text.trim(),
        'fieldOfStudy': _field.text.trim(),
        'professorId': _profId.text.trim(),
        'startTime':   _start.toIso8601String(),
        'endTime':     _end.toIso8601String(),
      });
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };
      final http.Response res;
      if (_isEdit) {
        res = await http.put(
            Uri.parse('${AppConfig.baseUrl}/api/admin/courses/${widget.course!.id}'),
            headers: headers, body: body);
      } else {
        res = await http.post(
            Uri.parse('${AppConfig.baseUrl}/api/admin/courses'),
            headers: headers, body: body);
      }
      if (mounted) {
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.pop(context, true);
        } else {
          final data = jsonDecode(res.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(data['error'] ?? 'Erreur',
                  style: const TextStyle(fontFamily: 'Poppins')),
              backgroundColor: ISPMColors.error));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString(),
              style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: ISPMColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: const BoxDecoration(
          color: ISPMColors.grey900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 36, height: 4,
                decoration: BoxDecoration(
                    color: ISPMColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(_isEdit ? 'Modifier le cours' : 'Nouveau cours',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18,
                    fontWeight: FontWeight.w700, color: ISPMColors.white)),
            const SizedBox(height: 18),

            _SimpleField(label: 'Titre du cours', controller: _title,
                icon: Icons.menu_book_rounded),
            _SimpleField(label: 'Filière / Classe', controller: _field,
                icon: Icons.group_outlined),
            _SimpleField(label: 'ID ou nom du professeur', controller: _profId,
                icon: Icons.person_outline_rounded),

            // Horaires
            const SizedBox(height: 4),
            Text('HORAIRES', style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                fontWeight: FontWeight.w600, letterSpacing: 0.8,
                color: ISPMColors.white.withOpacity(0.45))),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _TimeSelector(label: 'Début',
                  time: _fmtTime(_start),
                  onTap: () => _pickTime(true))),
              const SizedBox(width: 12),
              Expanded(child: _TimeSelector(label: 'Fin',
                  time: _fmtTime(_end),
                  onTap: () => _pickTime(false))),
            ]),

            const SizedBox(height: 22),
            IspmButton(
                text: _isEdit ? 'Enregistrer' : 'Créer le cours',
                onPressed: _submit, isLoading: _loading,
                icon: _isEdit ? Icons.save_rounded : Icons.add_rounded),
          ]),
    );
  }
}

class _SimpleField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  const _SimpleField({required this.label, required this.controller,
    required this.icon});

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
          decoration: BoxDecoration(
              color: ISPMColors.grey800, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ISPMColors.white.withOpacity(0.08))),
          child: TextField(
              controller: controller,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
                  color: ISPMColors.white),
              cursorColor: _kAmber,
              decoration: InputDecoration(
                  hintText: label,
                  hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                      color: ISPMColors.white.withOpacity(0.35)),
                  prefixIcon: Icon(icon, size: 17,
                      color: ISPMColors.white.withOpacity(0.40)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13)))));
}

class _TimeSelector extends StatelessWidget {
  final String label, time;
  final VoidCallback onTap;
  const _TimeSelector({required this.label, required this.time,
    required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
              color: ISPMColors.grey800, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ISPMColors.white.withOpacity(0.08))),
          child: Row(children: [
            Icon(Icons.access_time_rounded, size: 16,
                color: _kAmber.withOpacity(0.70)),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                  color: ISPMColors.white.withOpacity(0.40))),
              Text(time, style: const TextStyle(fontFamily: 'Poppins',
                  fontSize: 15, fontWeight: FontWeight.w700, color: ISPMColors.white)),
            ]),
          ])));
}