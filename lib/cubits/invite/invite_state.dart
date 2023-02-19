part of 'invite_cubit.dart';

enum InviteStatus { initial, busy, success, error }

class InviteState extends Equatable {
  const InviteState(
      {this.status = InviteStatus.initial,
      this.inviteLink = '',
      this.error = ''});

  InviteState copyWith(
          {InviteStatus? status, String? inviteLink, String? error}) =>
      InviteState(
          status: status ?? this.status,
          inviteLink: inviteLink ?? this.inviteLink,
          error: error ?? this.error);

  final InviteStatus status;
  final String inviteLink;
  final String error;

  @override
  List<Object> get props => [status, inviteLink, error];
}
