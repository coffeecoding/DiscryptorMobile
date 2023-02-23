// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/discryptor_message.dart';
import 'package:discryptor/utils/crypto/crypto.dart';
import 'package:equatable/equatable.dart';

import 'package:discryptor/cubitvms/message_vm.dart';
import 'package:discryptor/cubitvms/user_vm.dart';

enum ChatStatus { initial, busyLoading, busySending, error, success }

class ChatViewModel {
  ChatViewModel(
    this.userState, {
    this.status = ChatStatus.initial,
    this.messages = const <MessageViewModel>[],
    this.message = '',
    this.error = '',
  });

  void decryptSymmetricKey(String privKey) {
    keyBase64 = base64.encode(
        RSAHelper.rsaDecrypt(userState.user.encryptedSymmKey!, privKey));
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

  final ChatStatus status;
  final UserViewModel userState;
  List<MessageViewModel> messages;
  final String message;
  final String error;

  List<Object?> get props => [status, userState, message, error, messages];
}
