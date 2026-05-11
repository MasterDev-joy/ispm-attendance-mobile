// lib/features/stats/data/datasources/stats_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/dio_client.dart';
import '../../domain/entities/stats_data.dart';
import '../models/stats_model.dart';

abstract class StatsRemoteDataSource {
  Future<GlobalStats> fetchStats(StatsPeriod period);
}

@LazySingleton(as: StatsRemoteDataSource)
class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final Dio _dio;
  StatsRemoteDataSourceImpl(this._dio);

  @override
  Future<GlobalStats> fetchStats(StatsPeriod period) async {
    final res = await _dio.get(
      '/api/stats',
      queryParameters: {'period': _periodStr(period)},
    );
    return StatsModel.fromJson(res.data as Map<String, dynamic>);
  }

  String _periodStr(StatsPeriod p) => switch (p) {
    StatsPeriod.month => 'month',
    StatsPeriod.semester => 'semester',
    StatsPeriod.all => 'all',
  };
}
