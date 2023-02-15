import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

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
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, message: '$e'));
    }
  }

  void logout() {
    emit(
        state.copyWith(status: LoginStatus.initial, password: '', message: ''));
  }

  bool validateForm() {
    return true;
  }
}
