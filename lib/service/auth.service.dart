import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<AuthResponse> login(String usr, String pwd) async {
    try {
    
      return await _client.auth.signInWithPassword(
        email: usr,
        password: pwd,
      );
    } catch (e) {
      throw Exception('Failed to log in: ${e.toString()}');
    }
  }

  Future<AuthResponse> register(String usr, String pwd) async {
    try {
      return await _client.auth.signUp(email: usr, password: pwd);
    } catch (e) {
      throw Exception('Failed to register in: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      return await _client.auth.signOut();
    } catch (e) {
      throw Exception('Failed to signOut: ${e.toString()}');
    }
  }
}
