// lib/features/schedule/domain/entities/course.dart
class Course {
  final String id;
  final String title;
  final String fieldOfStudy;
  final DateTime startTime;
  final DateTime endTime;

  Course({
    required this.id,
    required this.title,
    required this.fieldOfStudy,
    required this.startTime,
    required this.endTime,
  });
}