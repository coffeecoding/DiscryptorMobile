// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Relationship extends Equatable {
  final int id;
  final int initiatorId;
  final int acceptorId;
  final int dateInitiated;
  final int dateAccepted;
  final String? initiatorSymmetricKey;
  final String? acceptorSymmetricKey;

  const Relationship({
    required this.id,
    required this.initiatorId,
    required this.acceptorId,
    required this.dateInitiated,
    required this.dateAccepted,
    required this.initiatorSymmetricKey,
    required this.acceptorSymmetricKey,
  });

  Relationship copyWith({
    int? id,
    int? initiatorId,
    int? acceptorId,
    int? dateInitiated,
    int? dateAccepted,
    String? initiatorSymmetricKey,
    String? acceptorSymmetricKey,
  }) {
    return Relationship(
      id: id ?? this.id,
      initiatorId: initiatorId ?? this.initiatorId,
      acceptorId: acceptorId ?? this.acceptorId,
      dateInitiated: dateInitiated ?? this.dateInitiated,
      dateAccepted: dateAccepted ?? this.dateAccepted,
      initiatorSymmetricKey:
          initiatorSymmetricKey ?? this.initiatorSymmetricKey,
      acceptorSymmetricKey: acceptorSymmetricKey ?? this.acceptorSymmetricKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'initiatorId': initiatorId,
      'acceptorId': acceptorId,
      'dateInitiated': dateInitiated,
      'dateAccepted': dateAccepted,
      'initiatorSymmetricKey': initiatorSymmetricKey,
      'acceptorSymmetricKey': acceptorSymmetricKey,
    };
  }

  factory Relationship.fromMap(Map<String, dynamic> map) {
    return Relationship(
      id: map['id'] as int,
      initiatorId: map['initiatorId'] as int,
      acceptorId: map['acceptorId'] as int,
      dateInitiated: map['dateInitiated'] as int,
      dateAccepted: map['dateAccepted'] as int,
      initiatorSymmetricKey: map['initiatorSymmetricKey'] as String?,
      acceptorSymmetricKey: map['acceptorSymmetricKey'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Relationship.fromJson(String source) =>
      Relationship.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Relationship(id: $id, initiatorId: $initiatorId, acceptorId: $acceptorId, dateInitiated: $dateInitiated, dateAccepted: $dateAccepted, initiatorSymmetricKey: $initiatorSymmetricKey, acceptorSymmetricKey: $acceptorSymmetricKey)';
  }

  @override
  List<Object?> get props => [
        id,
        initiatorId,
        acceptorId,
        dateInitiated,
        dateAccepted,
        initiatorSymmetricKey,
        acceptorSymmetricKey
      ];
}
