// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/discryptor_message.dart';
import 'package:equatable/equatable.dart';

enum MessageStatus { success, error }

class MessageViewModel extends Equatable {
  final MessageStatus status;
  final String timestamp;
  final String authorAvatarUrl;
  final DiscryptorMessage message;
  final String error;
  MessageViewModel({
    required this.status,
    required this.timestamp,
    required this.authorAvatarUrl,
    required this.message,
    required this.error,
  });

  MessageViewModel copyWith({
    MessageStatus? status,
    String? timestamp,
    String? authorAvatarUrl,
    DiscryptorMessage? message,
    String? error,
  }) {
    return MessageViewModel(
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'MessageViewModel(status: $status, timestamp: $timestamp, authorAvatarUrl: $authorAvatarUrl, message: $message, error: $error)';
  }

  @override
  List<Object?> get props =>
      [status, timestamp, authorAvatarUrl, message, error];
}
