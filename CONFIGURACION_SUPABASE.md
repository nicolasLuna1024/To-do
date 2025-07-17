# Configuración de Supabase - PASOS IMPORTANTES

## 1. Crear proyecto en Supabase
1. Ve a https://supabase.com
2. Crea una cuenta nueva o inicia sesión
3. Haz clic en "New Project"
4. Elige un nombre para tu proyecto
5. Crea una contraseña para la base de datos
6. Selecciona una región cercana a tu ubicación
7. Espera a que se cree el proyecto (2-3 minutos)

## 2. Obtener credenciales
1. En el dashboard de tu proyecto, ve a "Settings" > "API"
2. Copia la "Project URL" 
3. Copia la "anon/public" key
4. Pega estos valores en el archivo: lib/services/supabase_service.dart

## 3. Crear la base de datos
1. Ve a "SQL Editor" en el dashboard
2. Haz clic en "New Query"
3. Copia y pega el siguiente código SQL:

```sql
-- Crear tabla de tareas
CREATE TABLE tasks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    is_shared BOOLEAN DEFAULT FALSE
);

-- Habilitar Row Level Security
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Política para que los usuarios vean sus propias tareas y las compartidas
CREATE POLICY "Users can view own tasks and shared tasks" ON tasks
    FOR SELECT USING (
        auth.uid() = user_id OR is_shared = true
    );

-- Política para que los usuarios puedan crear tareas
CREATE POLICY "Users can create own tasks" ON tasks
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Política para que los usuarios puedan actualizar sus propias tareas
CREATE POLICY "Users can update own tasks" ON tasks
    FOR UPDATE USING (auth.uid() = user_id);

-- Política para que los usuarios puedan eliminar sus propias tareas
CREATE POLICY "Users can delete own tasks" ON tasks
    FOR DELETE USING (auth.uid() = user_id);
```

4. Haz clic en "Run" para ejecutar el script

## 4. Configurar Storage para imágenes
1. Ve a "Storage" en el dashboard
2. Haz clic en "Create bucket"
3. Nombre del bucket: "task-images"
4. Marca "Public bucket" como true
5. Haz clic en "Create bucket"

## 5. Habilitar autenticación por email
1. Ve a "Authentication" > "Settings"
2. En "Auth providers", asegúrate de que "Email" esté habilitado
3. Opcionalmente puedes deshabilitar "Confirm email" para facilitar las pruebas

## ¡IMPORTANTE!
Después de completar estos pasos, actualiza el archivo:
`lib/services/supabase_service.dart`

Reemplaza:
- 'TU_SUPABASE_URL_AQUI' con tu Project URL
- 'TU_SUPABASE_ANON_KEY_AQUI' con tu anon key
