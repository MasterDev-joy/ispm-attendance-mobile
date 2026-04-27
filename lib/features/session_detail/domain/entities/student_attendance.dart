// lib/features/session_detail/domain/entities/student_attendance.dart

enum AttendanceStatus { present, absent, late }

class StudentAttendance {
  final String id;
  final String studentName;
  final String studentInitials;
  final AttendanceStatus status;
  final DateTime? scanTime;    // null si absent
  final int? lateMinutes;      // null si pas en retard

  const StudentAttendance({
    required this.id,
    required this.studentName,
    required this.studentInitials,
    required this.status,
    this.scanTime,
    this.lateMinutes,
  });

  bool get isPresent => status == AttendanceStatus.present;
  bool get isAbsent  => status == AttendanceStatus.absent;
  bool get isLate    => status == AttendanceStatus.late;
}