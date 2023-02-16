import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class StatefulAES {
  static const AESMode defMode = AESMode.cbc;
  static const String defPadding = 'PKCS7';

  late IV _iv;
  late AES _aes;

  StatefulAES() {
    Key aesKey = Key.fromSecureRandom(32);
    IV aesIV = IV.fromSecureRandom(16);
    _aes = AES(aesKey, mode: defMode, padding: defPadding);
    _iv = aesIV;
  }

  StatefulAES.fromParams(String key64, String iv64) {
    Key aesKey = Key.fromBase64(key64);
    IV aesIV = IV.fromBase64(iv64);
    _aes = AES(aesKey, mode: defMode, padding: defPadding);
    _iv = aesIV;
  }

  List<int> key() => _aes.key.bytes.toList();
  List<int> iv() => _iv.bytes.toList();

  String encryptToBase64(String plainText) {
    if (plainText.isEmpty) return plainText;
    List<int> plainTextBytes = utf8.encode(plainText);
    return _encryptToBase64(plainTextBytes);
  }

  String _encryptToBase64(List<int> plainText) {
    final encryptor = Encrypter(_aes);
    final encrypted = encryptor.encryptBytes(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptFromBase64(String cipher) {
    if (cipher.isEmpty) return cipher;
    final decryptor = Encrypter(_aes);
    final decrypted =
        decryptor.decryptBytes(Encrypted.fromBase64(cipher), iv: _iv);
    return utf8.decode(decrypted);
  }
}
