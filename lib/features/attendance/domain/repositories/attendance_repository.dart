abstract class AttendanceRepository {
  /// Envoie les données scannées au serveur pour validation
  /// Retourne un Map contenant les infos du professeur si succès, ou lève une exception si erreur.
  Future<Map<String, dynamic>> validateAttendance({
    required String token,
    required String professorId,
    required String courseId,
  });
}