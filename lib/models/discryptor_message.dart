// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DiscryptorMessage {
  final int id;
  final int authorId;
  final int channelId;
  final String authorName;
  final int recipientId;
  final bool isPinned;
  final String cleanContent;
  final String content;
  final int createdAt;
  final int timestampt;
  DiscryptorMessage({
    required this.id,
    required this.authorId,
    required this.channelId,
    required this.authorName,
    required this.recipientId,
    required this.isPinned,
    required this.cleanContent,
    required this.content,
    required this.createdAt,
    required this.timestampt,
  });

  DiscryptorMessage copyWith({
    int? id,
    int? authorId,
    int? channelId,
    String? authorName,
    int? recipientId,
    bool? isPinned,
    String? cleanContent,
    String? content,
    int? createdAt,
    int? timestampt,
  }) {
    return DiscryptorMessage(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      channelId: channelId ?? this.channelId,
      authorName: authorName ?? this.authorName,
      recipientId: recipientId ?? this.recipientId,
      isPinned: isPinned ?? this.isPinned,
      cleanContent: cleanContent ?? this.cleanContent,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      timestampt: timestampt ?? this.timestampt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'authorId': authorId,
      'channelId': channelId,
      'authorName': authorName,
      'recipientId': recipientId,
      'isPinned': isPinned,
      'cleanContent': cleanContent,
      'content': content,
      'createdAt': createdAt,
      'timestampt': timestampt,
    };
  }

  factory DiscryptorMessage.fromMap(Map<String, dynamic> map) {
    return DiscryptorMessage(
      id: map['id'] as int,
      authorId: map['authorId'] as int,
      channelId: map['channelId'] as int,
      authorName: map['authorName'] as String,
      recipientId: map['recipientId'] as int,
      isPinned: map['isPinned'] as bool,
      cleanContent: map['cleanContent'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] as int,
      timestampt: map['timestampt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscryptorMessage.fromJson(String source) =>
      DiscryptorMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DiscryptorMessage(id: $id, authorId: $authorId, channelId: $channelId, authorName: $authorName, recipientId: $recipientId, isPinned: $isPinned, cleanContent: $cleanContent, content: $content, createdAt: $createdAt, timestampt: $timestampt)';
  }

  @override
  bool operator ==(covariant DiscryptorMessage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.authorId == authorId &&
        other.channelId == channelId &&
        other.authorName == authorName &&
        other.recipientId == recipientId &&
        other.isPinned == isPinned &&
        other.cleanContent == cleanContent &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.timestampt == timestampt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        authorId.hashCode ^
        channelId.hashCode ^
        authorName.hashCode ^
        recipientId.hashCode ^
        isPinned.hashCode ^
        cleanContent.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        timestampt.hashCode;
  }
}
