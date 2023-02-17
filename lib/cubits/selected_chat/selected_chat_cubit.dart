import 'package:bloc/bloc.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:equatable/equatable.dart';

part 'selected_chat_state.dart';

class SelectedChatCubit extends Cubit<SelectedChatState> {
  SelectedChatCubit() : super(const SelectedChatState());

  void selectChat(ChatViewModel chat) {
    emit(SelectedChatState(chat: chat));
  }

  Future<void> sendMessage(String message) async {
    try {
      emit(state.copyWith(
          status: SelectedChatStatus.busySending, message: message));
      // Todo: implement
      await Future.delayed(const Duration(milliseconds: 400));
      emit(state.copyWith(status: SelectedChatStatus.success, message: ''));
    } catch (e) {
      emit(state.copyWith(status: SelectedChatStatus.error, error: '$e'));
    }
  }
}
