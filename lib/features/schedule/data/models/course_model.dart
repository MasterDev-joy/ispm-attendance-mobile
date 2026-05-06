import '../../domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.title,
    required super.fieldOfStudy,
    required super.professorName,
    required super.startTime,
    required super.endTime,
  });

  // Convertit le JSON du backend Node.js en objet Dart
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      fieldOfStudy: json['field_of_study'],
      professorName: json['professor'] != null ? '${json['professor']['firstName']} ${json['professor']['lastName']}' : 'Professeur inconnu',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}