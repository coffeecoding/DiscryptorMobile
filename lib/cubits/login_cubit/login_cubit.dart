import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/auth/auth_cubit.dart';
import 'package:discryptor/models/auth_result.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authCubit) : super(const LoginState());

  final AuthCubit authCubit;

  void usernameChanged(String username) {
    emit(state.copyWith(username: username));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> login(String username, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.busy));
      if (!validateForm()) return;
      await Future.delayed(const Duration(milliseconds: 400));
      // Todo retrieve data, such as user etc..
      // Todo: Test with actually valid json result from desktop client
      AuthResult authResult = AuthResult.fromJson('dummy json');
      emit(state.copyWith(status: LoginStatus.success));
      // load rest of data
      authCubit.onAuthenticated(authResult);
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, message: '$e'));
    }
  }

  void logout() {
    try {
      authCubit.logout();
      emit(state.copyWith(
          status: LoginStatus.initial, password: '', message: ''));
    } catch (e) {
      // todo: handle
    }
  }

  bool validateForm() {
    return true;
  }
}
