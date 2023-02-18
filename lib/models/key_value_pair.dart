// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class KeyValuePair<T1, T2> extends Equatable {
  final T1 key;
  final T2 value;
  KeyValuePair({
    required this.key,
    required this.value,
  });

  KeyValuePair<T1, T2> copyWith({
    T1? key,
    T2? value,
  }) {
    return KeyValuePair<T1, T2>(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'value': value,
    };
  }

  factory KeyValuePair.fromMap(Map<String, dynamic> map) {
    return KeyValuePair<T1, T2>(
      key: map['key'] as T1,
      value: map['value'] as T2,
    );
  }

  String toJson() => json.encode(toMap());

  factory KeyValuePair.fromJson(String source) =>
      KeyValuePair.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'KeyValuePair(key: $key, value: $value)';

  @override
  List<Object?> get props => [key, value];
}
