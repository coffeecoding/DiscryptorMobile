import 'dart:convert';

import 'package:discryptor/config/locator.dart';
import 'package:discryptor/ephemeral/chat_message.dart';
import 'package:discryptor/repos/preference_repo.dart';

import '../utils/crypto/crypto.dart';

class CryptoService {
  CryptoService() : prefsRepo = locator.get<PreferenceRepo>();

  late PreferenceRepo prefsRepo;

  base64ToUTF8(String input) => utf8.decode(base64.decode(input).toList());
  utf8ToBase64(String input) => base64.encode(utf8.encode(input));

  ChatMessage encryptMessage(ChatMessage chatMessage, String key) {
    StatefulAES dummyAes = StatefulAES();
    StatefulAES aes = StatefulAES.fromParams(key, base64.encode(dummyAes.iv()));
    return ChatMessage(
        iv: base64.encode(aes.iv()),
        message: aes.encryptToBase64(chatMessage.message));
  }

  String decryptMessage(String message, String ivBase64, String key) {
    StatefulAES aes = StatefulAES.fromParams(key, ivBase64);
    return aes.decryptFromBase64(message);
  }

  String _encodeIVKey(StatefulAES aes, String pubKeyXml) {
    List<int> keyCrypt = RSAHelper.rsaEncrypt(aes.key(), pubKeyXml);
    List<int> ivKey = aes.iv();
    ivKey.addAll(keyCrypt);
    return base64.encode(ivKey);
  }

  StatefulAES _decodeIVKeyAndCreateAES(String ivKey64, String privKeyXml) {
    List<int> ivKeyBytes = base64.decode(ivKey64);
    String iv64 = base64.encode(ivKeyBytes.sublist(0, 16));
    List<int> key =
        RSAHelper.rsaDecrypt(base64.encode(ivKeyBytes.sublist(16)), privKeyXml);
    String key64 = base64.encode(key);
    return StatefulAES.fromParams(key64, iv64);
  }
}
