// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_cubit.dart';

enum AddStatus { initial, busy, success, error }

class AddState extends Equatable {
  const AddState(
      {this.status = AddStatus.initial,
      this.fullname = '',
      this.result,
      this.error = ''});

  AddState copyWith({
    AddStatus? status,
    String? fullname,
    UserViewModel? result,
    String? error,
  }) =>
      AddState(
          status: status ?? this.status,
          fullname: fullname ?? this.fullname,
          result: result ?? (status != AddStatus.error ? this.result : null),
          error: error ?? this.error);

  final AddStatus status;
  final String fullname;
  final UserViewModel? result;
  final String error;

  @override
  List<Object?> get props => [status, fullname, result, error];
}
