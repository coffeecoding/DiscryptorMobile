// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'challenge_cubit.dart';

enum ChallengeStatus { initial, fetching, success, error }

class ChallengeState extends Equatable {
  const ChallengeState(
      {this.status = ChallengeStatus.initial, this.challenge, this.error = ''});

  ChallengeState copyWith(
          {ChallengeStatus? status, String? challenge, String? error}) =>
      ChallengeState(
          status: status ?? this.status,
          challenge: challenge ?? this.challenge,
          error: error ?? this.error);

  final ChallengeStatus status;
  final String? challenge;
  final String error;

  @override
  List<Object?> get props => [status, challenge, error];
}
