// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'name_cubit.dart';

enum NameStatus { initial, busy, success, error }

class NameState extends Equatable {
  const NameState(
      {this.status = NameStatus.initial,
      this.fullname = '',
      this.message = ''});

  NameState copyWith({
    NameStatus? status,
    String? fullname,
    String? message,
  }) {
    return NameState(
      status: status ?? this.status,
      fullname: fullname ?? this.fullname,
      message: message ?? this.message,
    );
  }

  final NameStatus status;
  final String fullname;
  final String message;

  @override
  List<Object> get props => [status, fullname, message];
}
