// lib/core/error/failures.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.server(String message) = ServerFailure;
  const factory Failure.network() = NetworkFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure;
  const factory Failure.forbidden() = ForbiddenFailure;
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}
