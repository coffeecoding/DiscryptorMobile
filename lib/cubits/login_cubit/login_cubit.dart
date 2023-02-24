// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authCubit, this.appCubit, this.statusesCubit)
      : authRepo = locator.get<AuthRepo>(),
        prefRepo = locator.get<PreferenceRepo>(),
        super(const LoginState());

  final AuthCubit authCubit;
  final AppCubit appCubit;
  final StatusesCubit statusesCubit;
  final AuthRepo authRepo;
  final PreferenceRepo prefRepo;

  late Timer _statusFetcher;

  void _startStatusFetcher() {
    print('Starting status fetcher ...');
    _statusFetcher = Timer.periodic(const Duration(seconds: 30), (timer) {
      statusesCubit.getStatuses();
    });
  }

  void _stopStatusFetcher() {
    _statusFetcher.cancel();
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, message: ''));
  }

  Future<void> login() async {
    try {
      if (state.password.isEmpty) {
        emit(state.copyWith(message: 'Password required'));
        return;
      }
      emit(state.copyWith(status: LoginStatus.busy));
      if (!validateForm()) return;
      final re = await authRepo.getCredentials();
      if (!re.isSuccess) {
        emit(state.copyWith(status: LoginStatus.error, message: re.message));
        return;
      }
      final creds = re.content!;
      bool pwCorrect = await prefRepo.decryptAndSavePrivateKey(
          state.password, creds.privateKeyEncrypted);
      if (!pwCorrect) {
        emit(state.copyWith(
            status: LoginStatus.error, message: 'Incorrect password'));
        return;
      }
      prefRepo.setCredentials(creds);
      String? fullname = await prefRepo.fullname;
      String? salt = await prefRepo.salt;
      prefRepo.setPublicUserData(fullname!, salt!, creds.userId);
      final user = await prefRepo.user;
      prefRepo.setUser(user!);
      bool socketSuccess = await authRepo.connectSignalR();
      if (!socketSuccess) {
        emit(state.copyWith(
            status: LoginStatus.error, message: 'SignalR connection failed'));
        return;
      }
      _startStatusFetcher();
      emit(state.copyWith(status: LoginStatus.loggedIn));
      appCubit.retrieveData();
    } catch (e) {
      print('e');
      emit(state.copyWith(status: LoginStatus.error, message: '$e'));
    }
  }

  /// Lock app behind password but don't clear auth data.
  void logoff() {
    prefRepo.clearPublicDataAndUser();
    _stopStatusFetcher();
    emit(
        state.copyWith(status: LoginStatus.initial, password: '', message: ''));
  }

  bool validateForm() {
    return true;
  }
}
