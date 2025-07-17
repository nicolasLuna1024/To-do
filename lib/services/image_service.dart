import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  // Solicitar permisos necesarios
  static Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();
    final photosStatus = await Permission.photos.request();

    return cameraStatus.isGranted &&
        (storageStatus.isGranted || photosStatus.isGranted);
  }

  // Mostrar opciones para seleccionar imagen
  static Future<File?> showImageSourceDialog() async {
    // En una implementación real, aquí mostrarías un diálogo
    // Por ahora, vamos a implementar métodos separados
    return null;
  }

  // Tomar foto con la cámara
  static Future<File?> pickImageFromCamera() async {
    try {
      // Verificar permisos
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw Exception('Permisos de cámara no concedidos');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Error al tomar foto: $e');
    }
  }

  // Seleccionar imagen de la galería
  static Future<File?> pickImageFromGallery() async {
    try {
      // Verificar permisos
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw Exception('Permisos de galería no concedidos');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Error al seleccionar imagen: $e');
    }
  }
}
