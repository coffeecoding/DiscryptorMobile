import 'package:discryptor/models/userAndMessageData.dart';

void main() {
  print("Json-decoding user and message data ...");

  String json = '''
  {"users":[{"id":992381244765655061,"createdAt":1656672526304,"guildId":0,"status":0,"username":"Claude","accentColor":3974236,"discriminator":"3704","avatarUrl":null,"defaultAvatarUrl":"https://cdn.discordapp.com/embed/avatars/4.png","bannerUrl":null,"publicKey":"","isBot":false,"isWebhook":false,"isInitiatorOfRelationship":false,"relationshipAcceptanceDate":1673122810,"relationshipInitiationDate":1673122805,"encryptedSymmKey":"nowhLOyP45uy3wJCelWdXyQTev//EHkWADLqcxoK5sxOuyUoL09MlfJGa7ALoYB8lAOoWlIEakUrBXRjaM/UGBgh7MPj3FsnlJpKGb2VxpFTC1YWH1J9WSjIw3AXBaSRVsGyCJeGadUUaOpktAU7PcLRnIOT3g/1f2Xqo66rq58388/D56JogzLp0xtXwpIpAyuYXtU5uX+3m3YrxzTxxwgxVXMywY9Uv9iKgvCqET9H5D3l6WFpvxnXmQIpt+1f8ozMv4KSv7Mn0b6LYv6yjnCvcsKrzUuuq0Il20pCRKTp2GRMYZa3Ly46Rs4XuksZCEHXZe2lSeVlYOHeWEpl3w=="}],
  "messages":[{"id":1058193055808761956,"channelId":1058193047013310525,"authorId":1056723520656244816,"authorName":"YSCodes","recipientId":0,"isPinned":false,"cleanContent":"","content":"AUTH.M922KUJtAOTv0pdXh4ifuicc4vXoq11f2Ea0f9HdQOOtVm95rbPr+M0qUo2I3k3Z","createdAt":1672363284781,"timestamp":1672363284781}]}''';

  final data = UserAndMessageData.fromJson(json);

  print('');
  print(data.users[0]);
  print('');
  print(data.messages[0]);
  print('');
  print("Done");
}
