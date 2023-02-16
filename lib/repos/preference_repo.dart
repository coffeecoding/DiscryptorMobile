import 'package:discryptor/models/discryptor_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepo {
  PreferenceRepo()
      : _secureStorage = const FlutterSecureStorage(),
        _prefs = SharedPreferences.getInstance();

  static const String _userKey = 'user';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _privkeyKey = 'privkey';
  static const String _pubkeyKey = 'pubkey';
  static const String _signkeyKey = 'signkey';

  static const String _syncKey = 'enableSync';
  static const bool _defaultSyncValue = true;
  static const String _darkModeKey = 'useDarkMode';
  static const bool _defaultUseDarkModeValue = true;

  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _prefs;

  Future<bool> get loggedIn async => await username != null;
  Future<String?> get username async => _secureStorage.read(key: _usernameKey);
  Future<String?> get password async => _secureStorage.read(key: _passwordKey);
  Future<String?> get privkey async => _secureStorage.read(key: _privkeyKey);
  Future<String?> get pubkey async =>
      _prefs.then((sp) => sp.getString(_pubkeyKey));
  Future<String?> get signkey async => _secureStorage.read(key: _signkeyKey);
  Future<DiscryptorUser?> get loggedInUser =>
      _prefs.then((SharedPreferences prefs) {
        String? userJson = prefs.getString(_userKey);
        if (userJson == null) return null;
        return DiscryptorUser.fromJson(userJson);
      });

  Future<bool> get enableSync async =>
      await _prefs.then((SharedPreferences prefs) =>
          prefs.getBool(_syncKey) ?? _defaultSyncValue);

  Future<void> setEnableSync(bool newValue) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(_syncKey, newValue);
  }

  Future<bool> get useDarkMode async =>
      await _prefs.then((SharedPreferences prefs) =>
          prefs.getBool(_syncKey) ?? _defaultUseDarkModeValue);

  Future<void> setUseDarkMode(bool newValue) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(_darkModeKey, newValue);
  }

  Future<void> clearAuth() async {
    await _secureStorage.deleteAll();
  }

  Future<void> setAuth({
    required DiscryptorUser user,
    required String username,
    required String password,
    required String pubkey,
    required String privkey,
    required String signkey,
  }) async {
    _prefs.then((prefs) => prefs.setString(_userKey, user.toJson()));
    AndroidOptions androidOptions = AndroidOptions();
    try {
      await _secureStorage.write(
        key: _usernameKey,
        value: username,
        aOptions: androidOptions,
      );
      await _secureStorage.write(
        key: _passwordKey,
        value: password,
        aOptions: androidOptions,
      );
      await _secureStorage.write(
        key: _privkeyKey,
        value: privkey,
        aOptions: androidOptions,
      );
      await _prefs.then((sp) => sp.setString(_pubkeyKey, pubkey));
      await _secureStorage.write(
        key: _signkeyKey,
        value: signkey,
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
