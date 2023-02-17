import 'dart:convert';

import 'package:discryptor/config/locator.dart';
import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/repos/preference_repo.dart';
import 'package:discryptor/services/network_service.dart';
import 'package:http/http.dart';
import 'package:discryptor/extensions/http_ext.dart';

// This class may eventually be split into
// - auth repository
// - message repository
// - user repository
class ApiRepo {
  ApiRepo()
      : _prefsRepo = locator.get<PreferenceRepo>(),
        _net = locator.get<NetworkService>();

  final NetworkService _net;
  final PreferenceRepo _prefsRepo;

  Future<DiscryptorUser?> initAuth() async {
    try {
      String? token = await _prefsRepo.token;
      if (token == null) {
        print('Init auth failed: token was null');
        return null;
      }
      _net.setAuthHeader(token);
      bool hasValidToken = await _validateOrRenewToken();
      if (!hasValidToken) {
        // reauthentication needed!
        print('Token validation/renewal failed: Re-authentication needed!');
        return null;
      }
      final user = await _prefsRepo.loggedInUser;
      if (user == null) {
        print('Init auth failed: user was null');
        return null;
      }
      return user;
    } catch (e) {
      print('Init auth failed: $e');
      return null;
    }
  }

  Future<bool> _refreshAuth() async {
    try {
      String? refreshToken = await _prefsRepo.refreshToken;
      if (refreshToken == null) return false;
      // temporarily set auth token to refresh token to get a new normal auth token
      _net.setAuthHeader(refreshToken);
      Response re = await _net.get('/api/auth/refresh');
      if (!re.isSuccessStatusCode()) {
        print('Auth refresh failed: ${re.reasonPhrase}');
        return false;
      }
      String newToken = re.body;
      _net.setAuthHeader(newToken);
      _prefsRepo.setToken(newToken);
      return true;
    } catch (e) {
      print('Failed to refresh auth: $e');
      return false;
    }
  }

  Future<bool> _validateOrRenewToken() async {
    try {
      Response re = await _net.get('/api/authcheck');
      if (!re.isSuccessStatusCode()) {
        bool refreshSuccess = await _refreshAuth();
        if (!refreshSuccess) {
          print('Failed to refresh auth token');
          return false;
        }
        return await _validateOrRenewToken();
      }
      bool isValidToken = jsonDecode(re.body);
      return isValidToken;
    } catch (e) {
      print('$e');
      return false;
    }
  }
}
