import 'package:bloc/bloc.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/extensions/list_ext.dart';
import 'package:discryptor/repos/api_repo.dart';
import 'package:equatable/equatable.dart';

part 'statuses_state.dart';

class StatusesCubit extends Cubit<StatusesState> {
  StatusesCubit()
      : apiRepo = locator.get<ApiRepo>(),
        super(const StatusesState());

  final ApiRepo apiRepo;

  Future<void> getStatuses() async {
    try {
      emit(state.copyWith(status: StatusesStatus.busy));
      final re = await apiRepo.getUserStatuses();
      if (!re.isSuccess) {
        // Todo: handle. Not too crucial
        return;
      }
      final idToStatus = re.content!.toMap();
      emit(
          state.copyWith(status: StatusesStatus.success, statuses: idToStatus));
    } catch (e) {
      print('Failed to get statuses $e');
      // Todo: consider how to handle: Either leave state as is or set all to offline
    }
  }
}
