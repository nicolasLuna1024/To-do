import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';
import 'supabase_service.dart';

class TaskService {
  static final SupabaseClient _client = SupabaseService.client;

  // Obtener todas las tareas del usuario actual y las compartidas
  static Future<List<Task>> getTasks() async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      // Obtener tareas del usuario y tareas compartidas
      final response = await _client
          .from('tasks')
          .select()
          .or('user_id.eq.${user.id},is_shared.eq.true')
          .order('created_at', ascending: false);

      return (response as List).map((task) => Task.fromJson(task)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  // Crear nueva tarea
  static Future<Task> createTask({
    required String title,
    File? imageFile,
    DateTime? customDate,
    bool isShared = false,
  }) async {
    try {
      print('🔧 TaskService: Iniciando creación de tarea...');

      final user = SupabaseService.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      print('✅ Usuario autenticado: ${user.id}');

      String? imageUrl;

      // Subir imagen si se proporciona
      if (imageFile != null) {
        print('📷 Subiendo imagen...');
        imageUrl = await _uploadImage(imageFile, user.id);
        print('✅ Imagen subida: $imageUrl');
      } else {
        print('📝 Tarea sin imagen');
      }

      final taskData = {
        'title': title,
        'is_completed': false,
        'image_url': imageUrl,
        'created_at': (customDate ?? DateTime.now()).toIso8601String(),
        'user_id': user.id,
        'is_shared': isShared,
      };

      print('📤 Enviando datos a Supabase: $taskData');

      final response = await _client
          .from('tasks')
          .insert(taskData)
          .select()
          .single();

      print('✅ Respuesta de Supabase: $response');
      print('🎉 Tarea creada exitosamente');

      return Task.fromJson(response);
    } catch (e) {
      print('❌ Error al crear tarea: $e');
      throw Exception('Error al crear tarea: $e');
    }
  }

  // Actualizar estado de tarea (completada/pendiente)
  static Future<Task> updateTaskStatus({
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      final response = await _client
          .from('tasks')
          .update({'is_completed': isCompleted})
          .eq('id', taskId)
          .select()
          .single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  // Eliminar tarea
  static Future<void> deleteTask(String taskId) async {
    try {
      await _client.from('tasks').delete().eq('id', taskId);
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }

  // Método privado para subir imágenes
  static Future<String> _uploadImage(File imageFile, String userId) async {
    try {
      print('🔧 Iniciando subida de imagen...');

      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'task_images/$fileName';

      print('📁 Ruta de archivo: $path');
      print('📁 Tamaño de archivo: ${await imageFile.length()} bytes');

      await _client.storage.from('task-images').upload(path, imageFile);
      print('✅ Imagen subida al storage');

      final publicUrl = _client.storage.from('task-images').getPublicUrl(path);
      print('🔗 URL pública generada: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ Error al subir imagen: $e');
      throw Exception('Error al subir imagen: $e');
    }
  }
}
