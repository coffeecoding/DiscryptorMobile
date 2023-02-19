// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AuthPayload extends Equatable {
  final int userId;
  final String challengeToken;
  final bool overrideCreds;
  const AuthPayload({
    required this.userId,
    required this.challengeToken,
    this.overrideCreds = false,
  });

  AuthPayload copyWith({
    int? userId,
    String? challengeToken,
    bool? overrideCreds,
  }) {
    return AuthPayload(
      userId: userId ?? this.userId,
      challengeToken: challengeToken ?? this.challengeToken,
      overrideCreds: overrideCreds ?? this.overrideCreds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'challengeToken': challengeToken,
      'overrideCreds': overrideCreds,
    };
  }

  factory AuthPayload.fromMap(Map<String, dynamic> map) {
    return AuthPayload(
      userId: map['userId'] as int,
      challengeToken: map['challengeToken'] as String,
      overrideCreds: map['overrideCreds'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthPayload.fromJson(String source) =>
      AuthPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthPayload(userId: $userId, challengeToken: $challengeToken, overrideCreds: $overrideCreds)';

  @override
  List<Object?> get props => [userId, challengeToken, overrideCreds];
}
