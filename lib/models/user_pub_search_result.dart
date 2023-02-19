// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

enum UserPubSearchResultState { notFound, noCredentialsFound, found }

class UserPubSearchResult extends Equatable {
  final UserPubSearchResultState result;
  final String passwordSalt;
  final int userId;
  const UserPubSearchResult({
    required this.result,
    required this.passwordSalt,
    required this.userId,
  });

  UserPubSearchResult copyWith({
    UserPubSearchResultState? result,
    String? passwordSalt,
    int? userId,
  }) {
    return UserPubSearchResult(
      result: result ?? this.result,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'result': result,
      'passwordSalt': passwordSalt,
      'userId': userId,
    };
  }

  factory UserPubSearchResult.fromMap(Map<String, dynamic> map) {
    return UserPubSearchResult(
      result: UserPubSearchResultState.values[map['result']],
      passwordSalt: map['passwordSalt'] as String,
      userId: map['userId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPubSearchResult.fromJson(String source) =>
      UserPubSearchResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserPubSearchResult(result: $result, passwordSalt: $passwordSalt, userId: $userId)';

  @override
  List<Object> get props => [userId, passwordSalt, result];
}
