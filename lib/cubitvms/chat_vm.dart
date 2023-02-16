import 'package:discryptor/cubitvms/message_vm.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { initial, busyLoading, busySending, error, success }

class ChatViewModel extends Equatable {
  const ChatViewModel(
    this.user, {
    this.status = ChatStatus.initial,
    this.messages = const <MessageViewModel>[],
    this.message = '',
    this.error = '',
  });

  final ChatStatus status;
  final DiscryptorUserWithRelationship user;
  final List<MessageViewModel> messages;
  final String message;
  final String error;

  @override
  List<Object?> get props => [status, user, message, error, messages];
}
