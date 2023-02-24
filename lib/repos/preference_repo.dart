import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/utils/crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/credentials.dart';

class PreferenceRepo {
  PreferenceRepo()
      : _secureStorage = const FlutterSecureStorage(),
        _prefs = SharedPreferences.getInstance();

  static const String _userKey = 'user';
  static const String _usernameKey = 'username';
  static const String _useridKey = 'userid';
  static const String _privkeyKey = 'privkey';
  static const String _pwsalt = 'pwsalt';
  static const String _fullnameKey = 'fullname';

  static const String _credentialsKey = 'credskey';

  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refreshToken';

  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _prefs;

  // cached, safe, backing values for non-async access to public pref values
  String? cachedUsername;
  String? cachedFullname;
  int? cachedUserId;
  String? cachedSalt;
  DiscryptorUser? cachedUser;

  // public preferences access
  Future<String?> get username async => cachedUsername ??=
      await _prefs.then((prefs) => prefs.getString(_usernameKey));
  Future<String?> get fullname async => cachedFullname ??=
      await _prefs.then((prefs) => prefs.getString(_fullnameKey));
  Future<int?> get userId async =>
      cachedUserId ??= await _prefs.then((prefs) => prefs.getInt(_useridKey));
  Future<String?> get salt async =>
      cachedSalt ??= await _prefs.then((prefs) => prefs.getString(_pwsalt));
  Future<DiscryptorUser?> get user async =>
      cachedUser ??= await _prefs.then((SharedPreferences prefs) {
        String? userJson = prefs.getString(_userKey);
        if (userJson == null) return null;
        return DiscryptorUser.fromJson(userJson);
      });

  // secure storage access
  Future<String?> get privkey async => _secureStorage.read(key: _privkeyKey);
  Future<String?> get token async => _secureStorage.read(key: _tokenKey);
  Future<String?> get refreshToken async =>
      _secureStorage.read(key: _refreshTokenKey);

  void clearPublicDataAndUser() {
    cachedUser = null;
    cachedUserId = null;
    cachedSalt = null;
    cachedFullname = null;
    cachedUsername = null;
  }

  void setPublicUserData(String fullname, String pwSalt, int userId) {
    _prefs.then((prefs) => prefs.setInt(_useridKey, userId));
    _prefs.then((prefs) => prefs.setString(_pwsalt, pwSalt));
    _prefs.then((prefs) => prefs.setString(_fullnameKey, fullname));
  }

  Future<void> clearAuth() async {
    await _secureStorage.deleteAll();
    _prefs.then((prefs) {
      prefs.remove(_usernameKey);
      prefs.remove(_useridKey);
      prefs.remove(_userKey);
      prefs.remove(_credentialsKey);
      prefs.remove(_pwsalt);
      prefs.remove(_fullnameKey);
    });
  }

  Future<void> setToken(String token) async {
    AndroidOptions androidOptions = const AndroidOptions();
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (_) {
      try {
        await _secureStorage.deleteAll(
          aOptions: androidOptions,
        );
      } catch (_) {
        // Invoke logger here
      }
      rethrow;
    }
  }

  Future<bool> decryptAndSavePrivateKey(String pw, String encryptedKey) async {
    try {
      String? salt = await _prefs.then((prefs) => prefs.getString(_pwsalt));
      if (salt == null) {
        print('Cannot decrypt key: salt not found');
        return false;
      }
      String decryptedPrivateKeyXml = await compute(
          RFC2898Helper.decryptWithDerivedKeyIsolate, [pw, salt, encryptedKey]);
      await _setPrivateKey(decryptedPrivateKeyXml);
      return true;
    } catch (e) {
      print('Failed to decrypt password: $e');
      return false;
    }
  }

  Future<void> _setPrivateKey(String privKeyXml) async {
    AndroidOptions androidOptions = const AndroidOptions();
    await _secureStorage.write(
      key: _privkeyKey,
      value: privKeyXml,
      aOptions: androidOptions,
    );
  }

  void setCredentials(Credentials creds) =>
      _prefs.then((prefs) => prefs.setString(_credentialsKey, creds.toJson()));

  Future<void> setAuth(
      {required DiscryptorUser user,
      required String token,
      required String refreshToken}) async {
    _prefs.then((prefs) => prefs.setString(_userKey, user.toJson()));
    _prefs.then((prefs) => prefs.setString(_usernameKey, user.username));
    _prefs.then((prefs) => prefs.setInt(_useridKey, user.id));
    AndroidOptions androidOptions = const AndroidOptions();
    try {
      await _secureStorage.write(
        key: _tokenKey,
        value: token,
        aOptions: androidOptions,
      );
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: refreshToken,
        aOptions: androidOptions,
      );
    } catch (_) {
      try {
        await _secureStorage.deleteAll(
          aOptions: androidOptions,
        );
      } catch (_) {
        // Invoke logger here
      }
      rethrow;
    }
  }
}
