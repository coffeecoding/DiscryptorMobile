// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Credentials extends Equatable {
  final int userId;
  final String publicKey;
  final String privateKeyEncrypted;
  final int created;
  const Credentials({
    required this.userId,
    required this.publicKey,
    required this.privateKeyEncrypted,
    required this.created,
  });

  @override
  List<Object?> get props => [userId, publicKey, privateKeyEncrypted, created];

  Credentials copyWith({
    int? userId,
    String? publicKey,
    String? privateKeyEncrypted,
    int? created,
  }) {
    return Credentials(
      userId: userId ?? this.userId,
      publicKey: publicKey ?? this.publicKey,
      privateKeyEncrypted: privateKeyEncrypted ?? this.privateKeyEncrypted,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'publicKey': publicKey,
      'privateKeyEncrypted': privateKeyEncrypted,
      'created': created,
    };
  }

  factory Credentials.fromMap(Map<String, dynamic> map) {
    return Credentials(
      userId: map['userId'] as int,
      publicKey: map['publicKey'] as String,
      privateKeyEncrypted: map['privateKeyEncrypted'] as String,
      created: map['created'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Credentials.fromJson(String source) =>
      Credentials.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Credentials(userId: $userId, publicKey: $publicKey, privateKeyEncrypted: $privateKeyEncrypted, created: $created)';
  }

  @override
  bool operator ==(covariant Credentials other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.publicKey == publicKey &&
        other.privateKeyEncrypted == privateKeyEncrypted &&
        other.created == created;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        publicKey.hashCode ^
        privateKeyEncrypted.hashCode ^
        created.hashCode;
  }
}
