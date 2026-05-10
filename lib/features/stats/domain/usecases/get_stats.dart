// lib/features/stats/domain/usecases/get_stats.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/stats_data.dart';
import '../repositories/stats_repository.dart';

@lazySingleton
class GetStats {
  final StatsRepository _repository;
  const GetStats(this._repository);

  Future<Either<Failure, GlobalStats>> call(StatsPeriod period) =>
      _repository.getStats(period);
}
