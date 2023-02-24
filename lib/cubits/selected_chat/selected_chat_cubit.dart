import 'package:bloc/bloc.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:discryptor/cubitvms/message_vm.dart';
import 'package:discryptor/models/chat_message.dart';
import 'package:discryptor/repos/api_repo.dart';
import 'package:discryptor/repos/preference_repo.dart';
import 'package:discryptor/services/crypto_service.dart';
import 'package:equatable/equatable.dart';

part 'selected_chat_state.dart';

class SelectedChatCubit extends Cubit<SelectedChatState> {
  SelectedChatCubit()
      : apiRepo = locator.get<ApiRepo>(),
        prefRepo = locator.get<PreferenceRepo>(),
        crypto = locator.get<CryptoService>(),
        super(const SelectedChatState());

  final ApiRepo apiRepo;
  final PreferenceRepo prefRepo;
  final CryptoService crypto;

  void selectChat(ChatViewModel chat) {
    emit(SelectedChatState(chat: chat));
  }

  void refresh() {
    emit(state.copyWith(status: SelectedChatStatus.busyLoading));
    emit(state.copyWith(status: SelectedChatStatus.success));
  }

  void messageFieldChanged(String newValue) {
    emit(state.copyWith(message: newValue, error: ''));
  }

  Future<bool> sendMessage(String message) async {
    try {
      emit(state.copyWith(status: SelectedChatStatus.busySending));
      // final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      ChatMessage msg = crypto.encryptMessage(message, state.chat!.keyBase64!);
      final senderId = await prefRepo.userId;
      final recipientId = state.chat!.userVM.user.id;
      final serialized = 'M.$senderId.$recipientId.${msg.iv}.${msg.message}';
      final re = await apiRepo.sendMessage(recipientId, serialized);
      if (!re.isSuccess) {
        emit(state.copyWith(
            status: SelectedChatStatus.error,
            message: 'Failed to send message.'));
        return false;
      }
      final rcvdMsg = re.content!.copyWith(
          content: message,
          authorId: senderId,
          authorName: await prefRepo.username,
          recipientId: state.chat!.userVM.user.id);
      state.chat!.addMessageInOrder(rcvdMsg, true);
      emit(state.copyWith(
          status: SelectedChatStatus.success, message: '', error: ''));
      return true;
    } catch (e) {
      emit(state.copyWith(status: SelectedChatStatus.error, error: '$e'));
      return false;
    }
  }
}
