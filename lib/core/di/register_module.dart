import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  // Enregistre Dio
  @lazySingleton
  Dio get dio => Dio();
  // Note: Si tu as configuré ton propre DioClient avec des intercepteurs dans
  // 'core/network/dio_client.dart', instancie-le ici !

  // J'anticipe une future erreur : enregistre aussi FlutterSecureStorage !
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
