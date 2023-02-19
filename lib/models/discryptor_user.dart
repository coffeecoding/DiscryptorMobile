// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class DiscryptorUser extends Equatable {
  final int id;
  final int createdAt;
  final int guildId;
  final int status;
  final String username;
  final int? accentColor;
  final String discriminator;
  final String avatarUrl;
  final String defaultAvatarUrl;
  final String bannerUrl;
  final String publicKey;
  final bool isBot;
  final bool isWebhook;

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
        bannerUrl,
        publicKey,
        isBot,
        isWebhook
      ];

  String get usedAvatarUrl => avatarUrl.isEmpty ? defaultAvatarUrl : avatarUrl;
  String get fullname => '$username#$discriminator';

  const DiscryptorUser({
    required this.id,
    required this.createdAt,
    required this.guildId,
    required this.status,
    required this.username,
    this.accentColor,
    required this.discriminator,
    required this.avatarUrl,
    required this.defaultAvatarUrl,
    required this.bannerUrl,
    required this.publicKey,
    required this.isBot,
    required this.isWebhook,
  });

  DiscryptorUser copyWith({
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
  }) {
    return DiscryptorUser(
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
    };
  }

  factory DiscryptorUser.fromMap(Map<String, dynamic> map) {
    return DiscryptorUser(
      id: map['id'] as int,
      createdAt: map['createdAt'] as int,
      guildId: map['guildId'] as int,
      status: map['status'] as int,
      username: map['username'] as String,
      accentColor:
          map['accentColor'] != null ? map['accentColor'] as int : null,
      discriminator: map['discriminator'] as String,
      avatarUrl: map['avatarUrl'] as String,
      defaultAvatarUrl: map['defaultAvatarUrl'] as String,
      bannerUrl: map['bannerUrl'] as String,
      publicKey: map['publicKey'] as String,
      isBot: map['isBot'] as bool,
      isWebhook: map['isWebhook'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscryptorUser.fromJson(String source) =>
      DiscryptorUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DiscryptorUser(id: $id, createdAt: $createdAt, guildId: $guildId, status: $status, username: $username, accentColor: $accentColor, discriminator: $discriminator, avatarUrl: $avatarUrl, defaultAvatarUrl: $defaultAvatarUrl, bannerUrl: $bannerUrl, publicKey: $publicKey, isBot: $isBot, isWebhook: $isWebhook)';
  }

  @override
  bool operator ==(covariant DiscryptorUser other) {
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
        other.isWebhook == isWebhook;
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
        isWebhook.hashCode;
  }
}
