part of 'chat_list_cubit.dart';

enum ChatListStatus { initial, busy, busySilent, error, success }

class ChatListState extends Equatable {
  const ChatListState({
    this.status = ChatListStatus.initial,
    this.chats = const <ChatViewModel>[],
    this.error = '',
  });

  ChatListState copyWith(
          {ChatListStatus? status,
          List<ChatViewModel>? chats,
          String? error}) =>
      ChatListState(
          status: status ?? this.status,
          chats: status == ChatListStatus.busy || chats == null
              ? this.chats
              : chats,
          error: error ?? this.error);

  final ChatListStatus status;
  final List<ChatViewModel> chats;
  final String error;

  @override
  List<Object> get props => [status, chats];
}
