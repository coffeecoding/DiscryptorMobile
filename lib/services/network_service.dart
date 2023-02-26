import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ProxyAwareHttpClient extends IOClient {
  ProxyAwareHttpClient()
      : super(HttpClient()..findProxy = HttpClient.findProxyFromEnvironment);
}

class NetworkService {
  NetworkService()
      : _client = ProxyAwareHttpClient(),
        _defaultHeaders = {
          'Content-Type': 'application/json',
          'Authorization': ''
        },
        socket =
            HubConnectionBuilder().withUrl('http://$baseUrl/socket').build() {
    final options = HttpConnectionOptions(
        requestTimeout: 15000,
        skipNegotiation: true,
        transport: HttpTransportType.WebSockets);
    // HttpConnection cn =
    // HttpConnection('http://$baseUrl/socket', options: options);
    // cn.start();
    //socket.start();
    socket.onclose(({error}) => print('Socket closed with error: $error'));
  }

  static const String baseUrl = 'server.discryptor.io';
  //static const String baseUrl = '192.168.178.44:5278';

  final http.Client _client;
  final HubConnection socket;
  final Map<String, String> _defaultHeaders;

  void setToken(String authToken) {
    _defaultHeaders['Authorization'] = 'Bearer $authToken';
  }

  Uri _createUri(String requestUri) {
    return Uri.parse('https://$baseUrl$requestUri');
  }

  Uri _createUriHttps(String requestUri) {
    return Uri.parse('https://$baseUrl$requestUri');
  }

  Future<Response> get(String requestUri) async {
    return await _client.get(_createUri(requestUri), headers: _defaultHeaders);
  }

  Future<Response> post(String requestUri, String jsonBody) async {
    return await _client.post(_createUri(requestUri),
        body: jsonBody, headers: _defaultHeaders);
  }

  Future<Response> put(String requestUri, [String? jsonBody]) async {
    return await _client.put(_createUri(requestUri),
        body: jsonBody, headers: _defaultHeaders);
  }

  Future<Response> delete(String requestUri, [String? body]) async {
    return await _client.delete(_createUri(requestUri),
        headers: _defaultHeaders, body: body);
  }
}
