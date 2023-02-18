import 'dart:convert';

import 'package:discryptor/models/key_value_pair.dart';

void main() {
  String json = '[{"key": 1234, "value": 491}, {"key":1, "value":993}]';
  print('Input: $json');
  List<KeyValuePair<int, int>> result = (jsonDecode(json) as List).map((i) {
    print(i);
    return KeyValuePair<int, int>.fromMap(i);
  }).toList();
  print(result[0]);
}
