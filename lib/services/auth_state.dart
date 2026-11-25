import 'package:flutter/foundation.dart';
import 'package:myportfolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient);

  final ApiClient _apiClient;
  String? _token;
  Future<void>? _logout;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    await _logout;
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  Future<void> logout() async {
    final current = _token;
    if (current == null) return;
    final pending = _logout ??= _apiClient.logout(token: current);
    try {
      await pending;
    } on ApiException catch (error) {
      if (error.statusCode != 401) rethrow;
    } finally {
      if (identical(_logout, pending)) {
        _token = null;
        _logout = null;
        notifyListeners();
      }
    }
  }
}
