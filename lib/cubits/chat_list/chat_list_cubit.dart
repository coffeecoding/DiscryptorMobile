import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/selected_chat/selected_chat_cubit.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/models/discryptor_message.dart';
import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/services/crypto_service.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit(
      this.selectedChatCubit, this.apiRepo, this.prefRepo, this.crypto)
      : super(const ChatListState());

  final SelectedChatCubit selectedChatCubit;
  final ApiRepo apiRepo;
  final PreferenceRepo prefRepo;
  final CryptoService crypto;

  void selectChat(ChatViewModel chat) {
    selectedChatCubit.selectChat(chat);
  }

  Future<DiscryptorMessage?> handleReceivedMessage(
      DiscryptorMessage msg, DiscryptorUser self, List<ChatViewModel> chatVMs,
      {bool inOrder = true}) async {
    try {
      if (!msg.content.startsWith('M.')) return null;
      final parts = msg.content.split('.');
      if (parts.length > 5) return null;
      final senderId = int.parse(parts[1]);
      final recipientId = int.parse(parts[2]);

      final isSelfSender = self.id == senderId;

      ChatViewModel? chatVM = chatVMs.firstWhereOrNull((c) =>
          c.userState.user.id == (isSelfSender ? recipientId : senderId));

      if (chatVM == null) return null; // Todo: log

      final ivBase64 = parts[3];
      final encryptedMsg = parts[4];

      final decryptedMsg =
          crypto.decryptMessage(encryptedMsg, ivBase64, chatVM.keyBase64!);

      DiscryptorMessage receivedMsg = msg.copyWith(
          authorId: senderId,
          recipientId: recipientId,
          content: decryptedMsg,
          authorName:
              isSelfSender ? self.username : chatVM.userState.user.username);

      if (inOrder) {
        chatVM.addMessageInOrder(receivedMsg, isSelfSender);
      } else {
        chatVM.addMessageOutOfOrder(receivedMsg, isSelfSender);
      }

      return receivedMsg;
    } catch (e) {
      print('Error receiving message $msg: $e');
      // Probably don't emit new state as this only concerns a single msg,
      // not the whole ChatListState
      // emit(state.copyWith(status: ChatListStatus.error, error: '$e'));
      return null;
    }
  }

  Future<void> loadChats() async {
    try {
      emit(state.copyWith(status: ChatListStatus.busy));
      final re = await apiRepo.getUsersAndMessages(null);
      if (!re.isSuccess) {
        emit(state.copyWith(status: ChatListStatus.error, error: re.message));
        return;
      }
      final userVMs = re.content!.users.map((u) => UserViewModel(user: u));
      final chatVMs = userVMs.map((uvm) => ChatViewModel(uvm)).toList();
      final privKey = await prefRepo.privkey;
      final self = await prefRepo.user;
      chatVMs.forEach((c) => c.decryptSymmetricKey(privKey!));
      re.content!.messages
          .forEach((m) => handleReceivedMessage(m, self!, chatVMs));
      emit(state.copyWith(status: ChatListStatus.success, chats: chatVMs));
    } catch (e) {
      emit(state.copyWith(status: ChatListStatus.error, error: '$e'));
    }
  }
}
