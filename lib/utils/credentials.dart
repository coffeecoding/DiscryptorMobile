import 'dart:convert';

import 'package:discryptor/models/credentials.dart';

import 'crypto/crypto.dart';

Future<Credentials> createCredentials(
    int userId, String salt64, String pw) async {
  final rsaKeyPair = RSAHelper.createRSAKeyPair();
  final List<int> privKeyBytes =
      utf8.encode(RSAHelper.xmlEncodeRSAPrivateKey(rsaKeyPair.privateKey));
  final String privKeyCryptBase64 =
      await RFC2898Helper.encryptWithDerivedKey(pw, salt64, privKeyBytes);
  final String pubKey = RSAHelper.xmlEncodeRSAPublicKey(rsaKeyPair.publicKey);
  final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  return Credentials(
      created: timestamp,
      publicKey: pubKey,
      privateKeyEncrypted: privKeyCryptBase64,
      userId: userId);
}
