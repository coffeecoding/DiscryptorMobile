part of 'auth_cubit.dart';

// this is referring to auth state with *Discord*.
enum AuthStatus { authenticating, authenticated, unauthenticated, autherror }

class AuthState extends Equatable {
  const AuthState(
      {this.status = AuthStatus.unauthenticated, this.user, this.error = ''});

  factory AuthState.unauthenticated({String? error}) =>
      AuthState(error: error ?? '');

  AuthState copyWith({
    AuthStatus? status,
    DiscryptorUser? user,
    String? error,
  }) =>
      AuthState(
          status: status ?? this.status,
          user: user ?? this.user,
          error: error ?? this.error);

  final AuthStatus status;
  final DiscryptorUser? user;
  final String error;

  @override
  List<Object?> get props => [status, user, error];
}
