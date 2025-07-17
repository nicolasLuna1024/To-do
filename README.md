# 📱 Lista de Tareas - Flutter & Supabase

Una aplicación móvil completa de gestión de tareas desarrollada con **Flutter** y **Supabase**, que permite a los usuarios crear, gestionar y compartir tareas con funcionalidades avanzadas de imágenes y colaboración en tiempo real.

## 🚀 Características Principales

### ✅ **Autenticación de Usuarios (25 puntos)**
- 🔐 Registro e inicio de sesión con email y contraseña
- 🛡️ Autenticación segura mediante Supabase Auth
- 👤 Gestión de sesiones persistentes
- 🚪 Cierre de sesión seguro

### 📋 **Gestión de Tareas (25 puntos)**
- 📱 Lista organizada de tareas personales y compartidas
- 🏷️ Separación en pestañas: "Mis Tareas" y "Compartidas"
- 🔄 Actualización en tiempo real
- 👥 Sistema de tareas colaborativas

### ➕ **Creación de Nuevas Tareas (25 puntos)**
- ✏️ **Título personalizable** (2 puntos)
- ⚡ **Estado**: Pendiente o Completada (2 puntos)
- 📸 **Gestión de imágenes**: Cámara y galería (19 puntos)
  - Captura directa desde cámara
  - Selección desde galería del dispositivo
  - Subida automática a Supabase Storage
  - Visualización optimizada en las tarjetas
- ⏰ **Fecha de publicación**: Timestamp automático o DatePicker manual (2 puntos)

### 🔄 **Actualización de Tareas (10 puntos)**
- ✅ Marcar tareas como completadas/pendientes
- 🎨 Efectos visuales (texto tachado para completadas)
- 🗑️ Eliminación de tareas propias
- 🤝 Colaboración en tareas compartidas

### 🌟 **Características Adicionales**
- 🎨 Interfaz moderna y responsive
- 📱 Diseño Material Design 3
- 🔒 Row Level Security (RLS) en base de datos
- 📊 Indicadores visuales de estado
- 🏷️ Sistema de etiquetas para tareas compartidas

## 🛠️ Tecnologías Utilizadas

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase
- **Base de Datos**: PostgreSQL (Supabase)
- **Autenticación**: Supabase Auth
- **Storage**: Supabase Storage
- **Gestión de Estado**: Provider
- **Manejo de Imágenes**: image_picker, cached_network_image
- **Permisos**: permission_handler

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   └── task.dart            # Modelo de datos para tareas
├── providers/
│   └── app_provider.dart    # Gestión de estado global
├── screens/
│   ├── login_screen.dart    # Pantalla de autenticación
│   ├── tasks_screen.dart    # Pantalla principal de tareas
│   └── add_task_screen.dart # Formulario para crear tareas
├── services/
│   ├── supabase_service.dart # Configuración de Supabase
│   ├── auth_service.dart     # Servicios de autenticación
│   ├── task_service.dart     # Servicios de tareas
│   └── image_service.dart    # Servicios de imágenes
└── widgets/
    └── task_card.dart       # Componente reutilizable de tarea
```

## 📋 Configuración de la Base de Datos

### Tabla `tasks`
```sql
CREATE TABLE tasks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    is_shared BOOLEAN DEFAULT FALSE
);
```

### Políticas de Seguridad (RLS)
- ✅ Los usuarios solo pueden ver sus propias tareas y las compartidas
- ✅ Los usuarios solo pueden crear, editar y eliminar sus propias tareas
- ✅ Cualquier usuario puede cambiar el estado de tareas compartidas

## 🖼️ Capturas de Pantalla

### 🔐 Inicio de Sesión
<!-- Agregar captura de pantalla del login aquí -->
<img width="387" height="839" alt="image" src="https://github.com/user-attachments/assets/d53caa97-2ab7-441b-9e25-edd9a1c457ba" />


### 📱 Lista de Tareas
<!-- Agregar captura de pantalla de la lista de tareas aquí -->
<img width="389" height="839" alt="image" src="https://github.com/user-attachments/assets/5e2805b4-826d-4830-83d6-5296edea66fe" />


### ➕ Formulario para Agregar Nuevas Tareas
<!-- Agregar captura de pantalla del formulario aquí -->
<img width="388" height="839" alt="image" src="https://github.com/user-attachments/assets/c6bbaf9e-5394-4975-9a23-d684a279974e" />


### 📸 Gestión de Imágenes
<!-- Agregar captura de pantalla de la selección de imágenes aquí -->
<img width="374" height="346" alt="image" src="https://github.com/user-attachments/assets/d62fd9ef-a562-42ad-b8c3-9d21d3bb2767" />


### 🤝 Tareas Compartidas
<!-- Agregar captura de pantalla de tareas compartidas aquí -->
<img width="385" height="837" alt="image" src="https://github.com/user-attachments/assets/f4a440bc-e4ae-4049-9aec-6eac546033f3" />

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK 3.x
- Dart SDK
- Android Studio / VS Code
- Cuenta en Supabase

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone [URL_DEL_REPOSITORIO]
cd flutter_application_1
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Supabase**
- Crear proyecto en [supabase.com](https://supabase.com)
- Ejecutar el script SQL de la base de datos
- Actualizar credenciales en `lib/services/supabase_service.dart`

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 📱 Generación de APK

Para generar el archivo APK para distribución:

```bash
flutter build apk --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## 🔧 Configuración de Permisos

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

## 🌟 Funcionalidades Destacadas

### 🎯 **Sistema de Tareas Colaborativas**
- Las tareas pueden marcarse como "compartidas"
- Visibles para todos los usuarios registrados
- Cualquier usuario puede cambiar el estado de tareas compartidas
- Solo el creador puede eliminar la tarea

### 📸 **Gestión Avanzada de Imágenes**
- Integración completa con cámara y galería
- Compresión automática de imágenes
- Subida asíncrona a Supabase Storage
- URLs públicas para acceso optimizado

### 🔄 **Estado en Tiempo Real**
- Sincronización automática entre dispositivos
- Actualizaciones instantáneas de estado
- Gestión eficiente de memoria con Provider

## 🛡️ Seguridad

- **Row Level Security (RLS)** activado en todas las tablas
- **Políticas de acceso** granulares por usuario
- **Autenticación JWT** con tokens seguros
- **Validación** de permisos en backend y frontend

## 👨‍💻 Autor

**[Nicolas Luna]** 



**⭐ Si te gusta este proyecto, no olvides darle una estrella en GitHub**
