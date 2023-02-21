import 'package:http/http.dart' as http;

void main() async {
  http.Client client = http.Client();
  final re = await client.get(Uri(
      scheme: 'http',
      host: '192.168.178.44',
      port: 5278,
      path: '/api/user/pubsearch?username=YSCodes&discriminator=7098'));
  print(re.statusCode);
  final re2 = await client.get(Uri.parse(
      'http://192.168.178.44:5278/api/user/pubsearch?username=YSCodes&discriminator=7098'));
  print(re2.statusCode);
}
