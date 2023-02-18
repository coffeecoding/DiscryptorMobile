import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/services/crypto_service.dart';
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

  static const String _credentialsKey = 'credskey';

  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refreshToken';

  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _prefs;

  Future<bool> get loggedIn async => await username != null;
  Future<String?> get username async =>
      _prefs.then((prefs) => prefs.getString(_usernameKey));
  Future<int?> get userId async =>
      _prefs.then((prefs) => prefs.getInt(_useridKey));
  Future<String?> get privkey async => _secureStorage.read(key: _privkeyKey);
  Future<String?> get token async => _secureStorage.read(key: _tokenKey);
  Future<String?> get refreshToken async =>
      _secureStorage.read(key: _refreshTokenKey);
  Future<DiscryptorUser?> get user => _prefs.then((SharedPreferences prefs) {
        String? userJson = prefs.getString(_userKey);
        if (userJson == null) return null;
        return DiscryptorUser.fromJson(userJson);
      });

  Future<void> clearAuth() async {
    await _secureStorage.deleteAll();
    _prefs.then((prefs) {
      prefs.remove(_usernameKey);
      prefs.remove(_useridKey);
      prefs.remove(_userKey);
      prefs.remove(_credentialsKey);
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

  Future<void> setPrivateKey(String privkey) async {
    AndroidOptions androidOptions = const AndroidOptions();
    await _secureStorage.write(
      key: _privkeyKey,
      value: CryptoService.base64ToUTF8(privkey),
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