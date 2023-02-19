import 'package:bloc/bloc.dart';
import 'package:discryptor/repos/api_repo.dart';
import 'package:equatable/equatable.dart';

part 'invite_state.dart';

class InviteCubit extends Cubit<InviteState> {
  InviteCubit(this.apiRepo) : super(const InviteState());

  final ApiRepo apiRepo;

  Future<void> getLink() async {
    try {
      emit(state.copyWith(status: InviteStatus.busy, error: ''));
      String? link = await apiRepo.getInviteLink();
      if (link == null) {
        emit(state.copyWith(
            status: InviteStatus.error,
            error: 'Please verify your Internet connection.'));
        return;
      }
      emit(InviteState(status: InviteStatus.success, inviteLink: link));
    } catch (e) {
      emit(state.copyWith(status: InviteStatus.error, error: '$e'));
    }
  }
}
