// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:discryptor/models/credentials.dart';
import 'package:discryptor/models/discryptor_user.dart';

class AuthResult extends Equatable {
  final String token;
  final String refreshToken;
  final Credentials? credentials;
  final DiscryptorUser user;
  const AuthResult({
    required this.token,
    required this.refreshToken,
    required this.credentials,
    required this.user,
  });

  @override
  List<Object?> get props => [token, refreshToken, credentials, user];

  AuthResult copyWith({
    String? token,
    String? refreshToken,
    Credentials? credentials,
    DiscryptorUser? user,
  }) {
    return AuthResult(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      credentials: credentials ?? this.credentials,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'refreshToken': refreshToken,
      'credentials': credentials?.toMap(),
      'user': user.toMap(),
    };
  }

  factory AuthResult.fromMap(Map<String, dynamic> map) {
    return AuthResult(
      token: map['token'] as String,
      refreshToken: map['refreshToken'] as String,
      credentials: map['credentials'] != null
          ? Credentials.fromMap(map['credentials'] as Map<String, dynamic>)
          : null,
      user: DiscryptorUser.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResult.fromJson(String source) =>
      AuthResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
