// lib/features/session_detail/domain/entities/session_attendance.dart
// Enregistrement de présence du PROFESSEUR pour une séance donnée

enum AttendanceStatus { onTime, absent, notScanned }

class SessionAttendance {
  /// ID de l'enregistrement Attendance en DB
  final String id;

  /// Statut de présence du professeur
  final AttendanceStatus status;

  /// Heure à laquelle le QR a été scanné (null si absent/non scanné)
  final DateTime? scanTime;

  /// Nom du surveillant (invigilator) qui a scanné
  final String? invigilatorName;

  /// Email du surveillant
  final String? invigilatorEmail;

  const SessionAttendance({
    required this.id,
    required this.status,
    this.scanTime,
    this.invigilatorName,
    this.invigilatorEmail,
  });

  factory SessionAttendance.fromJson(Map<String, dynamic> json) {
    AttendanceStatus status;
    switch (json['status'] as String?) {
      case 'ON_TIME':
        status = AttendanceStatus.onTime;
        break;
      case 'ABSENT':
        status = AttendanceStatus.absent;
        break;
      default:
        status = AttendanceStatus.notScanned;
    }

    return SessionAttendance(
      id: json['id'] as String? ?? '',
      status: status,
      scanTime: json['scanTime'] != null
          ? DateTime.tryParse(json['scanTime'] as String)
          : null,
      invigilatorName: json['invigilator']?['name'] as String?,
      invigilatorEmail: json['invigilator']?['email'] as String?,
    );
  }
}
