import 'dart:convert';

import 'package:encrypt/encrypt.dart' as ENCRYPT;
import "package:pointycastle/export.dart";
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:xml/xml.dart';

import 'algorithm_identifier.dart';

class RSAHelper {
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> createRSAKeyPair() {
    return generateRSAkeyPair(secureRNG(),
        bitLength: AlgorithmIdentifier.defRSAKeyLen);
  }

  /// From https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
  static SecureRandom secureRNG() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    return secureRandom;
  }

  /// From https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = AlgorithmIdentifier.defRSAKeyLen}) {
    // Create an RSA key generator and initialize it
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 12),
          secureRandom));

    // Use the generator
    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types
    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  static List<int> rsaEncrypt(List<int> data, String pubKeyXml) {
    final ENCRYPT.Encrypter encryptor = ENCRYPT.Encrypter(ENCRYPT.RSA(
        publicKey: parseRSAPublicKeyFromXml(pubKeyXml),
        encoding: ENCRYPT.RSAEncoding.PKCS1));
    ENCRYPT.Encrypted cipher = encryptor.encryptBytes(data);
    return cipher.bytes.toList();
  }

  static List<int> rsaDecrypt(String cipher64, String privKeyXml) {
    ENCRYPT.Encrypted cipher = ENCRYPT.Encrypted.fromBase64(cipher64);
    final encryptor = ENCRYPT.Encrypter(ENCRYPT.RSA(
        privateKey: parseRSAPrivateKeyFromXml(privKeyXml),
        encoding: ENCRYPT.RSAEncoding.PKCS1));
    List<int> decrypted = encryptor.decryptBytes(cipher);
    return decrypted;
  }

  static RSAPublicKey parseRSAPublicKeyFromXml(String xml) {
    final doc = XmlDocument.parse(xml);
    var exponents = doc.findAllElements('Exponent');
    if (exponents.isEmpty) throw ('Xml public key error: Exponent not found');
    var moduli = doc.findAllElements('Modulus');
    if (moduli.isEmpty) throw ('Xml public key error: Modulus not found');
    String exponent = exponents.first.innerText;
    BigInt e = bytesToBigInt(base64.decode(exponent));
    String modulus = moduli.first.innerText;
    BigInt m = bytesToBigInt(base64.decode(modulus));
    RSAPublicKey pubKey = RSAPublicKey(m, e);
    return pubKey;
  }

  static RSAPrivateKey parseRSAPrivateKeyFromXml(String xml) {
    final doc = XmlDocument.parse(xml);
    var exponent = doc.findAllElements('Exponent');
    if (exponent.isEmpty) throw ('Xml private key error: Exponent not found');
    var modulus = doc.findAllElements('Modulus');
    if (modulus.isEmpty) throw ('Xml private key error: Modulus not found');
    var pAll = doc.findAllElements('P');
    if (pAll.isEmpty) throw ('Xml private key error: P not found');
    var qAll = doc.findAllElements('Q');
    if (qAll.isEmpty) throw ('Xml private key error: Q not found');
    var dpAll = doc.findAllElements('DP');
    if (dpAll.isEmpty) throw ('Xml private key error: DP not found');
    var dqAll = doc.findAllElements('DQ');
    if (dqAll.isEmpty) throw ('Xml private key error: DQ not found');
    var invQALL = doc.findAllElements('InverseQ');
    if (invQALL.isEmpty) throw ('Xml private key error: InverseQ not found');
    var dAll = doc.findAllElements('D');
    if (dAll.isEmpty) throw ('Xml private key error: D not found');

    String e64 = exponent.first.innerText;
    BigInt e = bytesToBigInt(base64.decode(e64));
    String m64 = modulus.first.innerText;
    BigInt m = bytesToBigInt(base64.decode(m64));
    String p64 = pAll.first.innerText;
    BigInt p = bytesToBigInt(base64.decode(p64));
    String q64 = qAll.first.innerText;
    BigInt q = bytesToBigInt(base64.decode(q64));
    String dp64 = dpAll.first.innerText;
    BigInt dp = bytesToBigInt(base64.decode(dp64));
    String dq64 = dqAll.first.innerText;
    BigInt dq = bytesToBigInt(base64.decode(dq64));
    String inverseQ64 = invQALL.first.innerText;
    BigInt inverseQ = bytesToBigInt(base64.decode(inverseQ64));
    String d64 = dAll.first.innerText;
    BigInt d = bytesToBigInt(base64.decode(d64));

    RSAPrivateKey privateKey = RSAPrivateKey(m, d, p, q);
    return privateKey;
  }

  static String xmlEncodeRSAPublicKey(RSAPublicKey pubKey) {
    String e64 = base64.encode(bigIntToBytes4Intellectuals(pubKey.exponent!));
    String m64 = base64.encode(bigIntToBytes4Intellectuals(pubKey.modulus!));
    final builder = XmlBuilder();
    builder.element('RSAKeyValue', nest: () {
      builder.element('Modulus', nest: m64);
      builder.element('Exponent', nest: e64);
    });
    final pubKeyXml = builder.buildDocument();
    return pubKeyXml.toXmlString();
  }

  static String xmlEncodeRSAPrivateKey(RSAPrivateKey privKey) {
    String e64 =
        base64.encode(bigIntToBytes4Intellectuals(privKey.publicExponent!));
    String m64 = base64.encode(bigIntToBytes4Intellectuals(privKey.modulus!));
    String p64 = base64.encode(bigIntToBytes4Intellectuals(privKey.p!));
    String q64 = base64.encode(bigIntToBytes4Intellectuals(privKey.q!));
    String d64 =
        base64.encode(bigIntToBytes4Intellectuals(privKey.privateExponent!));

    // COMPUTE CRT PARAMETERS:
    // POINTYCASTLE DOESN'T PROVIDE THE CRT PARAMETERS dp, dq AND iQ (inverseQ)
    // HENCE WE NEED TO COMPUTE THEM OURSELVES. CHECK WIKI FOR DETAILS:
    // https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Using_the_Chinese_remainder_algorithm
    // dp = d mod(p-1)
    // dq = d mod(q-1)
    // iQ = q ^ (-1) mod p
    BigInt dp = privKey.privateExponent! % (privKey.p! - BigInt.one);
    BigInt dq = privKey.privateExponent! % (privKey.q! - BigInt.one);
    BigInt iQ = privKey.q!.modInverse(privKey.p!);

    String dp64 = base64.encode(bigIntToBytes4Intellectuals(dp));
    String dq64 = base64.encode(bigIntToBytes4Intellectuals(dq));
    String iQ64 = base64.encode(bigIntToBytes4Intellectuals(iQ));

    final builder = XmlBuilder();
    builder.element('RSAKeyValue', nest: () {
      builder.element('Modulus', nest: m64);
      builder.element('Exponent', nest: e64);
      builder.element('P', nest: p64);
      builder.element('Q', nest: q64);
      builder.element('DP', nest: dp64);
      builder.element('DQ', nest: dq64);
      builder.element('InverseQ', nest: iQ64);
      builder.element('D', nest: d64);
    });
    final pubKeyXml = builder.buildDocument();
    return pubKeyXml.toXmlString();
  }

  // From a fella that helped me: https://stackoverflow.com/a/68971866/12213872
  /// Creates a [BigInt] from a sequence of [bytes], which is assumed to be in
  /// big-endian order.
  static BigInt bytesToBigInt(Iterable<int> bytes) {
    BigInt result = BigInt.zero;
    for (int byte in bytes) {
      result = (result << 8) | BigInt.from(byte);
    }
    return result;
  }

  // From a fella that helped me: https://stackoverflow.com/a/68971866/12213872
  static BigInt bytesToBigInt4Intellectuals(Iterable<int> bytes) => bytes.fold(
        BigInt.zero,
        (resultSoFar, byte) => (resultSoFar << 8) | BigInt.from(byte),
      );

  /// Returns big-endian byte array of big int.
  static List<int> bigIntToBytes4Intellectuals(BigInt big) {
    List<int> result = [];
    while (big.compareTo(BigInt.zero) > 0) {
      result.insert(0, (big & BigInt.from(255)).toInt());
      big = big >> 8;
    }
    return result;
  }

  /// Returns big endian byte array of big int.
  static List<int> bigIntToBytesForPlebs(BigInt big) {
    List<int> result = [];
    while (big.compareTo(BigInt.zero) > 0) {
      int byte = 0;
      for (int e = 0; e < 8; e++) {
        if (big.isOdd) {
          byte += BigInt.from(2).pow(e).toInt();
        }
        big = big >> 1;
      }
      result.insert(0, byte);
    }
    return result;
  }
}
