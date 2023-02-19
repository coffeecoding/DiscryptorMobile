part of 'login_cubit.dart';

enum LoginStatus { initial, busy, error, loggedIn }

class LoginState extends Equatable {
  const LoginState(
      {this.status = LoginStatus.initial,
      this.password = '',
      this.message = ''});

  LoginState copyWith(
          {LoginStatus? status,
          String? username,
          String? password,
          String? message}) =>
      LoginState(
          status: status ?? this.status,
          password: password ?? this.password,
          message: message ?? this.message);

  final LoginStatus status;
  final String password;
  final String message;

  @override
  List<Object> get props => [status, password, message];
}
