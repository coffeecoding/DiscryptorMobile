// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:discryptor/models/discryptor_message.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';

class UserAndMessageData {
  final List<DiscryptorUserWithRelationship> users;
  final List<DiscryptorMessage> messages;
  UserAndMessageData({
    required this.users,
    required this.messages,
  });

  UserAndMessageData copyWith({
    List<DiscryptorUserWithRelationship>? users,
    List<DiscryptorMessage>? messages,
  }) {
    return UserAndMessageData(
      users: users ?? this.users,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'users': users.map((x) => x.toMap()).toList(),
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory UserAndMessageData.fromMap(Map<String, dynamic> map) {
    return UserAndMessageData(
      users: List<DiscryptorUserWithRelationship>.from(
        (map['users'] as List<int>).map<DiscryptorUserWithRelationship>(
          (x) =>
              DiscryptorUserWithRelationship.fromMap(x as Map<String, dynamic>),
        ),
      ),
      messages: List<DiscryptorMessage>.from(
        (map['messages'] as List<int>).map<DiscryptorMessage>(
          (x) => DiscryptorMessage.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAndMessageData.fromJson(String source) =>
      UserAndMessageData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserAndMessageData(users: $users, messages: $messages)';

  @override
  bool operator ==(covariant UserAndMessageData other) {
    if (identical(this, other)) return true;

    return listEquals(other.users, users) &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode => users.hashCode ^ messages.hashCode;
}
