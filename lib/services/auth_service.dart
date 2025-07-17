import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseService.client;

  // Registro de usuario
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  // Inicio de sesión
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  // Cerrar sesión
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Obtener usuario actual
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // Verificar si el usuario está autenticado
  static bool isAuthenticated() {
    return getCurrentUser() != null;
  }

  // Stream para escuchar cambios en el estado de autenticación
  static Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }
}
