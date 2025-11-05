import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:koreanhwa_flutter/shared/utils/api_client.dart';
import 'package:koreanhwa_flutter/shared/utils/local_storage_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(AuthState.initial);

  final Ref _ref;
  String? errorMessage;

  Future<void> login(String email, String password) async {
    state = AuthState.loading;

    final Dio dio = _ref.read(dioProvider);
    final LocalStorageService storage = _ref.read(localStorageServiceProvider);

    try {
      await storage.init();
      final Response<dynamic> response = await dio.post('/auth/login', data: <String, dynamic>{
        'email': email,
        'password': password,
      });
      final dynamic data = response.data;
      final String token = (data is Map && data['token'] is String) ? data['token'] as String : '';
      if (token.isEmpty) {
        throw Exception('Token không hợp lệ');
      }
      await storage.saveToken(token);
      state = AuthState.authenticated;
    } catch (e) {
      errorMessage = e.toString();
      state = AuthState.error;
    }
  }

  Future<void> register(String email, String password) async {
    state = AuthState.loading;

    final Dio dio = _ref.read(dioProvider);
    final LocalStorageService storage = _ref.read(localStorageServiceProvider);

    try {
      await storage.init();
      final Response<dynamic> response = await dio.post('/auth/register', data: <String, dynamic>{
        'email': email,
        'password': password,
      });
      final dynamic data = response.data;
      final String token = (data is Map && data['token'] is String) ? data['token'] as String : '';
      if (token.isEmpty) {
        // Nếu API register không trả token, đánh dấu unauthenticated để buộc login
        state = AuthState.unauthenticated;
        return;
      }
      await storage.saveToken(token);
      state = AuthState.authenticated;
    } catch (e) {
      errorMessage = e.toString();
      state = AuthState.error;
    }
  }

  Future<void> logout() async {
    final LocalStorageService storage = _ref.read(localStorageServiceProvider);
    await storage.deleteToken();
    state = AuthState.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});


