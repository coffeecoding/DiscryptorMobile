// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/relationship.dart';
import 'package:equatable/equatable.dart';

import 'package:discryptor/cubitvms/message_vm.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/models/discryptor_message.dart';
import 'package:discryptor/utils/crypto/crypto.dart';

enum ChatStatus { initial, busyLoading, busySending, error, success }

class ChatViewModel extends Equatable {
  ChatViewModel(
    this.userVM, {
    this.status = ChatStatus.initial,
    this.messages = const <MessageViewModel>[],
    this.message = '',
    this.error = '',
  });

  ChatViewModel copyWith({
    ChatStatus? status,
    UserViewModel? userVM,
    int? userStatus,
    String? message,
    String? error,
  }) =>
      ChatViewModel(userVM ?? this.userVM,
          status: status ?? this.status,
          message: message ?? this.message,
          error: error ?? this.error,
          messages: messages)
        ..keyBase64 = keyBase64;

  ChatViewModel updateWithRelationship(Relationship r) =>
      ChatViewModel(userVM.copyWith(
          user: userVM.user.copyWith(
              isInitiatorOfRelationship: id == r.initiatorId,
              relationshipAcceptanceDate: r.dateAccepted,
              relationshipInitiationDate: r.dateInitiated,
              encryptedSymmKey: id == r.initiatorId
                  ? r.acceptorSymmetricKey
                  : r.initiatorSymmetricKey)));

  void decryptSymmetricKey(String privKey) {
    if (userVM.user.encryptedSymmKey == null ||
        userVM.user.encryptedSymmKey!.isEmpty) {
      // can happen
      keyBase64 = '';
      return;
    }
    keyBase64 = base64
        .encode(RSAHelper.rsaDecrypt(userVM.user.encryptedSymmKey!, privKey));
  }

  void addMessageInOrder(DiscryptorMessage msg, bool isSelfSender) {
    final msgVM = MessageViewModel(message: msg, isSelfSender: isSelfSender);
    //messages.add(msgVM);
    messages = [...messages, msgVM];
  }

  void addMessageOutOfOrder(DiscryptorMessage msg, bool isSelfSender) {
    // TODO: implement correctly
    // final msgVM = MessageViewModel(message: msg, isSelfSender: isSelfSender);
    // messages.add(msgVM);
  }

  late String? keyBase64;

  int get id => userVM.user.id;

  final ChatStatus status;
  final UserViewModel userVM;
  List<MessageViewModel> messages;
  final String message;
  final String error;

  @override
  List<Object> get props => [status, userVM, message, error, messages];
}
