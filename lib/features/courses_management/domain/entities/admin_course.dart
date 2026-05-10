// lib/features/admin/courses/domain/entities/admin_course.dart
//
// ✅ NOUVEAU : CoursesPage utilisait http direct + _AdminCourse local.
//    On extrait l'entity dans domain/ et on crée le BLoC complet.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_course.freezed.dart';

@freezed
abstract class AdminCourse with _$AdminCourse {
  const AdminCourse._();

  const factory AdminCourse({
    required String id,
    required String title,
    required String fieldOfStudy,
    required String professorName,
    required String professorId,
    required DateTime startTime,
    required DateTime endTime,
    @Default(true) bool isActive,
  }) = _AdminCourse;

  // ── Computed ──────────────────────────────────────────────────────────────
  String get timeRange => '${_fmt(startTime)} – ${_fmt(endTime)}';

  bool get isNow {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  String get dateLabel {
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    const months = [
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
    ];
    return '${days[startTime.weekday - 1]} ${startTime.day} ${months[startTime.month - 1]}';
  }

  static String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
