// Various business logic functions

import 'dart:convert';

import 'package:discryptor/config/locator.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:discryptor/models/operation.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/utils/crypto/crypto.dart';
import 'package:discryptor/utils/string.dart';

class DiscryptorBL {
  DiscryptorBL()
      : prefRepo = locator.get<PreferenceRepo>(),
        apiRepo = locator.get<ApiRepo>();

  final ApiRepo apiRepo;
  final PreferenceRepo prefRepo;

  Future<Operation<DiscryptorUserWithRelationship>> initiateRelationship(
      DiscryptorUserWithRelationship user) async {
    String acceptorSymmKey = '';
    String pubkeyXml = base64ToUTF8(user.publicKey);
    if (user.encryptedSymmKey == null || user.encryptedSymmKey!.isEmpty) {
      StatefulAES aes = StatefulAES();
      final keyBytes = RSAHelper.rsaEncrypt(aes.key(), pubkeyXml);
      acceptorSymmKey = base64.encode(keyBytes);
    } else {
      final privKey = await prefRepo.privkey;
      final symmKeyBytes =
          RSAHelper.rsaDecrypt(user.encryptedSymmKey!, privKey!);
      acceptorSymmKey = base64.encode(symmKeyBytes);
    }
    final re = await apiRepo.initiateRelationship(user.id, acceptorSymmKey);
    if (!re.isSuccess) {
      return Operation(false,
          userMsg: 'Unexpected error',
          debugMsg:
              "Error initiating friendship with user ${user.username}: ${re.message}");
    }
    final clone = user.copyWith(
        relationshipInitiationDate: re.content!.dateInitiated,
        encryptedSymmKey: re.content!.initiatorSymmetricKey);
    return Operation(true, result: clone);
  }

  Future<Operation<DiscryptorUserWithRelationship>> acceptRelationship(
      DiscryptorUserWithRelationship user) async {
    final re = await apiRepo.getRelationshipWith(user.id);
    if (!re.isSuccess) {
      return Operation(false,
          userMsg: 'Unexpected error',
          debugMsg:
              "Error accepting friendship with user ${user.username}: ${re.message}");
    }
    // decrypt the symmkey and encrypt with initiator's key
    final symmKey = re.content!.acceptorSymmetricKey;
    final pubKey = base64ToUTF8(user.publicKey);
    final privKey = await prefRepo.privkey;
    final decryptedSymmKey = RSAHelper.rsaDecrypt(symmKey!, privKey!);
    final initiatorSymmKey = RSAHelper.rsaEncrypt(decryptedSymmKey, pubKey);
    final encryptedSymmKey = base64.encode(initiatorSymmKey);

    final res = await apiRepo.acceptRelationship(user.id, encryptedSymmKey);
    if (!re.isSuccess) {
      return Operation(false,
          userMsg: 'Unexpected error',
          debugMsg:
              "Error accepting friendship with user ${user.username}: ${re.message}");
    }
    final clone = user.copyWith(
        encryptedSymmKey: res.content!.acceptorSymmetricKey,
        relationshipAcceptanceDate: res.content!.dateAccepted);
    return Operation(true, result: clone);
  }

  Future<Operation<DiscryptorUserWithRelationship>> cancelRelationship(
      DiscryptorUserWithRelationship user) async {
    final re = await apiRepo.cancelRelationship(user.id);
    if (!re.isSuccess) {
      return Operation(false,
          userMsg: 'Unexpected error',
          debugMsg:
              "Error cancelling friendship with ${user.username}: ${re.message}");
    }
    final clone = user.copyWith(
        isInitiatorOfRelationship: false,
        relationshipAcceptanceDate: 0,
        relationshipInitiationDate: 0);
    return Operation(true, result: clone);
  }
}
