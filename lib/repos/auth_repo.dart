import 'dart:convert';

import 'package:discryptor/config/locator.dart';
import 'package:discryptor/repos/preference_repo.dart';
import 'package:discryptor/services/network_service.dart';
import 'package:http/http.dart';
import 'package:discryptor/extensions/http_ext.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../models/models.dart';

class AuthRepo {
  AuthRepo()
      : _prefsRepo = locator.get<PreferenceRepo>(),
        _net = locator.get<NetworkService>();

  final NetworkService _net;
  final PreferenceRepo _prefsRepo;

  HubConnection get socket => _net.socket;

  Future<bool> connectSignalR() async {
    try {
      await _net.socket.stop();
      await _net.socket.start();
      if (_net.socket.state == HubConnectionState.Connected) {
        _net.socket.on('Disconnect', (_) => _net.socket.stop());
        _net.socket.onreconnecting(({error}) {
          print('Socket reconnecting due to error $error');
        });
        _net.socket.onreconnected(({connectionId}) async {
          try {
            print('Socket reconnected with id $connectionId!');
            final tk = await _prefsRepo.token;
            if (tk != null) {
              _net.socket.invoke('ConnectClient', args: [tk]);
            }
          } catch (e) {
            print('OnReconnected error: $e');
          }
        });

        final token = await _prefsRepo.token;

        if (token != null) {
          final success =
              await _net.socket.invoke('ConnectClient', args: [token]);
          return success as bool;
        }
        return false;
      }
      print('SignalR connection start unsuccessful.');
      return false;
    } catch (e) {
      print('SignalR connection failed: $e');
      return false;
    }
  }

  Future<ApiResponse<AuthResult>> authenticate(AuthPayload authPayload) async {
    try {
      Response re = await _net.post('/api/auth', authPayload.toJson());
      if (!re.isSuccess()) {
        print('auth failed: ${re.reasonPhrase}');
        return ApiResponse(re.statusCode, re.reasonPhrase, null, false);
      }
      AuthResult result = AuthResult.fromJson(re.body);

      _net.setToken(result.token);
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
      _net.setToken(token);
      bool hasValidToken = await validateOrRenewToken();
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

  Future<ApiResponse<bool>> register(Credentials creds) async {
    try {
      const uri = '/api/register';
      final re = await _net.post(uri, creds.toJson());
      if (re.statusCode == 401) {
        bool success = await refreshAuth();
        if (success) return register(creds);
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      return ApiResponse(re.statusCode, re.reasonPhrase, true, re.isSuccess());
    } catch (e) {
      print('Error getting credentials: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<ApiResponse<Credentials>> getCredentials() async {
    try {
      const uri = '/api/creds';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await refreshAuth();
        if (success) return getCredentials();
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      final res = Credentials.fromJson(re.body);
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting credentials: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<bool> refreshAuth() async {
    try {
      String? refreshToken = await _prefsRepo.refreshToken;
      if (refreshToken == null) return false;
      // temporarily set auth token to refresh token to get a new normal auth token
      _net.setToken(refreshToken);
      Response re = await _net.get('/api/auth/refresh');
      if (!re.isSuccess()) {
        print('Auth refresh failed: ${re.reasonPhrase}');
        return false;
      }
      String newToken = re.body;
      _net.setToken(newToken);
      _prefsRepo.setToken(newToken);
      return true;
    } catch (e) {
      print('Failed to refresh auth: $e');
      return false;
    }
  }

  Future<bool> validateOrRenewToken() async {
    try {
      Response re = await _net.get('/api/authcheck');
      if (!re.isSuccess()) {
        bool refreshSuccess = await refreshAuth();
        if (!refreshSuccess) {
          print('Failed to refresh auth token');
          return false;
        }
        return await validateOrRenewToken();
      }
      bool isValidToken = jsonDecode(re.body);
      return isValidToken;
    } catch (e) {
      print('$e');
      return false;
    }
  }
}
