// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/cubits/selected_chat/selected_chat_cubit.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/models/discryptor_message.dart';
import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:discryptor/models/relationship.dart';
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
        bl = locator.get<DiscryptorBL>(),
        net = locator.get<NetworkService>(),
        super(const ChatListState()) {
    net.socket.on(
        'ReceiveMessage',
        (o) => handleReceivedMessage(
                DiscryptorMessage.fromMap(o![0] as Map<String, dynamic>))
            .then((_) => selectedChatCubit.refresh()));
    net.socket.on(
        'UpdateRelationship',
        (o) => handleRelationshipUpdate(o![0] as String,
            Relationship.fromMap(o[1] as Map<String, dynamic>)));
    net.socket
        .on('DeleteMessage', (o) => print('Placeholder for deleteing message'));
  }

  final SelectedChatCubit selectedChatCubit;
  final ApiRepo apiRepo;
  final PreferenceRepo prefRepo;
  final DiscryptorBL bl;
  final CryptoService crypto;
  final NetworkService net;

  DiscryptorUser get self => prefRepo.cachedUser!;

  void selectChat(ChatViewModel chat) {
    selectedChatCubit.selectChat(chat);
  }

  void updateChatVM(ChatViewModel updated) {
    emit(state.copyWith(
        chats: state.chats
            .map(
                (c) => c.userVM.user.id == updated.userVM.user.id ? updated : c)
            .toList()));
  }

  void addChat(ChatViewModel chatVM) {
    if (state.chats.any((c) => c.userVM.user.id == chatVM.userVM.user.id)) {
      return;
    }
    emit(state.copyWith(status: ChatListStatus.busySilent));
    emit(state.copyWith(
        status: ChatListStatus.success, chats: [...state.chats, chatVM]));
  }

  Future<void> updateRelationshipDirect(
      UserViewModel userVM, RelationshipStatus update) async {
    ChatViewModel? chatVM =
        state.chats.firstWhereOrNull((c) => c.userVM.id == userVM.id);
    if (chatVM == null) {
      chatVM = ChatViewModel(userVM);
      final privkey = await prefRepo.privkey;
      chatVM.decryptSymmetricKey(privkey!);
    }
    await updateRelationship(chatVM, update);
  }

  Future<void> updateRelationship(
      ChatViewModel chatVM, RelationshipStatus update) async {
    try {
      emit(state.copyWith(status: ChatListStatus.busy));
      final user = chatVM.userVM.user;
      if (update == RelationshipStatus.initiatedBySelf) {
        final re = await bl.initiateRelationship(user);
        if (!re.isSuccess) {
          emit(state.copyWith(status: ChatListStatus.error, error: re.userMsg));
          print(re.debugMsg);
          return;
        }
        final updatedChatVM =
            chatVM.copyWith(userVM: chatVM.userVM.copyWith(user: re.result));
        updateChatVM(updatedChatVM);
      } else if (update == RelationshipStatus.accepted) {
        final re = await bl.acceptRelationship(user);
        if (!re.isSuccess) {
          emit(state.copyWith(status: ChatListStatus.error, error: re.userMsg));
          print(re.debugMsg);
          return;
        }
        final updatedChatVM =
            chatVM.copyWith(userVM: chatVM.userVM.copyWith(user: re.result));
        updateChatVM(updatedChatVM);
      } else if (update == RelationshipStatus.none) {
        // cancel friendship
        final re = await bl.cancelRelationship(user);
        if (!re.isSuccess) {
          emit(state.copyWith(status: ChatListStatus.error, error: re.userMsg));
          print(re.debugMsg);
          return;
        }
        final updatedChatVM =
            chatVM.copyWith(userVM: chatVM.userVM.copyWith(user: re.result));
        updateChatVM(updatedChatVM);
      }
      emit(state.copyWith(status: ChatListStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ChatListStatus.error,
          error: 'Error updating relationship: $e'));
    }
  }

  Future<void> handleRelationshipUpdate(
      String type, Relationship updatedRel) async {
    try {
      print('Received relationship update: $updatedRel');
      emit(state.copyWith(status: ChatListStatus.busySilent));
      final userId = self.id == updatedRel.initiatorId
          ? updatedRel.acceptorId
          : updatedRel.initiatorId;
      var chatVM = state.chats.firstWhereOrNull((ch) =>
          ch.userVM.user.id == updatedRel.initiatorId ||
          ch.userVM.user.id == updatedRel.acceptorId);
      if (chatVM == null) {
        final response = await apiRepo.getUser(userId);
        if (response.isSuccess) {
          final userVM = UserViewModel(user: response.content!);
          chatVM = ChatViewModel(userVM);
          emit(state.copyWith(
              status: ChatListStatus.success, chats: [...state.chats, chatVM]));
        }
      } else {
        final cvm = chatVM.updateWithRelationship(updatedRel);
        // final updatedChats = type.startsWith('cancel')
        //     ? state.chats
        //         .where((c) => true /*c.userVM.user.id != userId*/)
        //         .toList()
        //     : state.chats
        //         .map((c) => c.userVM.user.id == userId ? cvm : c)
        //         .toList();
        final updatedChats = state.chats
            .map((c) => c.userVM.user.id == userId ? cvm : c)
            .toList();
        final privkey = await prefRepo.privkey;
        cvm.decryptSymmetricKey(privkey!);
        emit(state.copyWith(
            status: ChatListStatus.success, chats: updatedChats));
      }
    } catch (e) {
      print("Error handling relationship update: $e");
      emit(state.copyWith(
          status: ChatListStatus.error,
          error:
              'Updating relationship with (I=${updatedRel.initiatorId},A=${updatedRel.acceptorId} failed: $e'));
    }
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
