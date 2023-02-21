import 'package:bloc/bloc.dart';
import 'package:discryptor/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

part 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit(this.authRepo) : super(const ChallengeState());

  final AuthRepo authRepo;

  Future<void> getChallenge() async {
    try {
      emit(state.copyWith(status: ChallengeStatus.fetching));
      String? challenge = await authRepo.getChallenge();
      if (challenge == null) {
        emit(state.copyWith(
            status: ChallengeStatus.error, error: 'Something went wrong.'));
      }
      emit(state.copyWith(
          status: ChallengeStatus.success, challenge: challenge));
    } catch (e) {
      emit(state.copyWith(status: ChallengeStatus.error));
    }
  }
}
