// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/credentials.dart';

class AuthPayload {
  final String challengeToken;
  final bool overrideCreds;
  final Credentials creds;
  AuthPayload({
    required this.challengeToken,
    required this.overrideCreds,
    required this.creds,
  });

  AuthPayload copyWith({
    String? challengeToken,
    bool? overrideCreds,
    Credentials? creds,
  }) {
    return AuthPayload(
      challengeToken: challengeToken ?? this.challengeToken,
      overrideCreds: overrideCreds ?? this.overrideCreds,
      creds: creds ?? this.creds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'challengeToken': challengeToken,
      'overrideCreds': overrideCreds,
      'creds': creds.toMap(),
    };
  }

  factory AuthPayload.fromMap(Map<String, dynamic> map) {
    return AuthPayload(
      challengeToken: map['challengeToken'] as String,
      overrideCreds: map['overrideCreds'] as bool,
      creds: Credentials.fromMap(map['creds'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthPayload.fromJson(String source) =>
      AuthPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthPayload(challengeToken: $challengeToken, overrideCreds: $overrideCreds, creds: $creds)';

  @override
  bool operator ==(covariant AuthPayload other) {
    if (identical(this, other)) return true;

    return other.challengeToken == challengeToken &&
        other.overrideCreds == overrideCreds &&
        other.creds == creds;
  }

  @override
  int get hashCode =>
      challengeToken.hashCode ^ overrideCreds.hashCode ^ creds.hashCode;
}
