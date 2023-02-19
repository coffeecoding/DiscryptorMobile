// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/common/json_serializable.dart';
import 'package:discryptor/models/discryptor_message.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';

class UserAndMessageData extends JsonSerializable {
  final List<DiscryptorUserWithRelationship> users;
  final List<DiscryptorMessage> messages;
  const UserAndMessageData({
    required this.users,
    required this.messages,
  });

  @override
  List<Object?> get props => [users, messages];

  @override
  CustomType get customType => CustomType.userAndMessageData;

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
        (map['users'] as List).map<DiscryptorUserWithRelationship>(
          (x) =>
              DiscryptorUserWithRelationship.fromMap(x as Map<String, dynamic>),
        ),
      ),
      messages: List<DiscryptorMessage>.from(
        (map['messages'] as List).map<DiscryptorMessage>(
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
}
