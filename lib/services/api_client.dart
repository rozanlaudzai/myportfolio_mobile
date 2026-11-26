import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportfolio_mobile/config.dart';
import 'package:myportfolio_mobile/models/award.dart';
import 'package:myportfolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'API request failed (HTTP $statusCode)';
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse(baseUrl).resolve('/api/v1/$path');

  Future<List<Project>> getProjects() =>
      _getList('projects/', Project.fromJson);

  Future<List<Award>> getAwards() => _getList('awards/', Award.fromJson);

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await _client.get(
      _uri(path),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);
    final records = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    return records
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Award> createAward(Award award, {required String token}) async {
    final response = await _post('awards/', data: award.toJson(), token: token);
    return Award.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _post(
      'projects/',
      data: project.toJson(),
      token: token,
    );
    return Project.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _post(
      'auth/token/',
      data: {'username': username, 'password': password},
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['token'] as String;
  }

  Future<void> logout({required String token}) async {
    await _post('auth/logout/', token: token);
  }

  Future<http.Response> _post(
    String path, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    final response = await _client.post(
      _uri(path),
      headers: {
        'Accept': 'application/json',
        if (data != null) 'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: data == null ? null : jsonEncode(data),
    );
    _ensureSuccess(response);
    return response;
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
  }

  void close() => _client.close();
}
