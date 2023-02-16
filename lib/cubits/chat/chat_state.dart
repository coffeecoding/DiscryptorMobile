part of 'chat_cubit.dart';

enum ChatStatus { initial, busyLoading, busySending, error, success }

class ChatState extends Equatable {
  const ChatState(
    this.user, {
    this.status = ChatStatus.initial,
    this.message = '',
    this.error = '',
  });

  final ChatStatus status;
  final DiscryptorUserWithRelationship user;
  final String message;
  final String error;

  @override
  List<Object?> get props => [status, user, message, error];
}
