import 'package:bloc/bloc.dart';
import 'package:discryptor/models/api_response.dart';
import 'package:discryptor/models/credentials.dart';
import 'package:discryptor/utils/credentials.dart';
import 'package:equatable/equatable.dart';

import '../../repos/repos.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepo, this.prefRepo) : super(const RegisterState());

  final AuthRepo authRepo;
  final PreferenceRepo prefRepo;

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
      final userId = await prefRepo.userId;
      final salt64 = await prefRepo.salt;
      if (userId == null || salt64 == null) {
        // highly unexpected, shouldn't ever happen
        emit(state.copyWith(
            status: RegisterStatus.error, error: 'Error: Missing data.'));
        return;
      }
      Credentials newCreds =
          await createCredentials(userId, salt64, state.password);
      ApiResponse<bool> re = await authRepo.register(newCreds);
      if (!re.isSuccess) {
        emit(state.copyWith(status: RegisterStatus.error, error: re.message));
        return;
      }
      emit(state.copyWith(status: RegisterStatus.success, error: ''));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.error, error: '$e'));
    }
  }
}
