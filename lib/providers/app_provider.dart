import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';

class AppProvider extends ChangeNotifier {
  User? _currentUser;
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Tareas del usuario actual
  List<Task> get userTasks =>
      _tasks.where((task) => task.userId == _currentUser?.id).toList();

  // Tareas compartidas
  List<Task> get sharedTasks => _tasks
      .where((task) => task.isShared && task.userId != _currentUser?.id)
      .toList();

  AppProvider() {
    _initialize();
  }

  void _initialize() {
    _currentUser = AuthService.getCurrentUser();

    // Escuchar cambios de autenticación
    AuthService.authStateChanges.listen((authState) {
      _currentUser = authState.session?.user;
      if (_currentUser != null) {
        loadTasks();
      } else {
        _tasks.clear();
      }
      notifyListeners();
    });

    if (_currentUser != null) {
      loadTasks();
    }
  }

  // Métodos de autenticación
  Future<void> signUp(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.signUp(email: email, password: password);
      // El listener se encargará de actualizar el estado
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.signIn(email: email, password: password);
      // El listener se encargará de actualizar el estado
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.signOut();
      // El listener se encargará de limpiar el estado
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Métodos de tareas
  Future<void> loadTasks() async {
    try {
      _setLoading(true);
      _clearError();

      _tasks = await TaskService.getTasks();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createTask({
    required String title,
    dynamic imageFile,
    DateTime? customDate,
    bool isShared = false,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final newTask = await TaskService.createTask(
        title: title,
        imageFile: imageFile,
        customDate: customDate,
        isShared: isShared,
      );

      _tasks.insert(0, newTask);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    try {
      _clearError();

      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return;

      final task = _tasks[taskIndex];
      final updatedTask = await TaskService.updateTaskStatus(
        taskId: taskId,
        isCompleted: !task.isCompleted,
      );

      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      _clearError();

      await TaskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Métodos privados de utilidad
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
