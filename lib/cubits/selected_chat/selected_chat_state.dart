// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'selected_chat_cubit.dart';

enum SelectedChatStatus { initial, busyLoading, busySending, error, success }

class SelectedChatState extends Equatable {
  const SelectedChatState(
      {this.status = SelectedChatStatus.initial,
      this.chat,
      this.message = '',
      this.error = ''});

  SelectedChatState copyWith(
      {SelectedChatStatus? status,
      ChatViewModel? chat,
      String? message,
      String? error}) {
    return SelectedChatState(
        status: status ?? this.status,
        chat: chat ?? chat,
        message: message ?? this.message,
        error: error ?? this.error);
  }

  final SelectedChatStatus status;
  final ChatViewModel? chat;
  final String message;
  final String error;

  @override
  List<Object?> get props => [status, chat?.user.id, chat, message, error];
}
