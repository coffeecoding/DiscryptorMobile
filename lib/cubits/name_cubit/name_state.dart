// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'name_cubit.dart';

enum NameStatus { initial, busy, success, error }

class NameState extends Equatable {
  const NameState(
      {this.status = NameStatus.initial,
      this.result,
      this.fullname = '',
      this.message = ''});

  NameState copyWith({
    NameStatus? status,
    UserPubSearchResult? result,
    String? fullname,
    String? message,
  }) {
    return NameState(
      status: status ?? this.status,
      result: result ?? this.result,
      fullname: fullname ?? this.fullname,
      message: message ?? this.message,
    );
  }

  final NameStatus status;
  final String fullname;
  final UserPubSearchResult? result;
  final String message;

  @override
  List<Object?> get props => [status, fullname, result, message];
}
