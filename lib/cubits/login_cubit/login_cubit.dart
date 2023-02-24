import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authCubit, this.appCubit, this.authRepo, this.prefRepo)
      : super(const LoginState());

  final AuthCubit authCubit;
  final AppCubit appCubit;
  final AuthRepo authRepo;
  final PreferenceRepo prefRepo;

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
      bool socketSuccess = await authRepo.connectSignalR();
      if (!socketSuccess) {
        emit(state.copyWith(
            status: LoginStatus.error, message: 'SignalR connection failed'));
        return;
      }
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
    emit(
        state.copyWith(status: LoginStatus.initial, password: '', message: ''));
  }

  bool validateForm() {
    return true;
  }
}
