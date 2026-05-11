import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/session_attendance.dart';
import '../repositories/session_detail_repository.dart';

@lazySingleton
class GetSessionDetailsUseCase {
  final SessionDetailRepository _repository;

  GetSessionDetailsUseCase(this._repository);

  /// La méthode call permet d'appeler le usecase comme une fonction :
  /// final result = await getSessionDetailsUseCase(id);
  Future<Either<Failure, SessionAttendance>> call(String sessionId) {
    return _repository.getSessionDetails(sessionId);
  }
}
