part of 'auth_cubit.dart';

enum AuthStatus { authenticated, unauthenticated, autherror }

class AuthState extends Equatable {
  const AuthState(
      {this.status = AuthStatus.unauthenticated, this.user, this.error = ''});

  factory AuthState.unauthenticated() => const AuthState();

  AuthState copyWith({
    AuthStatus? status,
    DiscryptorUserWithRelationship? user,
    String? error,
  }) =>
      AuthState(
          status: status ?? this.status,
          user: user ?? this.user,
          error: error ?? this.error);

  final AuthStatus status;
  final DiscryptorUserWithRelationship? user;
  final String error;

  @override
  List<Object?> get props => [status, user, error];
}
