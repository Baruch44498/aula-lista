# Aula Lista

Agenda académica de Baruch Isai Medina Anticona para sustentar **Diseño de interfaz utilizando widgets**. Aplicación Flutter con MVVM compartido entre Android y web.

## Pantallas

- **Inicio** presenta el progreso general, la meta de estudio y las próximas tareas.
- **Tareas** permite registrar actividades, elegir o crear un curso, marcar avances y filtrar.
- **Ajustes** permite cambiar entre tema claro y oscuro y elegir una meta de 1 a 10 tareas.

## Arquitectura

| Capa | Ubicación | Responsabilidad |
| --- | --- | --- |
| Model | `lib/models/` y `lib/repositories/` | Representación y fuente compartida de tareas y preferencias |
| ViewModel | `lib/viewmodels/` | Estado de cada pantalla, navegación, formulario y presentación de los datos |
| View | `lib/views/` | Widgets, estilos, adaptación visual y eventos |

Android inicia Flutter mediante `MainActivity`. La aplicación nativa y Chrome utilizan `lib/main.dart` y las mismas capas MVVM de `lib/`.

La navegación se adapta entre barra inferior y barra lateral. Cada pantalla observa su ViewModel con `ListenableBuilder`. Los repositorios compartidos mantienen sincronizados los datos al navegar.

## Requisitos

Flutter 3.47 o posterior y Dart 3.13 o posterior. Verificado con Flutter 3.50.0 y Dart 3.14.0. Los componentes Material 3 utilizan el paquete oficial `material_ui`.

## Ejecutar

Abrir una terminal en la carpeta que contiene `pubspec.yaml`.

```powershell
flutter doctor
flutter pub get
flutter run -d chrome
```

Para Android, configurar el SDK, aceptar las licencias e iniciar un emulador o conectar un teléfono con depuración USB.

```powershell
flutter doctor --android-licenses
flutter devices
flutter run -d ID_DEL_DISPOSITIVO
```

Sustituir `ID_DEL_DISPOSITIVO` por el identificador mostrado en la lista.

## Verificar

```powershell
flutter analyze
flutter test
flutter build web
```

La suite cubre el formulario, los filtros, la adaptación al ancho y la sincronización entre pantallas. La ejecución Android en un dispositivo requiere comprobación.

Para añadir un curso, abre **Tareas → Nueva tarea → Agregar curso**. Escribe un nombre y presiona **Crear curso**. El formulario selecciona el curso nuevo y lo ofrece en las próximas tareas de la sesión. Además de los cursos, la aplicación mantiene las tareas y las preferencias en memoria. Al reiniciar se restauran los ejemplos, el tema claro y la meta inicial.

La documentación completa de la arquitectura, los flujos, los widgets y la demostración se encuentra en [Aula_Lista_Proyecto.md](Aula_Lista_Proyecto.md).
