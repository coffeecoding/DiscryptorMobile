// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/models/idiscryptor_user.dart';
import 'package:equatable/equatable.dart';

enum RelationshipStatus {
  self, // if the user in question is us
  none,
  initiatedBySelf,
  initiatedByOther,
  accepted
}

RelationshipStatus getRelationshipStatus(IDiscryptorUser u) {
  if (u is DiscryptorUser) return RelationshipStatus.self;
  final duwr = u as DiscryptorUserWithRelationship;
  return duwr.relationshipInitiationDate != null &&
          duwr.relationshipInitiationDate! > 0 &&
          duwr.relationshipAcceptanceDate != null &&
          duwr.relationshipAcceptanceDate! > 0
      ? RelationshipStatus.accepted
      : duwr.isInitiatorOfRelationship &&
              (duwr.relationshipAcceptanceDate == null ||
                  duwr.relationshipAcceptanceDate == 0)
          ? RelationshipStatus.initiatedByOther
          : duwr.relationshipInitiationDate != null &&
                  duwr.relationshipInitiationDate! > 0
              ? RelationshipStatus.initiatedBySelf
              : RelationshipStatus.none;
}

class DiscryptorUserWithRelationship extends Equatable with IDiscryptorUser {
  final int id;
  final int createdAt;
  final int guildId;
  final int status;
  @override
  final String username;
  final int? accentColor;
  final String discriminator;
  final String? avatarUrl;
  final String defaultAvatarUrl;
  final String? bannerUrl;
  final String publicKey;
  final bool isBot;
  final bool isWebhook;
  final bool isInitiatorOfRelationship;
  final int? relationshipAcceptanceDate;
  final int? relationshipInitiationDate;
  final String? encryptedSymmKey;
  const DiscryptorUserWithRelationship({
    required this.id,
    required this.createdAt,
    required this.guildId,
    required this.status,
    required this.username,
    this.accentColor,
    required this.discriminator,
    this.avatarUrl,
    required this.defaultAvatarUrl,
    this.bannerUrl,
    required this.publicKey,
    required this.isBot,
    required this.isWebhook,
    required this.isInitiatorOfRelationship,
    this.relationshipAcceptanceDate,
    this.relationshipInitiationDate,
    this.encryptedSymmKey,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        guildId,
        status,
        username,
        accentColor,
        discriminator,
        avatarUrl,
        defaultAvatarUrl,
        avatarUrl,
        defaultAvatarUrl,
        bannerUrl,
        publicKey,
        isBot,
        isWebhook,
        isInitiatorOfRelationship,
        relationshipAcceptanceDate,
        relationshipAcceptanceDate,
        encryptedSymmKey
      ];

  @override
  String get getUsedAvatarUrl =>
      avatarUrl == null || avatarUrl == '' ? defaultAvatarUrl : avatarUrl!;
  String get fullname => '$username#$discriminator';
  @override
  int get getId => id;
  @override
  String get getDiscriminator => discriminator;
  @override
  int get getCreatedAt => createdAt;

  DiscryptorUserWithRelationship copyWith({
    int? id,
    int? createdAt,
    int? guildId,
    int? status,
    String? username,
    int? accentColor,
    String? discriminator,
    String? avatarUrl,
    String? defaultAvatarUrl,
    String? bannerUrl,
    String? publicKey,
    bool? isBot,
    bool? isWebhook,
    bool? isInitiatorOfRelationship,
    int? relationshipAcceptanceDate,
    int? relationshipInitiationDate,
    String? encryptedSymmKey,
  }) {
    return DiscryptorUserWithRelationship(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      guildId: guildId ?? this.guildId,
      status: status ?? this.status,
      username: username ?? this.username,
      accentColor: accentColor ?? this.accentColor,
      discriminator: discriminator ?? this.discriminator,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      defaultAvatarUrl: defaultAvatarUrl ?? this.defaultAvatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      publicKey: publicKey ?? this.publicKey,
      isBot: isBot ?? this.isBot,
      isWebhook: isWebhook ?? this.isWebhook,
      isInitiatorOfRelationship:
          isInitiatorOfRelationship ?? this.isInitiatorOfRelationship,
      relationshipAcceptanceDate:
          relationshipAcceptanceDate ?? this.relationshipAcceptanceDate,
      relationshipInitiationDate:
          relationshipInitiationDate ?? this.relationshipInitiationDate,
      encryptedSymmKey: encryptedSymmKey ?? this.encryptedSymmKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'guildId': guildId,
      'status': status,
      'username': username,
      'accentColor': accentColor,
      'discriminator': discriminator,
      'avatarUrl': avatarUrl,
      'defaultAvatarUrl': defaultAvatarUrl,
      'bannerUrl': bannerUrl,
      'publicKey': publicKey,
      'isBot': isBot,
      'isWebhook': isWebhook,
      'isInitiatorOfRelationship': isInitiatorOfRelationship,
      'relationshipAcceptanceDate': relationshipAcceptanceDate,
      'relationshipInitiationDate': relationshipInitiationDate,
      'encryptedSymmKey': encryptedSymmKey,
    };
  }

  factory DiscryptorUserWithRelationship.fromMap(Map<String, dynamic> map) {
    return DiscryptorUserWithRelationship(
      id: map['id'] as int,
      createdAt: map['createdAt'] as int,
      guildId: map['guildId'] as int,
      status: map['status'] as int,
      username: map['username'] as String,
      accentColor:
          map['accentColor'] != null ? map['accentColor'] as int : null,
      discriminator: map['discriminator'] as String,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      defaultAvatarUrl: map['defaultAvatarUrl'] as String,
      bannerUrl: map['bannerUrl'] != null ? map['bannerUrl'] as String : null,
      publicKey: map['publicKey'] as String,
      isBot: map['isBot'] as bool,
      isWebhook: map['isWebhook'] as bool,
      isInitiatorOfRelationship: map['isInitiatorOfRelationship'] as bool,
      relationshipAcceptanceDate: map['relationshipAcceptanceDate'] != null
          ? map['relationshipAcceptanceDate'] as int
          : null,
      relationshipInitiationDate: map['relationshipInitiationDate'] != null
          ? map['relationshipInitiationDate'] as int
          : null,
      encryptedSymmKey: map['encryptedSymmKey'] != null
          ? map['encryptedSymmKey'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscryptorUserWithRelationship.fromJson(String source) =>
      DiscryptorUserWithRelationship.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DiscryptorUserWithRelationship(id: $id, createdAt: $createdAt, guildId: $guildId, status: $status, username: $username, accentColor: $accentColor, discriminator: $discriminator, avatarUrl: $avatarUrl, defaultAvatarUrl: $defaultAvatarUrl, bannerUrl: $bannerUrl, publicKey: $publicKey, isBot: $isBot, isWebhook: $isWebhook, isInitiatorOfRelationship: $isInitiatorOfRelationship, relationshipAcceptanceDate: $relationshipAcceptanceDate, relationshipInitiationDate: $relationshipInitiationDate, encryptedSymmKey: $encryptedSymmKey)';
  }

  @override
  bool operator ==(covariant DiscryptorUserWithRelationship other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.guildId == guildId &&
        other.status == status &&
        other.username == username &&
        other.accentColor == accentColor &&
        other.discriminator == discriminator &&
        other.avatarUrl == avatarUrl &&
        other.defaultAvatarUrl == defaultAvatarUrl &&
        other.bannerUrl == bannerUrl &&
        other.publicKey == publicKey &&
        other.isBot == isBot &&
        other.isWebhook == isWebhook &&
        other.isInitiatorOfRelationship == isInitiatorOfRelationship &&
        other.relationshipAcceptanceDate == relationshipAcceptanceDate &&
        other.relationshipInitiationDate == relationshipInitiationDate &&
        other.encryptedSymmKey == encryptedSymmKey;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        guildId.hashCode ^
        status.hashCode ^
        username.hashCode ^
        accentColor.hashCode ^
        discriminator.hashCode ^
        avatarUrl.hashCode ^
        defaultAvatarUrl.hashCode ^
        bannerUrl.hashCode ^
        publicKey.hashCode ^
        isBot.hashCode ^
        isWebhook.hashCode ^
        isInitiatorOfRelationship.hashCode ^
        relationshipAcceptanceDate.hashCode ^
        relationshipInitiationDate.hashCode ^
        encryptedSymmKey.hashCode;
  }
}
