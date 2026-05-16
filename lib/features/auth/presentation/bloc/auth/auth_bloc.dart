import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/auth_user.dart';
import '../../../domain/repositories/auth_repository.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthSignedIn extends AuthEvent {
  const AuthSignedIn();
}

class AuthSignedOut extends AuthEvent {
  const AuthSignedOut();
}

class AuthProfileRefreshed extends AuthEvent {
  const AuthProfileRefreshed();
}

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({required this.status, this.currentUser});

  final AuthStatus status;
  final AuthUser? currentUser;

  const AuthState.unknown()
      : status = AuthStatus.unknown,
        currentUser = null;
  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        currentUser = null;
  const AuthState.authenticated({this.currentUser})
      : status = AuthStatus.authenticated;

  AuthState copyWith({AuthStatus? status, AuthUser? currentUser}) {
    return AuthState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [status, currentUser];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignedIn>(_onSignedIn);
    on<AuthSignedOut>(_onSignedOut);
    on<AuthProfileRefreshed>(_onProfileRefreshed);
  }

  final AuthRepository _repository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final hasSession = await _repository.hasSession();
    if (!hasSession) {
      emit(const AuthState.unauthenticated());
      return;
    }
    emit(const AuthState.authenticated());
    await _loadProfile(emit, forceRefresh: false);
  }

  Future<void> _onSignedIn(
    AuthSignedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.authenticated());
    await _loadProfile(emit, forceRefresh: true);
  }

  Future<void> _onSignedOut(
    AuthSignedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onProfileRefreshed(
    AuthProfileRefreshed event,
    Emitter<AuthState> emit,
  ) =>
      _loadProfile(emit, forceRefresh: true);

  Future<void> _loadProfile(
    Emitter<AuthState> emit, {
    required bool forceRefresh,
  }) async {
    try {
      final user = await _repository.getCurrentUser(forceRefresh: forceRefresh);
      if (state.status == AuthStatus.authenticated) {
        emit(AuthState.authenticated(currentUser: user));
      }
    } catch (_) {}
  }
}
