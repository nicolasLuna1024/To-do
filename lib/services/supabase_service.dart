import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // TODO: Reemplaza estas constantes con tus datos reales de Supabase
  // Los obtienes de tu dashboard de Supabase
  static const String supabaseUrl = 'https://seqpohrdmgcqmpytztks.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlcXBvaHJkbWdjcW1weXR6dGtzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3Nzg2NzEsImV4cCI6MjA2ODM1NDY3MX0.0jXAQokDrRAqya9yQcV4JeenoQv8JdO4ZO-P4u56L7w';

  static late Supabase _instance;

  // Getter para acceder fácilmente al cliente de Supabase
  static SupabaseClient get client => _instance.client;

  // Método para inicializar Supabase
  static Future<void> initialize() async {
    _instance = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  // Método para obtener el usuario actual
  static User? get currentUser => client.auth.currentUser;

  // Método para verificar si el usuario está autenticado
  static bool get isAuthenticated => currentUser != null;
}
