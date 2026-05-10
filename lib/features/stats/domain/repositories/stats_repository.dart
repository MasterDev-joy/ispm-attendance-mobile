// lib/features/stats/domain/repositories/stats_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failures.dart';
import '../entities/stats_data.dart';

abstract class StatsRepository {
  Future<Either<Failure, GlobalStats>> getStats(StatsPeriod period);
}
