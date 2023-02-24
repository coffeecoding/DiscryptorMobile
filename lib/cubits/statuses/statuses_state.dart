// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'statuses_cubit.dart';

enum StatusesStatus { initial, busy, success, error }

class StatusesState extends Equatable {
  const StatusesState(
      {this.status = StatusesStatus.initial, this.statuses = const {}});

  StatusesState copyWith({
    StatusesStatus? status,
    Map<int, int>? statuses,
  }) =>
      StatusesState(
        status: status ?? this.status,
        statuses: statuses ?? this.statuses,
      );

  final StatusesStatus status;

  final Map<int, int> statuses;

  // https://discordnet.dev/api/Discord.UserStatus.html
  int statusByUserId(int userId) =>
      statuses.containsKey(userId) ? statuses[userId]! : 4;

  @override
  List<Object> get props => [status, statuses];
}
