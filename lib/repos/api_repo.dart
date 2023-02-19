import 'dart:convert';

import 'package:discryptor/config/locator.dart';
import 'package:discryptor/extensions/http_ext.dart';
import 'package:discryptor/models/key_value_pair.dart';
import 'package:discryptor/models/models.dart';
import 'package:discryptor/services/network_service.dart';

import 'auth_repo.dart';

// This class may eventually be split into
// - message repository
// - user repository
class ApiRepo {
  ApiRepo()
      : _net = locator.get<NetworkService>(),
        _auth = locator.get<AuthRepo>();

  final NetworkService _net;
  final AuthRepo _auth;

  Future<ApiResponse<List<DiscryptorMessage>>> getMessages(
      int? fromMsgId) async {
    try {
      final uri =
          '/api/items${fromMsgId == null ? '' : '?fromMessageId=$fromMsgId'}';
      final re = await _net.get(uri);
      if (!re.isSuccess()) {
        print('Getting messages failed: ${re.reasonPhrase}');
        return ApiResponse(re.statusCode, re.reasonPhrase, null, false);
      }
      List<DiscryptorMessage> res = (jsonDecode(re.body) as List)
          .map((i) => DiscryptorMessage.fromJson(i))
          .toList();
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting messages: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<ApiResponse<AuthResult>> templatefn() async {
    try {
      const uri = '/api/';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await _auth.refreshAuth();
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

  Future<ApiResponse<List<KeyValuePair<int, int>>>> getUserStatuses() async {
    try {
      const uri = '/api/users/statuses';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await _auth.refreshAuth();
        if (success) return getUserStatuses();
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      List<KeyValuePair<int, int>> res = (jsonDecode(re.body) as List)
          .map((i) => KeyValuePair<int, int>.fromMap(i))
          .toList();
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting user statuses: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<int?> getUserStatus(int userId) async {
    try {
      final uri = '/api/user/$userId/status';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await _auth.refreshAuth();
        if (success) return getUserStatus(userId);
        return 0;
      }
      final result = int.parse(re.body);
      return result;
    } catch (e) {
      print('Error getting user statuses: $e');
      return 0;
    }
  }

  Future<ApiResponse<DiscryptorUserWithRelationship>> getUser(
      int userId) async {
    try {
      final uri = '/api/user/$userId';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await _auth.refreshAuth();
        if (success) return getUser(userId);
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      final res = DiscryptorUserWithRelationship.fromJson(re.body);
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting user $userId: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<ApiResponse<DiscryptorUserWithRelationship>> getUserByName(
      String username, String discriminator) async {
    try {
      final uri =
          '/api/user/search?username=$username&discriminator=$discriminator';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await _auth.refreshAuth();
        if (success) return getUserByName(username, discriminator);
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      final res = DiscryptorUserWithRelationship.fromJson(re.body);
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting user $username#$discriminator: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<ApiResponse<List<DiscryptorUserWithRelationship>>> getUsers() async {
    try {
      const uri = '/api/users';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await _auth.refreshAuth();
        if (success) return getUsers();
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      List<DiscryptorUserWithRelationship> res = (jsonDecode(re.body) as List)
          .map((i) => DiscryptorUserWithRelationship.fromMap(i))
          .toList();
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting users: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }

  Future<ApiResponse<UserAndMessageData>> getUsersAndMessages(
      int? fromMsgId) async {
    try {
      final uri =
          '/api/data${fromMsgId == null ? '' : '?fromMessageId=$fromMsgId'}';
      final re = await _net.get(uri);
      if (re.statusCode == 401) {
        bool success = await _auth.refreshAuth();
        if (success) return getUsersAndMessages(fromMsgId);
        return ApiResponse(re.statusCode, 'Re-authenticate', null, false);
      }
      UserAndMessageData res = UserAndMessageData.fromJson(re.body);
      return ApiResponse(re.statusCode, re.reasonPhrase, res, re.isSuccess());
    } catch (e) {
      print('Error getting users: $e');
      return ApiResponse(300, 'Unexpected error', null, false);
    }
  }
}
