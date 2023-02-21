import 'package:bloc/bloc.dart';
import 'package:discryptor/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepo) : super(const RegisterState());

  final AuthRepo authRepo;

  void passwordChanged(String pw) => emit(
      state.copyWith(status: RegisterStatus.initial, password: pw, error: ''));
  void confirmedPwChanged(String pw) => emit(state.copyWith(
      status: RegisterStatus.initial, confirmedPassword: pw, error: ''));

  Future<void> register() async {
    try {
      if (state.password.isEmpty) {
        emit(state.copyWith(
            status: RegisterStatus.error, error: 'Password is required.'));
        return;
      }
      if (state.confirmedPassword != state.password) {
        emit(state.copyWith(
            status: RegisterStatus.error,
            error: 'Confirmed password must match password.'));
        return;
      }
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.error, error: '$e'));
    }
  }
}
