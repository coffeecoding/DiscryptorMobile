import 'package:bloc/bloc.dart';
import 'package:discryptor/config/sample_data.dart';
import 'package:discryptor/cubits/selected_chat/selected_chat_cubit.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:equatable/equatable.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit(this.selectedChatCubit) : super(const ChatListState());

  final SelectedChatCubit selectedChatCubit;

  void selectChat(ChatViewModel chat) {
    selectedChatCubit.selectChat(chat);
  }

  Future<void> loadChats() async {
    try {
      emit(state.copyWith(status: ChatListStatus.busy));
      List<ChatViewModel> chats =
          SampleData.sampleContacts.map((u) => ChatViewModel(u)).toList();
      await Future.delayed(const Duration(milliseconds: 600));
      emit(state.copyWith(status: ChatListStatus.success, chats: chats));
    } catch (e) {
      emit(state.copyWith(status: ChatListStatus.error, error: '$e'));
    }
  }
}
