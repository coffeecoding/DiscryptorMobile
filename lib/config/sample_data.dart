import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';

class SampleData {
  static DiscryptorUser sampleUser = DiscryptorUser.fromJson(
      '{"id":1056723520656244816,"createdAt":1672012920298,"guildId":0,"status":0,"username":"YSCodes","accentColor":null,"discriminator":"7098","avatarUrl":"https://cdn.discordapp.com/avatars/1056723520656244816/a0898580035852afadcefd155f7753ab.png?size=128","defaultAvatarUrl":"https://cdn.discordapp.com/embed/avatars/3.png","bannerUrl":null,"publicKey":"PFJTQUtleVZhbHVlPjxNb2R1bHVzPjRrTXlTeDNRWUF4T0pjNlJRdTE3ZTFKMXFrSGs5eGwzeGRIOTl5dzVSWU9aME80OE80Yk5EQmZZbVJaWm5haFhRVHJoVlpKYTVsSXhNcDI4RmhuTWhlb0FwNGYyKzZFVmszOS9UZTdHZFFkQUwva003Rjg3cThZdEV1UWhjZWl0aXU3a0JQRkg2YmVrcVJwNXhjUU5xZDVmWHRjT05uOTErSFhXNEZtREV1UWhvb3dFL0lrSW9mYmdBdDRTZjEvbkJhVUthQ0ZmR1VueE1xNEdXbXZJTWNOdU4yckRFRGRHT1pLNTJZRVJJK1FWRjhCcENFUmFLSWttNUFFak03d2luODVscDVUQ0traDE2MFNCK053cEhUTGswVVdZeXlzWkQrbUY3ZGRyRlZOQzRZYWdoNElldjhvd0NQeW0vQkF5WlU2WTRZVys0SFlVV21PTUZjK1d1UT09PC9Nb2R1bHVzPjxFeHBvbmVudD5BUUFCPC9FeHBvbmVudD48L1JTQUtleVZhbHVlPg==","isBot":false,"isWebhook":false}');
  static DiscryptorUserWithRelationship friend1 =
      DiscryptorUserWithRelationship.fromJson(
          '{"id":992381244765655061,"createdAt":1656672526304,"guildId":0,"status":0,"username":"Claude","accentColor":3974236,"discriminator":"3704","avatarUrl":null,"defaultAvatarUrl":"https://cdn.discordapp.com/embed/avatars/4.png","bannerUrl":null,"publicKey":"","isBot":false,"isWebhook":false,"isInitiatorOfRelationship":false,"relationshipAcceptanceDate":1673122810,"relationshipInitiationDate":1673122805,"encryptedSymmKey":"nowhLOyP45uy3wJCelWdXyQTev//EHkWADLqcxoK5sxOuyUoL09MlfJGa7ALoYB8lAOoWlIEakUrBXRjaM/UGBgh7MPj3FsnlJpKGb2VxpFTC1YWH1J9WSjIw3AXBaSRVsGyCJeGadUUaOpktAU7PcLRnIOT3g/1f2Xqo66rq58388/D56JogzLp0xtXwpIpAyuYXtU5uX+3m3YrxzTxxwgxVXMywY9Uv9iKgvCqET9H5D3l6WFpvxnXmQIpt+1f8ozMv4KSv7Mn0b6LYv6yjnCvcsKrzUuuq0Il20pCRKTp2GRMYZa3Ly46Rs4XuksZCEHXZe2lSeVlYOHeWEpl3w=="}');

  static List<DiscryptorUserWithRelationship> sampleContacts =
      <DiscryptorUserWithRelationship>[friend1];
}
