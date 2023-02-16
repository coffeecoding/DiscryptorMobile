// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AlgorithmIdentifier extends Equatable {
  static const int defIterations = 10000;
  static const int defSaltLen = 20;
  static const int defHashLen = 32;
  static const int defRSAKeyLen = 2048;
  static const int defDKLen = 32;
  static const int defAesIVLen = 16;

  final String name;
  final int iterations;
  final int saltLen;
  final int hashLen;
  final int rsaKeyLen;
  final int dkLen;
  final int aesivLen;
  const AlgorithmIdentifier({
    required this.name,
    required this.iterations,
    required this.saltLen,
    required this.hashLen,
    required this.rsaKeyLen,
    required this.dkLen,
    required this.aesivLen,
  });

  AlgorithmIdentifier copyWith({
    String? name,
    int? iterations,
    int? saltLen,
    int? hashLen,
    int? rsaKeyLen,
    int? dkLen,
    int? aesivLen,
  }) {
    return AlgorithmIdentifier(
      name: name ?? this.name,
      iterations: iterations ?? this.iterations,
      saltLen: saltLen ?? this.saltLen,
      hashLen: hashLen ?? this.hashLen,
      rsaKeyLen: rsaKeyLen ?? this.rsaKeyLen,
      dkLen: dkLen ?? this.dkLen,
      aesivLen: aesivLen ?? this.aesivLen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': name,
      'Iterations': iterations,
      'SaltLen': saltLen,
      'HashLen': hashLen,
      'RSAKeyLen': rsaKeyLen,
      'DKLen': dkLen,
      'AESIVLen': aesivLen,
    };
  }

  factory AlgorithmIdentifier.fromMap(String mapString) {
    // take care of the nested json
    mapString = mapString.replaceAll('!', '"');
    final map = json.decode(mapString) as Map<String, dynamic>;
    return AlgorithmIdentifier(
      name: map['Name'] as String,
      iterations: map['Iterations'] as int,
      saltLen: map['SaltLen'] as int,
      hashLen: map['HashLen'] as int,
      rsaKeyLen: map['RSAKeyLen'] as int,
      dkLen: map['DKLen'] as int,
      aesivLen: map['AESIVLen'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlgorithmIdentifier.fromJson(String source) =>
      AlgorithmIdentifier.fromMap(source);

  String serialize() =>
      '$name,$iterations,$hashLen,$saltLen,$rsaKeyLen,$dkLen,$aesivLen';

  static AlgorithmIdentifier deserialize(String serialized) {
    final p = serialized.split(',');
    return AlgorithmIdentifier(
        name: p[0],
        iterations: int.parse(p[1]),
        saltLen: int.parse(p[3]),
        hashLen: int.parse(p[2]),
        rsaKeyLen: int.parse(p[4]),
        dkLen: int.parse(p[5]),
        aesivLen: int.parse(p[6]));
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      iterations,
      saltLen,
      hashLen,
      rsaKeyLen,
      dkLen,
      aesivLen,
    ];
  }

  static const standard = AlgorithmIdentifier(
      name: 'PBES2',
      iterations: defIterations,
      saltLen: defSaltLen,
      hashLen: defHashLen,
      rsaKeyLen: defRSAKeyLen,
      dkLen: defDKLen,
      aesivLen: defAesIVLen);
}
