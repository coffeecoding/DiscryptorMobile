// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'selected_chat_cubit.dart';

enum SelectedChatStatus { initial, busyLoading, busySending, error, success }

class SelectedChatState extends Equatable {
  const SelectedChatState(
      {this.status = SelectedChatStatus.initial,
      this.chat,
      this.error = '',
      this.rebuildToggle = false});

  SelectedChatState copyWith(
      {SelectedChatStatus? status,
      ChatViewModel? chat,
      String? message,
      String? error}) {
    return SelectedChatState(
        status: status ?? this.status,
        chat: this.chat,
        error: error ?? this.error,
        rebuildToggle: !rebuildToggle);
  }

  // Need another object for chat message list
  final SelectedChatStatus status;
  final ChatViewModel? chat;
  final String error;
  final bool rebuildToggle;

  List<MessageViewModel> get messages => chat == null ? [] : chat!.messages;

  @override
  List<Object?> get props =>
      [status, chat?.userVM.user.id, chat, rebuildToggle, error];
}
