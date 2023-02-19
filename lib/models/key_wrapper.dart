// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class KeyWrapper extends Equatable {
  final String symmKey;
  const KeyWrapper({
    required this.symmKey,
  });

  KeyWrapper copyWith({
    String? symmKey,
  }) {
    return KeyWrapper(
      symmKey: symmKey ?? this.symmKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'symmKey': symmKey,
    };
  }

  factory KeyWrapper.fromMap(Map<String, dynamic> map) {
    return KeyWrapper(
      symmKey: map['symmKey'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory KeyWrapper.fromJson(String source) =>
      KeyWrapper.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'KeyWrapper(symmKey: $symmKey)';

  @override
  List<Object> get props => [symmKey];
}
