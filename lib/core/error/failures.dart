// lib/core/error/failures.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  // 1. Ajout du constructeur privé (Obligatoire avec Freezed pour avoir des getters)
  const Failure._();

  const factory Failure.server(String message) = ServerFailure;
  const factory Failure.network() = NetworkFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure;
  const factory Failure.forbidden() = ForbiddenFailure;
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.unknown(String message) = UnknownFailure;

  // 2. Le getter est maintenant intégré directement à l'objet Failure
  String get errorMessage => when(
    server: (msg) => msg,
    cache: (msg) => msg,
    unknown: (msg) => msg,
    network: () => "Pas de connexion internet. Veuillez vérifier votre réseau.",
    unauthorized: () => "Session expirée ou identifiants incorrects.",
    forbidden: () => "Vous n'avez pas l'autorisation d'effectuer cette action.",
  );
}
