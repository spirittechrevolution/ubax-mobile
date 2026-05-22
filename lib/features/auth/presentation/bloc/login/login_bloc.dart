import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../../../domain/repositories/auth_repository.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({required this.phone, required this.password});
  final String phone;
  final String password;
  @override
  List<Object?> get props => [phone, password];
}

enum LoginStatus { idle, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({this.status = LoginStatus.idle, this.errorMessage});

  final LoginStatus status;
  final String? errorMessage;

  LoginState copyWith({LoginStatus? status, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._repository) : super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthRepository _repository;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _repository.loginByPhone(
        phone: event.phone,
        password: event.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: AppErrors.translate(e)));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Erreur inattendue',
      ));
    }
  }
}
