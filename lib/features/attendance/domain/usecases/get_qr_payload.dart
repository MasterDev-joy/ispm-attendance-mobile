// lib/features/attendance/domain/usecases/get_qr_payload.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/attendance_repository.dart';

@lazySingleton
class GetQrPayload {
  final QrRepository _repository;

  GetQrPayload(this._repository);

  // Règle 3.4 : Une seule méthode publique call()
  Future<Either<Failure, String>> call(String courseId) async {
    return await _repository.fetchQrPayload(courseId);
  }
}
