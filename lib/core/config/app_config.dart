// lib/core/config/app_config.dart

/// ✅ Configuration centralisée de l'application.
/// Modifiez uniquement ici pour changer l'URL du serveur.
///
/// Pour injecter via --dart-define au build :
///   flutter run --dart-define=BASE_URL=http://192.168.1.100:3000
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.1.175:3000',
  );
}
