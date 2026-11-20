import 'package:aula_lista/main.dart';
import 'package:aula_lista/models/study_task.dart';
import 'package:aula_lista/viewmodels/study_view_model.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('valida las altas y calcula el progreso de todas las tareas', () {
    final viewModel = StudyViewModel();
    addTearDown(viewModel.dispose);
    expect(viewModel.progress, 0);
    expect(viewModel.addTask('   ', Subject.redes), isFalse);
    expect(viewModel.addTask('x' * 71, Subject.redes), isFalse);
    viewModel.setFilter(TaskFilter.completed);
    expect(viewModel.addTask('  Repasar VLAN  ', Subject.redes), isTrue);
    expect(viewModel.filter, TaskFilter.all);
    final task = viewModel.visibleTasks.single;
    expect(task.title, 'Repasar VLAN');
    expect(task.subject, Subject.redes);
    viewModel.setFilter(TaskFilter.pending);
    viewModel.toggleTask(task.id);
    expect(viewModel.visibleTasks, isEmpty);
    expect(viewModel.progress, 1);
  });

  testWidgets('marcar una tarea actualiza filtro y porcentaje', (tester) async {
    await tester.pumpWidget(const AulaListaApp());
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();
    expect(find.text('33%'), findsOneWidget);
    await tester.tap(find.text('Pendientes'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Preparar la demo de Flutter'));
    await tester.tap(find.text('Preparar la demo de Flutter'));
    await tester.pumpAndSettle();
    expect(find.text('67%'), findsOneWidget);
    expect(find.text('Preparar la demo de Flutter'), findsNothing);
    await tester.tap(find.text('Completadas'));
    await tester.pumpAndSettle();
    expect(find.text('Preparar la demo de Flutter'), findsOneWidget);
  });

  testWidgets('el diálogo muestra el error y permite guardar', (tester) async {
    await tester.pumpWidget(const AulaListaApp());
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Ingresa un nombre de 1 a 70 caracteres.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'Ensayar la exposición');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Ensayar la exposición'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
  });

  testWidgets('crea un curso desde el formulario y lo reutiliza', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AulaListaApp());
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    final taskName = find.widgetWithText(TextField, 'Nombre de la tarea');
    await tester.enterText(taskName, 'Diseñar tablas');
    await tester.tap(find.text('Agregar curso'));
    await tester.pumpAndSettle();
    final courseName = find.widgetWithText(TextField, 'Nombre del curso');
    await tester.tap(find.text('Crear curso'));
    await tester.pumpAndSettle();
    expect(find.text('Ingresa un nombre de 1 a 40 caracteres.'), findsOneWidget);
    await tester.enterText(courseName, '  REDES  ');
    await tester.tap(find.text('Crear curso'));
    await tester.pumpAndSettle();
    expect(find.text('Ya existe un curso con ese nombre.'), findsOneWidget);
    await tester.enterText(courseName, '  Base de datos  ');
    await tester.tap(find.text('Crear curso'));
    await tester.pumpAndSettle();
    final courseDropdown = find.byType(DropdownButtonFormField<Subject>);
    expect(
      tester.widget<DropdownButtonFormField<Subject>>(courseDropdown).initialValue,
      const Subject('Base de datos'),
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Diseñar tablas'), findsOneWidget);
    expect(find.text('Base de datos'), findsOneWidget);

    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    final dropdown = find.descendant(
      of: courseDropdown,
      matching: find.byType(DropdownButton<Subject>),
    );
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Base de datos').last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<DropdownButtonFormField<Subject>>(courseDropdown).initialValue,
      const Subject('Base de datos'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('la tarjeta se apila a 360 y comparte la fila a 1024', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 820));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AulaListaApp());
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();
    final narrowSummary = tester.getTopLeft(find.text('Progreso de estudio'));
    final narrowTasks = tester.getTopLeft(find.text('Mis tareas'));
    expect(narrowTasks.dy, greaterThan(narrowSummary.dy + 100));

    await tester.binding.setSurfaceSize(const Size(1024, 820));
    await tester.pumpAndSettle();
    final wideSummary = tester.getTopLeft(find.text('Progreso de estudio'));
    final wideTasks = tester.getTopLeft(find.text('Mis tareas'));
    expect(wideTasks.dx, greaterThan(wideSummary.dx + 250));
    expect((wideTasks.dy - wideSummary.dy).abs(), lessThan(15));
    expect(tester.takeException(), isNull);
  });
}
