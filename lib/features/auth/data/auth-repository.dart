import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository({
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    debugPrint('[Auth] login start: $email');

    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      debugPrint(
        '[Auth] login success. '
        'user=${response.user?.id}, session=${response.session != null}',
      );

      return response;
    } on AuthException catch (error) {
      debugPrint('[Auth] login AuthException: ${error.message} (${error.statusCode})');
      rethrow;
    } catch (error) {
      debugPrint('[Auth] login unknown error: $error');
      rethrow;
    }
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    String? name,
  }) async {
    debugPrint('[Auth] register start: $email');

    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          if (name != null) 'full_name': name,
        },
      );

      debugPrint(
        '[Auth] register success. '
        'user=${response.user?.id}, session=${response.session != null}',
      );

      return response;
    } on AuthException catch (error) {
      debugPrint('[Auth] register AuthException: ${error.message} (${error.statusCode})');
      rethrow;
    } catch (error) {
      debugPrint('[Auth] register unknown error: $error');
      rethrow;
    }
  }

  Future<void> logout() {
    debugPrint('[Auth] logout');
    return _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  Session? get currentSession => _client.auth.currentSession;
}