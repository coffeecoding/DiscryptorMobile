import 'package:http/http.dart';

extension HttpExtensions on Response {
  bool isSuccessStatusCode() => statusCode >= 200 && statusCode < 300;
}
