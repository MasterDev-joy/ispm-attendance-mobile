// lib/features/admin/users/presentation/blocs/user_bloc.dart
//
// ✅ AVANT : Equatable + enum UserStatus + copyWith manuel
//    APRÈS : @freezed sealed class — state.when() dans la page
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../../../../core/error/failures.dart';

part 'user_bloc.freezed.dart';
part 'user_event.dart';
part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers _getUsers;
  final ToggleUser _toggleUser;
  final SaveUser _saveUser;

  UserBloc(this._getUsers, this._toggleUser, this._saveUser)
    : super(const UserState.initial()) {
    on<_Load>(_onLoad);
    on<_Toggle>(_onToggle);
    on<_Save>(_onSave);
    on<_FilterChanged>(_onFilter);
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onLoad(_Load _, Emitter<UserState> emit) async {
    emit(const UserState.loading());
    final result = await _getUsers();
    result.fold(
      (f) => emit(UserState.error(_msg(f))),
      (users) => emit(
        UserState.loaded(
          users: users,
          filtered: users,
          filter: 'all',
          query: '',
        ),
      ),
    );
  }

  Future<void> _onToggle(_Toggle event, Emitter<UserState> emit) async {
    final result = await _toggleUser(event.userId);
    result.fold(
      (f) => emit(UserState.error(_msg(f))),
      (_) => add(const UserEvent.load()),
    );
  }

  Future<void> _onSave(_Save event, Emitter<UserState> emit) async {
    emit(const UserState.saving());
    final result = await _saveUser(
      id: event.id,
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      role: event.role,
    );
    result.fold((f) => emit(UserState.error(_msg(f))), (_) {
      emit(const UserState.saveDone());
      add(const UserEvent.load());
    });
  }

  void _onFilter(_FilterChanged event, Emitter<UserState> emit) {
    final current = state.whenOrNull(
      loaded: (users, filtered, filter, query) => users,
    );
    if (current == null) return;
    final newFiltered = _applyFilter(current, event.filter, event.query);
    emit(
      UserState.loaded(
        users: current,
        filtered: newFiltered,
        filter: event.filter,
        query: event.query,
      ),
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  List<AdminUser> _applyFilter(
    List<AdminUser> users,
    String filter,
    String query,
  ) {
    final q = query.toLowerCase();
    return users.where((u) {
      final matchRole =
          filter == 'all' ||
          (filter == 'professor' && u.isProfessor) ||
          (filter == 'supervisor' && u.isSupervisor);
      final matchSearch =
          q.isEmpty ||
          u.fullName.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
      return matchRole && matchSearch;
    }).toList();
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
