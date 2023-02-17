// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/common/json_serializable.dart';

class Credentials extends JsonSerializable {
  final int userId;
  final String fullname;
  final String passwordHash;
  final String passwordSalt;
  final String publicKey;
  final String privateKeyEncrypted;
  final int created;
  Credentials({
    required this.userId,
    required this.fullname,
    required this.passwordHash,
    required this.passwordSalt,
    required this.publicKey,
    required this.privateKeyEncrypted,
    required this.created,
  });

  @override
  CustomType get customType => CustomType.credentials;

  Credentials copyWith({
    int? userId,
    String? fullname,
    String? passwordHash,
    String? passwordSalt,
    String? publicKey,
    String? privateKeyEncrypted,
    int? created,
  }) {
    return Credentials(
      userId: userId ?? this.userId,
      fullname: fullname ?? this.fullname,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      publicKey: publicKey ?? this.publicKey,
      privateKeyEncrypted: privateKeyEncrypted ?? this.privateKeyEncrypted,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'fullname': fullname,
      'passwordHash': passwordHash,
      'passwordSalt': passwordSalt,
      'publicKey': publicKey,
      'privateKeyEncrypted': privateKeyEncrypted,
      'created': created,
    };
  }

  factory Credentials.fromMap(Map<String, dynamic> map) {
    return Credentials(
      userId: map['userId'] as int,
      fullname: map['fullname'] as String,
      passwordHash: map['passwordHash'] as String,
      passwordSalt: map['passwordSalt'] as String,
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
    return 'Credentials(userId: $userId, fullname: $fullname, passwordHash: $passwordHash, passwordSalt: $passwordSalt, publicKey: $publicKey, privateKeyEncrypted: $privateKeyEncrypted, created: $created)';
  }

  @override
  bool operator ==(covariant Credentials other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.fullname == fullname &&
        other.passwordHash == passwordHash &&
        other.passwordSalt == passwordSalt &&
        other.publicKey == publicKey &&
        other.privateKeyEncrypted == privateKeyEncrypted &&
        other.created == created;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fullname.hashCode ^
        passwordHash.hashCode ^
        passwordSalt.hashCode ^
        publicKey.hashCode ^
        privateKeyEncrypted.hashCode ^
        created.hashCode;
  }
}
