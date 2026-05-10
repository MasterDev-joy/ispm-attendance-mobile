// lib/features/stats/presentation/blocs/stats_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/stats_data.dart';
import '../../domain/usecases/get_stats.dart';
import '../../../../../core/error/failures.dart';

part 'stats_bloc.freezed.dart';
part 'stats_event.dart';
part 'stats_state.dart';

@injectable
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStats _getStats;

  StatsBloc(this._getStats) : super(const StatsState.initial()) {
    on<_Load>(_onLoad);
    on<_ChangePeriod>(_onChangePeriod);
  }

  Future<void> _onLoad(_Load event, Emitter<StatsState> emit) async {
    emit(const StatsState.loading());
    await _fetchAndEmit(event.period, emit);
  }

  Future<void> _onChangePeriod(
    _ChangePeriod event,
    Emitter<StatsState> emit,
  ) async {
    emit(const StatsState.loading());
    await _fetchAndEmit(event.period, emit);
  }

  Future<void> _fetchAndEmit(
    StatsPeriod period,
    Emitter<StatsState> emit,
  ) async {
    final result = await _getStats(period);
    result.fold(
      (f) => emit(StatsState.error(_msg(f))),
      (data) => emit(StatsState.loaded(data: data, period: period)),
    );
  }

  String _msg(Failure f) => f.when(
    server: (m) => m,
    network: () => 'Pas de connexion réseau',
    unauthorized: () => 'Session expirée',
    forbidden: () => 'Accès refusé',
    cache: (m) => m,
    unknown: (m) => m,
  );
}
