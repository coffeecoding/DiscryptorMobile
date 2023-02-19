import 'dart:convert';

import 'package:discryptor/config/locator.dart';
import 'package:discryptor/repos/preference_repo.dart';
import 'package:discryptor/services/network_service.dart';
import 'package:http/http.dart';
import 'package:discryptor/extensions/http_ext.dart';

import '../models/models.dart';

class AuthRepo {
  AuthRepo()
      : _prefsRepo = locator.get<PreferenceRepo>(),
        _net = locator.get<NetworkService>();

  final NetworkService _net;
  final PreferenceRepo _prefsRepo;

  // SignalR comment
  // Fixed by going with docs of parameter on clients and server like KeepAliveInterval & you should increase the timeout of HttpConnectionOptions like this:
  // final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, requestTimeout: 15000, skipNegotiation: true, transport: HttpTransportType.WebSockets);
  // see issue: https://github.com/sefidgaran/signalr_client/issues/37

  /// template function for any generic API call
  Future<ApiResponse<AuthResult>> templatefn() async {
    try {
      const uri = '/api/';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await refreshAuth();
        if (success) return templatefn();
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      //final res = CLASS.fromJson(re.body);
      return ApiResponse(re.statusCode, re.reasonPhrase, null, re.isSuccess());
    } catch (e) {
      print('Error doing X: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<ApiResponse<AuthResult>> authenticate(AuthPayload authPayload) async {
    try {
      Response re = await _net.post('/api/auth', json.encode(authPayload));
      if (!re.isSuccess()) {
        print('auth failed: ${re.reasonPhrase}');
        return ApiResponse(re.statusCode, re.reasonPhrase, null, false);
      }
      AuthResult result = AuthResult.fromJson(re.body);

      _net.setAuthHeader(result.token);
      _prefsRepo.setAuth(
          user: result.user,
          token: result.token,
          refreshToken: result.refreshToken);
      return ApiResponse<AuthResult>(
          re.statusCode, null, result, re.isSuccess());
    } catch (e) {
      print('Failed to authenticate: $e');
      return ApiResponse(300, e.toString(), null, false);
    }
  }

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
      final user = await _prefsRepo.user;
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

  Future<String?> getChallenge([String type = 'auth']) async {
    try {
      final uri = '/api/challenge?type=$type';
      final re = await _net.get(uri);
      final c = re.body;
      return c;
    } catch (e) {
      print('Error doing X: $e');
      return null;
    }
  }

  Future<ApiResponse<String>> getPublicKey(int userId) async {
    try {
      final uri = '/api/user/$userId/pubkey';
      final re = await _net.get(uri);
      final res = re.body;
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting pubkey of $userId: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<bool> refreshAuth() async {
    try {
      String? refreshToken = await _prefsRepo.refreshToken;
      if (refreshToken == null) return false;
      // temporarily set auth token to refresh token to get a new normal auth token
      _net.setAuthHeader(refreshToken);
      Response re = await _net.get('/api/auth/refresh');
      if (!re.isSuccess()) {
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
      if (!re.isSuccess()) {
        bool refreshSuccess = await refreshAuth();
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
