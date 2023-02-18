// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/common/json_serializable.dart';

class ChatMessage extends JsonSerializable {
  String iv;
  String message;
  ChatMessage({
    required this.iv,
    required this.message,
  });

  @override
  List<Object?> get props => [iv, message];

  @override
  CustomType get customType => CustomType.chatMessage;

  ChatMessage clone() => ChatMessage(iv: iv, message: message);

  ChatMessage copyWith({
    String? iv,
    String? message,
  }) {
    return ChatMessage(
      iv: iv ?? this.iv,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iv': iv,
      'message': message,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      iv: map['iv'] as String,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatMessage(iv: $iv, message: $message)';

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.iv == iv && other.message == message;
  }

  @override
  int get hashCode => iv.hashCode ^ message.hashCode;
}
