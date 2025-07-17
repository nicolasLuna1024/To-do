class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final String? imageUrl;
  final DateTime createdAt;
  final String userId;
  final bool isShared;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.imageUrl,
    required this.createdAt,
    required this.userId,
    this.isShared = false,
  });

  // Convertir desde JSON (datos de Supabase)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['is_completed'] as bool,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String,
      isShared: json['is_shared'] as bool? ?? false,
    );
  }

  // Convertir a JSON (para enviar a Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'is_shared': isShared,
    };
  }

  // Método para crear una copia con valores modificados
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? imageUrl,
    DateTime? createdAt,
    String? userId,
    bool? isShared,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      isShared: isShared ?? this.isShared,
    );
  }
}
