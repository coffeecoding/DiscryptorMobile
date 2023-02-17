// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:discryptor/models/common/json_serializable.dart';

class ApiResponse {
  ApiResponse(this.httpStatus, this.message, this.content, this.isSuccess);

  final int httpStatus;
  final String? message;
  final JsonSerializable? content;
  final bool isSuccess;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'httpStatus': httpStatus,
      'message': message,
      'content': content?.toMap(),
      'isSuccess': isSuccess,
    };
  }

  factory ApiResponse.fromMap(CustomType type, Map<String, dynamic> map) {
    return ApiResponse(
      map['httpStatus'] as int,
      map['message'] != null ? map['message'] as String : null,
      map['content'] != null
          ? JsonSerializable.fromMap(
              type, map['content'] as Map<String, dynamic>)
          : null,
      map['isSuccess'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromJson(CustomType type, String source) =>
      ApiResponse.fromMap(type, json.decode(source) as Map<String, dynamic>);
}
