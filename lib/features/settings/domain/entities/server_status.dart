import 'package:freezed_annotation/freezed_annotation.dart';
part 'server_status.freezed.dart';

@freezed
abstract class ServerStatus with _$ServerStatus {
  const factory ServerStatus({
    required bool isOnline,
    required String message,
    required String baseUrl,
  }) = _ServerStatus;
}
