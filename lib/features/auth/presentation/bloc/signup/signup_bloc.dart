import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../../../domain/repositories/auth_repository.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignupSendOtp extends SignupEvent {
  const SignupSendOtp({required this.phone});
  final String phone;
  @override
  List<Object?> get props => [phone];
}

class SignupResendOtp extends SignupEvent {
  const SignupResendOtp({required this.phone});
  final String phone;
  @override
  List<Object?> get props => [phone];
}

class SignupVerifyOtp extends SignupEvent {
  const SignupVerifyOtp({required this.phone, required this.code});
  final String phone;
  final String code;
  @override
  List<Object?> get props => [phone, code];
}

class SignupComplete extends SignupEvent {
  const SignupComplete({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.title,
  });
  final String phone;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? title;
  @override
  List<Object?> get props => [phone, firstName, lastName, email, password, title];
}

enum SignupStatus {
  idle,
  sendingOtp,
  otpSent,
  verifyingOtp,
  otpVerified,
  completing,
  completed,
  failure,
}

class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.idle,
    this.phone,
    this.errorMessage,
  });

  final SignupStatus status;
  final String? phone;
  final String? errorMessage;

  SignupState copyWith({
    SignupStatus? status,
    String? phone,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, phone, errorMessage];
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(this._repository) : super(const SignupState()) {
    on<SignupSendOtp>(_onSendOtp);
    on<SignupResendOtp>(_onResendOtp);
    on<SignupVerifyOtp>(_onVerifyOtp);
    on<SignupComplete>(_onComplete);
  }

  final AuthRepository _repository;

  Future<void> _onSendOtp(
    SignupSendOtp event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.sendingOtp, phone: event.phone));
    try {
      await _repository.registerSendOtp(phone: event.phone);
      emit(state.copyWith(status: SignupStatus.otpSent, phone: event.phone));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        phone: event.phone,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onResendOtp(
    SignupResendOtp event,
    Emitter<SignupState> emit,
  ) async {
    try {
      await _repository.registerSendOtp(phone: event.phone);
      emit(state.copyWith(status: SignupStatus.otpSent, phone: event.phone));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        phone: event.phone,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onVerifyOtp(
    SignupVerifyOtp event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.verifyingOtp, phone: event.phone));
    try {
      await _repository.registerVerifyOtp(
        phone: event.phone,
        code: event.code,
      );
      emit(state.copyWith(status: SignupStatus.otpVerified, phone: event.phone));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        phone: event.phone,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onComplete(
    SignupComplete event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.completing, phone: event.phone));
    try {
      await _repository.registerComplete(
        phone: event.phone,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        title: event.title,
      );
      await _repository.loginByPhone(
        phone: event.phone,
        password: event.password,
      );
      emit(state.copyWith(status: SignupStatus.completed, phone: event.phone));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        phone: event.phone,
        errorMessage: e.message,
      ));
    }
  }
}
