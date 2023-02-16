import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';

import 'algorithm_identifier.dart';

class RFC2898Helper {
  static Future<SecretKey> deriveKey(
      String secret, String salt, int iterations, Hmac hashAlg) async {
    Pbkdf2 pbkdf2 = Pbkdf2(
        macAlgorithm: hashAlg,
        iterations: iterations,
        bits: AlgorithmIdentifier.defDKLen * 64);

    final pwBytes = SecretKey(utf8.encode(secret));
    final saltBytes = base64.decode(salt);

    final dk = await pbkdf2.deriveKey(secretKey: pwBytes, nonce: saltBytes);
    return dk;
  }

  static Future<String> computePasswordHash(
      String password, String salt, int iterations, int hashLen) async {
    final dk = await deriveKey(password, salt, iterations, Hmac.sha512());
    final dkBytes = await dk.extractBytes();

    List<int> hashBytes = dkBytes.sublist(0, hashLen);
    String hashBase64 = base64.encode(hashBytes);
    return hashBase64;
  }

  static Future<String> computePasswordHashIsolate(List<Object> args) async {
    String password = args[0] as String;
    String salt = args[1] as String;
    int iterations = args[2] as int;
    int hashLen = args[3] as int;
    return await computePasswordHash(password, salt, iterations, hashLen);
  }

  static Future<String> encryptWithDerivedKey(
      String password, String salt, List<int> secret) async {
    final dk = await deriveKey(
        password, salt, AlgorithmIdentifier.defIterations, Hmac.sha512());
    int skipped = AlgorithmIdentifier.defHashLen;
    final dkBytes = await dk.extractBytes();
    final derivedAesKey =
        dkBytes.sublist(skipped, skipped + AlgorithmIdentifier.defDKLen);
    skipped += AlgorithmIdentifier.defDKLen;
    final derivedIV =
        dkBytes.sublist(skipped, skipped + AlgorithmIdentifier.defAesIVLen);

    final aesKey = Key.fromBase64(base64.encode(derivedAesKey));
    final aesIV = IV.fromBase64(base64.encode(derivedIV));

    final encryptor =
        Encrypter(AES(aesKey, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encryptor.encryptBytes(secret, iv: aesIV);
    return encrypted.base64;
  }

  static Future<String> decryptWithDerivedKey(
      String password, String salt, String cipherText) async {
    final dk = await deriveKey(
        password, salt, AlgorithmIdentifier.defIterations, Hmac.sha512());
    int skipped = AlgorithmIdentifier.defHashLen;
    final dkBytes = await dk.extractBytes();
    final derivedAesKey =
        dkBytes.sublist(skipped, skipped + AlgorithmIdentifier.defDKLen);
    skipped += AlgorithmIdentifier.defDKLen;
    final derivedIV =
        dkBytes.sublist(skipped, skipped + AlgorithmIdentifier.defAesIVLen);

    final aesKey = Key.fromBase64(base64.encode(derivedAesKey));
    final aesIV = IV.fromBase64(base64.encode(derivedIV));

    final decryptor =
        Encrypter(AES(aesKey, mode: AESMode.cbc, padding: 'PKCS7'));
    final decrypted =
        decryptor.decryptBytes(Encrypted.fromBase64(cipherText), iv: aesIV);
    return utf8.decode(decrypted);
  }
}
