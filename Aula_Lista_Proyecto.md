# Aula Lista

Agenda académica en Flutter con arquitectura **MVVM — Model View ViewModel**, preparada para demostrar el tema **Diseño de interfaz utilizando widgets**.

**Autor** — Baruch Isai Medina Anticona

**Versión** — 1.0.0+1

**Sustentación prevista** — Semana 14, 18 de noviembre de 2026

**Repositorio** — [Baruch44498/aula-lista](https://github.com/Baruch44498/aula-lista)

## Objetivo

Diseñar una interfaz adaptable e interactiva mediante widgets de Flutter y organizar los datos, el estado y la presentación con MVVM.

El proyecto contiene tres pantallas conectadas. Una tarea completada en Tareas actualiza el resumen de Inicio. Una meta modificada en Ajustes actualiza el progreso de la meta. El cambio de tema se aplica a toda la interfaz.

## MVVM en Chrome y en la aplicación nativa

**La aplicación Android y la versión web ejecutan las mismas clases Model, View y ViewModel de la carpeta `lib/`.**

MVVM describe la organización del código de la aplicación. Flutter proporciona los widgets, el motor y la integración con cada plataforma. Al seleccionar Chrome o Android cambia el destino de ejecución y se conserva la organización de la aplicación.

| Parte | Android | Chrome |
| --- | --- | --- |
| Entrada de plataforma | `MainActivity` hereda de `FlutterActivity` y recibe el arranque de Android | `web/index.html` y el arranque web generado por Flutter |
| Entrada Dart | `main()` en `lib/main.dart` | `main()` en `lib/main.dart` |
| Model | `StudyTask`, `StudyPreferences` y repositorios compartidos | Las mismas clases |
| ViewModel | Navegación, Inicio, Tareas, Ajustes y formulario | Las mismas clases |
| View | Widgets Flutter de `lib/views/` | Los mismos widgets |
| Adaptación visual | Se calcula con el ancho disponible | Se calcula con el ancho disponible |

El archivo `android/app/src/main/kotlin/pe/edu/app/aula_lista/MainActivity.kt` contiene el arranque de Flutter en Android. Las reglas de tareas y preferencias se encuentran en las capas Dart del proyecto.

La presencia de un `StatefulWidget` permite administrar el ciclo de vida de objetos como un `TextEditingController`. Los cambios de las tareas, las preferencias, el formulario y la selección de pantalla se administran mediante los ViewModels y los repositorios indicados a continuación.

## Pantallas y funciones

| Pantalla | Funciones | ViewModel |
| --- | --- | --- |
| Inicio | Porcentaje completado, meta, tareas pendientes y accesos a Tareas y Ajustes | `HomeViewModel` |
| Tareas | Alta de tareas y cursos, selección de curso, casillas de cumplimiento y filtros | `StudyViewModel` |
| Ajustes | Tema claro u oscuro con Switch y meta de 1 a 10 tareas con Slider | `SettingsViewModel` |
| Formulario de nueva tarea | Nombre, selección y alta de curso, validación y registro de la tarea | `TaskFormViewModel` |
| Navegación común | Selección de Inicio, Tareas o Ajustes | `AppViewModel` |

La navegación utiliza `NavigationBar` en anchos pequeños y `NavigationRail` desde 840 píxeles lógicos de ancho de ventana.

## Tecnologías y requisitos

El proyecto utiliza Flutter, Dart y Material 3 mediante el paquete oficial `material_ui`. Esta dependencia requiere Flutter 3.47 o posterior y Dart 3.13 o posterior. La verificación de esta ampliación se realizó con Flutter 3.50.0 y Dart 3.14.0, correspondientes al SDK instalado en el equipo de preparación y a la versión de Flutter indicada por el autor.

Los imports de componentes Material utilizan `package:material_ui/material_ui.dart`. Los modelos permanecen independientes de los widgets y los ViewModels utilizan `ChangeNotifier` de Flutter Foundation.

## Capas de la arquitectura

### Model y repositorios

`StudyTask` representa una tarea con identificador, nombre, curso y estado de cumplimiento. Sus propiedades son finales y `withDone` crea una copia con un nuevo estado.

`StudyPreferences` representa el tema elegido y la meta de estudio. `copyWith` devuelve una nueva configuración.

`Subject` representa un curso por su nombre. El catálogo comienza con Desarrollo móvil, Redes y Calidad de software.

`StudyRepository` conserva las tareas y los cursos de la sesión. Valida los nombres, asigna identificadores a las tareas y cambia su estado mediante una copia del modelo.

`PreferencesRepository` conserva las preferencias de la sesión y mantiene la meta entre 1 y 10 tareas.

Los repositorios extienden `ChangeNotifier`. Inicio y Tareas reciben los mismos datos mediante sus propios ViewModels. Inicio y Ajustes comparten las preferencias mediante el mismo repositorio.

### ViewModel

| Clase | Responsabilidad |
| --- | --- |
| `AppViewModel` | Conserva la sección seleccionada y comunica los cambios de navegación |
| `HomeViewModel` | Obtiene totales, pendientes, progreso, próximas tareas y avance de la meta |
| `StudyViewModel` | Conserva el filtro, presenta la lista correspondiente y solicita altas o cambios al repositorio |
| `SettingsViewModel` | Expone el tema y la meta, y transmite los cambios al repositorio |
| `TaskFormViewModel` | Conserva el nombre y el curso en edición, solicita el alta y expone el error del formulario |

`StudyViewModel` conserva la posibilidad de recibir tareas iniciales directamente. Cuando recibe un repositorio compartido, se suscribe a sus cambios y deja su ciclo de vida a la composición raíz.

Cada ViewModel elimina sus suscripciones al ejecutar `dispose()`. `AulaListaApp` crea y libera los repositorios y los ViewModels de la aplicación.

### View

Las vistas construyen widgets, adaptan la distribución al espacio y transmiten las interacciones a los ViewModels. `ListenableBuilder` reconstruye el contenido cuando cambia el estado.

El diseño del tema se encuentra en `lib/views/theme/app_theme.dart`. Sus colores se consumen mediante `Theme.of(context).colorScheme`.

## Flujo al completar una tarea

1. El usuario marca un `CheckboxListTile` en `PlannerPage`.
2. La vista llama a `StudyViewModel.toggleTask(id)`.
3. El ViewModel solicita el cambio a `StudyRepository`.
4. El repositorio sustituye la tarea por una copia y notifica el cambio.
5. `StudyViewModel` y `HomeViewModel` reciben la notificación.
6. Los `ListenableBuilder` muestran los valores actualizados.
7. Al volver a Inicio se observa el mismo avance.

## Flujo al cambiar el tema

1. El usuario acciona el Switch de Ajustes.
2. `SettingsViewModel` solicita el cambio a `PreferencesRepository`.
3. El repositorio crea una nueva configuración y notifica el cambio.
4. El ViewModel notifica a sus observadores.
5. `AulaListaApp` reconstruye `MaterialApp` con el `ThemeMode` correspondiente.

La meta sigue un flujo equivalente y su cambio también se refleja en `HomeViewModel`.

## Organización de archivos

| Ruta | Contenido |
| --- | --- |
| `lib/main.dart` | Composición raíz, datos iniciales y ciclo de vida |
| `lib/models/study_task.dart` | Modelos de tareas y cursos |
| `lib/models/study_preferences.dart` | Preferencias de tema y meta |
| `lib/repositories/study_repository.dart` | Colecciones y operaciones de tareas y cursos |
| `lib/repositories/preferences_repository.dart` | Preferencias compartidas de la sesión |
| `lib/viewmodels/` | ViewModels de las pantallas, navegación y formulario |
| `lib/views/app_shell.dart` | Scaffold, AppBar y navegación adaptable |
| `lib/views/home_page.dart` | Pantalla Inicio |
| `lib/views/planner_page.dart` | Pantalla Tareas |
| `lib/views/settings_page.dart` | Pantalla Ajustes |
| `lib/views/task_dialog.dart` | Diálogo de alta |
| `lib/views/widgets/study_progress_card.dart` | Componente visual de progreso |
| `lib/views/theme/app_theme.dart` | Temas claro y oscuro |
| `test/planner_test.dart` | Validación, filtros, formulario y distribución |
| `test/app_navigation_test.dart` | Datos compartidos, navegación, tema y meta |
| `android/` | Integración y configuración Android |
| `web/` | Inicio y configuración web |

## Widgets utilizados

| Widget | Uso |
| --- | --- |
| `MaterialApp` | Tema y pantalla raíz |
| `Scaffold`, `AppBar` y `SafeArea` | Estructura común |
| `NavigationBar` y `NavigationRail` | Navegación entre las tres pantallas |
| `LayoutBuilder` | Adaptación según el espacio disponible |
| `Row`, `Column`, `Expanded` y `Wrap` | Distribución de contenido |
| `Card`, `Container`, `Text` e `Icon` | Presentación de datos |
| `ListenableBuilder` | Observación del ViewModel |
| `ChoiceChip` | Filtro de tareas |
| `CheckboxListTile` | Cumplimiento de una tarea |
| `LinearProgressIndicator` | Progreso general y de la meta |
| `FilledButton` y `TextButton` | Acciones y accesos |
| `AlertDialog` | Formulario emergente |
| `TextField` y `DropdownButtonFormField` | Nombre y curso |
| `SwitchListTile.adaptive` | Selección de tema |
| `Slider` | Selección de la meta |
| `SingleChildScrollView` | Desplazamiento de cada pantalla |

## Agregar un curso desde el formulario

1. En **Tareas**, abrir **Nueva tarea** y pulsar **Agregar curso**.
2. Escribir un nombre y pulsar **Crear curso**. El nombre admite de 1 a 40 caracteres y se compara con los cursos existentes sin distinguir mayúsculas.
3. El `StudyRepository` incorpora el curso al catálogo. El `TaskFormViewModel` lo selecciona y el desplegable se actualiza. El curso queda disponible en futuras tareas de la sesión.

## Reglas y almacenamiento

- El nombre se limpia con `trim()` y admite de 1 a 70 caracteres según la longitud de la cadena Dart.
- Una entrada inválida mantiene abierto el diálogo y muestra un mensaje.
- Cada tarea recibe un identificador incremental.
- El alta agrega la tarea al inicio y selecciona el filtro Todas.
- El porcentaje general considera todas las tareas.
- El avance de la meta utiliza la cantidad de tareas completadas de la sesión.
- La meta admite valores enteros de 1 a 10 y su indicador visual se limita al 100 %.
- Cambiar de pantalla conserva las tareas, el filtro y las preferencias.
- Al reiniciar la aplicación se restauran las tareas y los cursos de ejemplo, el tema claro y la meta de tres tareas.

Los datos se mantienen en memoria durante la sesión.

## Datos iniciales

| Tarea | Curso | Estado |
| --- | --- | --- |
| Preparar la demo de Flutter | Desarrollo móvil | Pendiente |
| Repasar VLAN e inter-VLAN | Redes | Pendiente |
| Diseñar casos de prueba | Calidad de software | Completada |

Inicio muestra 33 % de progreso general y una tarea completada de una meta inicial de tres.

## Ejecutar en Chrome

Abrir la carpeta que contiene `pubspec.yaml` y ejecutar en la terminal.

```powershell
flutter doctor
flutter pub get
flutter run -d chrome
```

## Ejecutar la aplicación nativa en Android

Configurar Android Studio con el SDK Android, Platform Tools y Android SDK Command-line Tools. Completar las licencias y revisar el diagnóstico.

```powershell
flutter doctor --android-licenses
flutter doctor
flutter devices
```

Iniciar un emulador o conectar un teléfono con depuración USB y ejecutar con el identificador mostrado por `flutter devices`.

```powershell
flutter run -d ID_DEL_DISPOSITIVO
```

Para generar el paquete de instalación con el SDK Android configurado.

```powershell
flutter build apk --release
```

La salida habitual es `build/app/outputs/flutter-apk/app-release.apk`.

## Comprobaciones

```powershell
flutter analyze
flutter test
flutter build web
```

Resultados de la versión anterior al alta de cursos, con Flutter 3.50.0 y Dart 3.14.0.

| Comprobación | Resultado |
| --- | --- |
| Análisis estático | Sin incidencias |
| Suite automatizada | Siete pruebas aprobadas |
| Compilación web | Completada |
| Revisión visual | Capturas de widgets en anchos de celular y escritorio y en ambos temas |
| APK y dispositivo Android | Pendientes de comprobar con un entorno Android configurado |

La suite comprueba altas y validación, filtros, formulario, adaptación a dos anchos, sincronización entre ViewModels y conservación del tema y la meta. La ampliación añade un caso de prueba para el alta, selección y reutilización de cursos desde el formulario de tareas.

La compilación APK y la ejecución en un dispositivo Android requieren comprobación con el SDK y un dispositivo configurados.

## Guion para la sustentación

1. Abrir Inicio y presentar el progreso de 33 %, la meta y las próximas tareas.
2. Entrar en Tareas, seleccionar Pendientes y completar Preparar la demo de Flutter.
3. Mostrar el avance de 67 % y volver a Inicio para comprobar la sincronización.
4. Regresar a Tareas y abrir Nueva tarea. Guardar vacío para mostrar la validación.
5. Agregar el curso Base de datos, crear la tarea Diseñar tablas y comprobar el nuevo total de cuatro tareas con 50 % de progreso.
6. Entrar en Ajustes, activar el modo oscuro y cambiar la meta con el Slider.
7. Volver a Inicio y mostrar la nueva meta con el tema elegido.
8. Cambiar el tamaño de la ventana y explicar NavigationBar, NavigationRail y LayoutBuilder.
9. Recorrer los modelos, los repositorios y los ViewModels del código y explicar un flujo de interacción.
10. Explicar que Android y Chrome comparten estas mismas capas Dart.

## Referencias

- [Guía de arquitectura de Flutter](https://docs.flutter.dev/app-architecture/guide)
- [Descripción de la arquitectura y las plataformas de Flutter](https://docs.flutter.dev/resources/architectural-overview)
- [Diseño adaptable](https://docs.flutter.dev/ui/adaptive-responsive/general)
- [ListenableBuilder](https://api.flutter.dev/flutter/widgets/ListenableBuilder-class.html)

- [Migración de Material en Flutter 3.50](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui)
