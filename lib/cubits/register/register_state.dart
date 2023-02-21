// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_cubit.dart';

enum RegisterStatus { initial, busy, success, error }

class RegisterState extends Equatable {
  const RegisterState(
      {this.status = RegisterStatus.initial,
      this.password = '',
      this.confirmedPassword = '',
      this.error = ''});

  RegisterState copyWith({
    RegisterStatus? status,
    String? password,
    String? confirmedPassword,
    String? error,
  }) {
    return RegisterState(
      status: status ?? this.status,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      error: error ?? this.error,
    );
  }

  final RegisterStatus status;
  final String password;
  final String confirmedPassword;
  final String error;

  @override
  List<Object> get props => [status, password, confirmedPassword, error];
}
