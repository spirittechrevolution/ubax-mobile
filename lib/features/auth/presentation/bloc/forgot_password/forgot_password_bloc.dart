import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../../../domain/repositories/auth_repository.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

class ForgotSendOtp extends ForgotPasswordEvent {
  const ForgotSendOtp({required this.phone});
  final String phone;
  @override
  List<Object?> get props => [phone];
}

class ForgotResendOtp extends ForgotPasswordEvent {
  const ForgotResendOtp({required this.phone});
  final String phone;
  @override
  List<Object?> get props => [phone];
}

class ForgotVerifyOtp extends ForgotPasswordEvent {
  const ForgotVerifyOtp({required this.phone, required this.code});
  final String phone;
  final String code;
  @override
  List<Object?> get props => [phone, code];
}

class ForgotResetPassword extends ForgotPasswordEvent {
  const ForgotResetPassword({
    required this.phone,
    required this.code,
    required this.newPassword,
  });
  final String phone;
  final String code;
  final String newPassword;
  @override
  List<Object?> get props => [phone, code, newPassword];
}

enum ForgotPasswordStatus {
  idle,
  sendingOtp,
  otpSent,
  verifyingOtp,
  otpVerified,
  resetting,
  resetDone,
  failure,
}

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.phone,
    this.code,
    this.errorMessage,
  });

  final ForgotPasswordStatus status;
  final String? phone;
  final String? code;
  final String? errorMessage;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? phone,
    String? code,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      code: code ?? this.code,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, phone, code, errorMessage];
}

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._repository) : super(const ForgotPasswordState()) {
    on<ForgotSendOtp>(_onSendOtp);
    on<ForgotResendOtp>(_onResendOtp);
    on<ForgotVerifyOtp>(_onVerifyOtp);
    on<ForgotResetPassword>(_onReset);
  }

  final AuthRepository _repository;

  Future<void> _onSendOtp(
    ForgotSendOtp event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(
      status: ForgotPasswordStatus.sendingOtp,
      phone: event.phone,
    ));
    try {
      await _repository.forgotPasswordSendOtp(phone: event.phone);
      emit(state.copyWith(
        status: ForgotPasswordStatus.otpSent,
        phone: event.phone,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        phone: event.phone,
        errorMessage: AppErrors.translate(e),
      ));
    }
  }

  Future<void> _onResendOtp(
    ForgotResendOtp event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    try {
      await _repository.forgotPasswordSendOtp(phone: event.phone);
      emit(state.copyWith(
        status: ForgotPasswordStatus.otpSent,
        phone: event.phone,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        phone: event.phone,
        errorMessage: AppErrors.translate(e),
      ));
    }
  }

  Future<void> _onVerifyOtp(
    ForgotVerifyOtp event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(
      status: ForgotPasswordStatus.verifyingOtp,
      phone: event.phone,
      code: event.code,
    ));
    try {
      await _repository.forgotPasswordVerifyOtp(
        phone: event.phone,
        code: event.code,
      );
      emit(state.copyWith(
        status: ForgotPasswordStatus.otpVerified,
        phone: event.phone,
        code: event.code,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        phone: event.phone,
        errorMessage: AppErrors.translate(e),
      ));
    }
  }

  Future<void> _onReset(
    ForgotResetPassword event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(
      status: ForgotPasswordStatus.resetting,
      phone: event.phone,
      code: event.code,
    ));
    try {
      await _repository.forgotPasswordReset(
        phone: event.phone,
        code: event.code,
        newPassword: event.newPassword,
      );
      emit(state.copyWith(
        status: ForgotPasswordStatus.resetDone,
        phone: event.phone,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        phone: event.phone,
        errorMessage: AppErrors.translate(e),
      ));
    }
  }
}
