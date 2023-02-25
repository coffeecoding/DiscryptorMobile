import 'package:bloc/bloc.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/cubits/selected_chat/selected_chat_cubit.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/models/discryptor_message.dart';
import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/services/crypto_service.dart';
import 'package:discryptor/services/network_service.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit(this.selectedChatCubit)
      : apiRepo = locator.get<ApiRepo>(),
        prefRepo = locator.get<PreferenceRepo>(),
        crypto = locator.get<CryptoService>(),
        net = locator.get<NetworkService>(),
        super(const ChatListState()) {
    net.socket.on(
        'ReceiveMessage',
        (o) => handleReceivedMessage(
                DiscryptorMessage.fromMap(o![0] as Map<String, dynamic>))
            .then((_) => selectedChatCubit.refresh()));
    net.socket.on('UpdateRelationship',
        (o) => print("Placeholder for updating relationsip"));
    net.socket
        .on('DeleteMessage', (o) => print('Placeholder for deleteing message'));
  }

  final SelectedChatCubit selectedChatCubit;
  final ApiRepo apiRepo;
  final PreferenceRepo prefRepo;
  final CryptoService crypto;
  final NetworkService net;

  DiscryptorUser get self => prefRepo.cachedUser!;

  void selectChat(ChatViewModel chat) {
    selectedChatCubit.selectChat(chat);
  }

  Future<DiscryptorMessage?> handleReceivedMessage(DiscryptorMessage msg,
      {bool inOrder = true}) async {
    try {
      if (!msg.content.startsWith('M.')) return null;
      final parts = msg.content.split('.');
      if (parts.length > 5) return null;
      final senderId = int.parse(parts[1]);
      final recipientId = int.parse(parts[2]);

      final isSelfSender = self.id == senderId;

      ChatViewModel? chatVM = state.chats.firstWhereOrNull(
          (c) => c.userVM.user.id == (isSelfSender ? recipientId : senderId));

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
              isSelfSender ? self.username : chatVM.userVM.user.username);

      if (inOrder) {
        chatVM.addMessageInOrder(receivedMsg, isSelfSender);
      } else {
        chatVM.addMessageOutOfOrder(receivedMsg, isSelfSender);
      }

      return receivedMsg;
    } catch (e) {
      print('Error receiving message $msg: $e');
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
      chatVMs.forEach((c) => c.decryptSymmetricKey(privKey!));
      emit(state.copyWith(chats: chatVMs));
      re.content!.messages.forEach(handleReceivedMessage);
      emit(state.copyWith(status: ChatListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChatListStatus.error, error: '$e'));
    }
  }
}
