abstract class QrRepository {
  /// Repository responsable de récupérer le payload QR depuis le serveur.
  /// Le secret HMAC ne quitte JAMAIS le backend — Flutter reçoit seulement le résultat.
  Future<String> fetchQrPayload(String courseId);
}
