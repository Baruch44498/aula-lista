# Aula Lista

Agenda académica en Flutter para la sustentación **Diseño de interfaz utilizando widgets**. Autor: Baruch Isai Medina Anticona.

## Ejecutar en Windows

Requiere Flutter 3.29 o posterior en el PATH. Para la demo web, instala Google Chrome. Abre una terminal en esta carpeta (la que contiene `pubspec.yaml`).

```powershell
flutter doctor
flutter pub get
flutter run -d chrome
```

Para Android, inicia un emulador en Android Studio o conecta un dispositivo con depuración USB. Ejecuta `flutter devices` y luego `flutter run -d ID_DEL_DISPOSITIVO`. La compilación Android requiere el SDK de Android y el JDK configurados mediante `flutter doctor`.

## Demo de un minuto

1. La agenda empieza con tres tareas de ejemplo, una completada (33 %).
2. En **Pendientes**, marca «Preparar la demo de Flutter». Ahora hay dos de tres completadas (67 %).
3. En **Completadas**, verifica que la tarea aparece. Abre **Nueva tarea**, pulsa **Guardar** para ver la validación, escribe «Ensayar la exposición» y guarda. La app vuelve a **Todas** y muestra dos de cuatro completadas (50 %).
4. Reduce el ancho de la ventana para observar cómo la tarjeta de progreso y la lista se apilan.

## Arquitectura y alcance

- **Model** — `lib/models/study_task.dart` define el identificador, el nombre, el curso y el estado de cada tarea.
- **ViewModel** — `lib/viewmodels/study_view_model.dart` valida altas, cambia estados, filtra y calcula el progreso. Notifica mediante `ChangeNotifier`.
- **View** — `lib/views/` presenta widgets y transmite eventos. `ListenableBuilder` reconstruye el contenido al recibir una notificación. `LayoutBuilder` cambia a dos columnas desde 840 px lógicos.

Datos de demostración en memoria. La app restaura las tareas de ejemplo al reiniciar.

## Verificación

```powershell
flutter analyze
flutter test
```
