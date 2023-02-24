import 'package:bloc/bloc.dart';
import 'package:discryptor/models/models.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/utils/discord_name.dart';
import 'package:equatable/equatable.dart';

part 'name_state.dart';

class NameCubit extends Cubit<NameState> {
  NameCubit(this.apiRepo, this.prefsRepo) : super(const NameState());

  final ApiRepo apiRepo;
  final PreferenceRepo prefsRepo;

  void nameChanged(String name) {
    emit(state.copyWith(
        status: NameStatus.initial, fullname: name, message: ''));
  }

  Future<bool> getUserFromPrefs() async {
    String? username = await prefsRepo.username;
    String? salt = await prefsRepo.salt;
    int? userId = await prefsRepo.userId;
    String? fullname = await prefsRepo.fullname;

    if (username != null && salt != null && userId != null) {
      final pubData = UserPubSearchResult(
          passwordSalt: salt,
          result: UserPubSearchResultState.found,
          userId: userId);
      emit(state.copyWith(
          status: NameStatus.success, result: pubData, fullname: fullname!));
      return true;
    } else {
      emit(state.copyWith(
          status: NameStatus.error, message: 'No user found locally'));
      return false;
    }
  }

  Future<void> getUserFromApi() async {
    try {
      if (state.fullname.isEmpty) {
        emit(state.copyWith(
            status: NameStatus.error,
            message: 'Please enter your full Discord username.'));
        return;
      }
      final parsed = parseFullDiscordName(state.fullname);
      if (parsed[0] == false) {
        emit(state.copyWith(
            status: NameStatus.error,
            message:
                'Invalid Discord username. Must be of the form Username#1234.'));
        return;
      }
      emit(state.copyWith(status: NameStatus.busy));
      ApiResponse<UserPubSearchResult> response = await apiRepo
          .publicSearchUser(parsed[1].toString(), parsed[2].toString());
      if (!response.isSuccess) {
        emit(state.copyWith(
            status: NameStatus.error, message: response.message));
        return;
      }
      UserPubSearchResult d = response.content!;
      prefsRepo.setPublicUserData(state.fullname, d.passwordSalt, d.userId);
      emit(NameState(
          status: NameStatus.success, result: d, fullname: state.fullname));
    } catch (e) {
      emit(state.copyWith(status: NameStatus.error, message: '$e'));
    }
  }
}
