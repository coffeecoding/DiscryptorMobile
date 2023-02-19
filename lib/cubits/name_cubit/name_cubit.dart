import 'package:bloc/bloc.dart';
import 'package:discryptor/models/models.dart';
import 'package:discryptor/repos/api_repo.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/utils/discord_name.dart';
import 'package:equatable/equatable.dart';

part 'name_state.dart';

class NameCubit extends Cubit<NameState> {
  NameCubit(this.apiRepo, this.prefsRepo) : super(const NameState());

  final ApiRepo apiRepo;
  final PreferenceRepo prefsRepo;

  Future<void> getUserByFullname() async {
    try {
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
      emit(NameState(status: NameStatus.success, fullname: state.fullname));
    } catch (e) {
      emit(state.copyWith(status: NameStatus.error, message: '$e'));
    }
  }
}
