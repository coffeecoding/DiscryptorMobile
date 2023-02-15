part of 'login_cubit.dart';

enum LoginStatus { initial, busy, error, success }

class LoginState extends Equatable {
  const LoginState(
      {this.status = LoginStatus.initial,
      this.username = '',
      this.password = '',
      this.message = ''});

  LoginState copyWith(
          {LoginStatus? status,
          String? username,
          String? password,
          String? message}) =>
      LoginState(
          status: status ?? this.status,
          username: username ?? this.username,
          password: password ?? this.password,
          message: message ?? this.message);

  final LoginStatus status;
  final String username;
  final String password;
  final String message;

  @override
  List<Object> get props => [status, username, password, message];
}
