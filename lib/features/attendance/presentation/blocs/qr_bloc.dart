import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/usecases/get_qr_payload.dart';

part 'qr_bloc.freezed.dart';
part 'qr_event.dart';
part 'qr_state.dart';

@injectable
class QrBloc extends Bloc<QrEvent, QrState> {
  final GetQrPayload _getQrPayload;

  QrBloc(this._getQrPayload) : super(const QrState.initial()) {
    on<_Generate>(_onGenerate);
  }

  Future<void> _onGenerate(_Generate event, Emitter<QrState> emit) async {
    emit(const QrState.loading());

    // Appel du UseCase (Règle 3.1)
    final result = await _getQrPayload(event.courseId);

    // Règle 7 : Toujours propager les erreurs via Either
    result.fold(
      (failure) => emit(QrState.error(_mapFailureToMessage(failure))),
      (payload) => emit(QrState.success(payload)),
    );
  }

  String _mapFailureToMessage(Failure f) => f.when(
    server: (m) => m,
    network: () => 'Pas de connexion réseau',
    unauthorized: () => 'Session expirée',
    forbidden: () => 'Accès refusé',
    cache: (m) => m,
    unknown: (m) => m,
  );
}
