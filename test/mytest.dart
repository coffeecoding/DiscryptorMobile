import 'package:discryptor/services/network_service.dart';

void main() async {
  print('running');
  NetworkService client = NetworkService();
  var response = await client.get('/api/challenge?type=auth');
  print(response.statusCode);
  print(response.body);
}
