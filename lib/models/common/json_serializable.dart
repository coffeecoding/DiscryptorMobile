import 'package:discryptor/models/models.dart';

enum CustomType {
  authPayload,
  authResult,
  chatMessage,
  credentials,
  discryptorMessage,
  discryptorUser,
  discryptorUserWithRelationship,
  userAndMessageData
}

abstract class JsonSerializable {
  JsonSerializable();

  Map<String, dynamic> toMap();
  CustomType get customType;
  factory JsonSerializable.fromMap(CustomType type, Map<String, dynamic> map) {
    switch (type) {
      case CustomType.authPayload:
        return AuthPayload.fromMap(map);
      case CustomType.authResult:
        return AuthResult.fromMap(map);
      case CustomType.chatMessage:
        return ChatMessage.fromMap(map);
      case CustomType.credentials:
        return Credentials.fromMap(map);
      case CustomType.discryptorMessage:
        return DiscryptorMessage.fromMap(map);
      case CustomType.discryptorUser:
        return DiscryptorUser.fromMap(map);
      case CustomType.discryptorUserWithRelationship:
        return DiscryptorUserWithRelationship.fromMap(map);
      case CustomType.userAndMessageData:
        return UserAndMessageData.fromMap(map);
      default:
        throw 'Custom model type not defined.';
    }
  }
}
