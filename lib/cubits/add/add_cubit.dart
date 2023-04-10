import 'package:bloc/bloc.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/utils/discord_name.dart';
import 'package:equatable/equatable.dart';

part 'add_state.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit()
      : apiRepo = locator.get<ApiRepo>(),
        super(const AddState());

  final ApiRepo apiRepo;

  void inputChanged(String value) {
    emit(state.copyWith(status: AddStatus.initial, fullname: value, error: ''));
  }

  Future<void> refresh() async {
    if (state.result != null) {
      try {
        emit(state.copyWith(status: AddStatus.busy));
        final re = await apiRepo.getUser(state.result!.id);
        if (!re.isSuccess) {
          emit(state.copyWith(status: AddStatus.initial));
          return;
        }
        final uvm = UserViewModel(user: re.content!);
        emit(state.copyWith(status: AddStatus.success, result: uvm));
      } catch (e) {
        print("Error refreshing add screen: $e");
        emit(
            state.copyWith(status: AddStatus.error, error: 'Unexpected error'));
      }
    }
  }

  Future<void> executeSearch() async {
    try {
      emit(state.copyWith(status: AddStatus.busy, error: ''));
      final parts = parseFullDiscordName(state.fullname);
      if (parts[0] == false) {
        emit(
            state.copyWith(status: AddStatus.error, error: 'Invalid username'));
        return;
      }
      final re =
          await apiRepo.getUserByName(parts[1].toString(), parts[2].toString());
      if (!re.isSuccess) {
        if (re.httpStatus == 404) {
          emit(
              state.copyWith(status: AddStatus.error, error: "User not found"));
          return;
        }
        emit(state.copyWith(status: AddStatus.error, error: re.message));
        return;
      }
      final uvm = UserViewModel(user: re.content!);
      emit(state.copyWith(status: AddStatus.success, result: uvm));
    } catch (e) {
      print('Failed to search for user: $e');
      emit(state.copyWith(status: AddStatus.error, error: '$e'));
    }
  }
}
