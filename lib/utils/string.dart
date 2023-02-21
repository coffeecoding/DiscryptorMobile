import 'dart:convert';

String base64ToUTF8(String input) => utf8.decode(base64.decode(input).toList());
String utf8ToBase64(String input) => base64.encode(utf8.encode(input));
