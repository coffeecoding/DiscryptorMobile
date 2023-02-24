import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/models/models.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.prefsRepo, this.authRepo, this.challengeCubit)
      : super(const AuthState());

  final PreferenceRepo prefsRepo;
  final AuthRepo authRepo;
  final ChallengeCubit challengeCubit;

  Future<bool> resumeAuth() async {
    try {
      emit(const AuthState(status: AuthStatus.authenticating));
      final user = await authRepo.initAuth();
      if (user == null) {
        emit(AuthState.unauthenticated());
        return false;
      }
      emit(AuthState(status: AuthStatus.authenticated, user: user));
      return true;
    } catch (e) {
      print('Init auth failed: $e');
      // do nothing: We will stay unauthenticated for now
      emit(AuthState(status: AuthStatus.autherror, error: '$e'));
      return false;
    }
  }

  Future<void> authenticate() async {
    try {
      String? challenge = challengeCubit.state.challenge;
      if (challenge == null) return;
      int? userId = await prefsRepo.userId;
      if (userId == null) return; // should never happen
      emit(state.copyWith(status: AuthStatus.authenticating, error: ''));
      AuthPayload p = AuthPayload(userId: userId, challengeToken: challenge);
      ApiResponse<AuthResult> authResult = await authRepo.authenticate(p);
      if (!authResult.isSuccess) {
        emit(AuthState.unauthenticated(error: 'Authentication failed.'));
        return;
      }
      emit(state.copyWith(
          status: AuthStatus.authenticated, user: authResult.content!.user));
    } catch (e) {
      print('Authentication failed: $e');
      emit(AuthState.unauthenticated(error: '$e'));
    }
  }

  void logout() {
    // todo: stop websocket, delete tokens etc
    prefsRepo.clearPublicDataAndUser();
    prefsRepo.clearAuth();
    emit(AuthState.unauthenticated());
  }
}
