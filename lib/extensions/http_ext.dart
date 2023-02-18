import 'package:http/http.dart';

extension HttpExtensions on Response {
  bool isSuccess() => statusCode >= 200 && statusCode < 300;
}
