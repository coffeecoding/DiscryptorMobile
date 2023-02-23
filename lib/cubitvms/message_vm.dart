import 'package:discryptor/models/discryptor_message.dart';
import 'package:equatable/equatable.dart';

enum MessageStatus { success, error }

class MessageViewModel extends Equatable {
  const MessageViewModel({
    this.status = MessageStatus.success,
    required this.message,
    required this.isSelfSender,
    this.error = '',
  });

  MessageViewModel copyWith({
    MessageStatus? status,
    String? error,
  }) {
    return MessageViewModel(
      status: status ?? this.status,
      message: message,
      isSelfSender: isSelfSender,
      error: error ?? this.error,
    );
  }

  final MessageStatus status;
  final bool isSelfSender;
  final DiscryptorMessage message;
  final String error;

  @override
  List<Object?> get props => [status, isSelfSender, message, error];
}
