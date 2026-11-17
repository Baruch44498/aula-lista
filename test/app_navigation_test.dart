import 'package:aula_lista/main.dart';
import 'package:aula_lista/models/study_task.dart';
import 'package:aula_lista/repositories/preferences_repository.dart';
import 'package:aula_lista/repositories/study_repository.dart';
import 'package:aula_lista/viewmodels/home_view_model.dart';
import 'package:aula_lista/viewmodels/settings_view_model.dart';
import 'package:aula_lista/viewmodels/study_view_model.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'los ViewModels comparten tareas y preferencias mediante repositorios',
    () {
      final tasks = StudyRepository(
        initial: const [
          StudyTask(id: 8, title: 'Repasar', subject: Subject.redes),
        ],
      );
      final preferences = PreferencesRepository();
      final home = HomeViewModel(
        studyRepository: tasks,
        preferencesRepository: preferences,
      );
      final planner = StudyViewModel(repository: tasks);
      final settings = SettingsViewModel(repository: preferences);
      addTearDown(() {
        home.dispose();
        settings.dispose();
        tasks.dispose();
        preferences.dispose();
      });
      var homeUpdates = 0;
      home.addListener(() => homeUpdates++);
      planner.toggleTask(8);
      expect(home.completed, 1);
      expect(home.nextTasks, isEmpty);
      expect(homeUpdates, 1);
      settings.setTaskGoal(5);
      expect(home.taskGoal, 5);
      expect(home.goalProgress, 0.2);
      expect(home.remainingForGoal, 4);
      planner.addTask('Nuevo', Subject.movil);
      expect(home.nextTasks.single.id, 9);
      expect(home.total, 2);
      expect(homeUpdates, 3);

      // Disposing a screen observer leaves shared repositories usable.
      planner.dispose();
      tasks.addTask('Otra tarea', Subject.calidad);
      expect(home.total, 3);
    },
  );

  testWidgets('completar una tarea actualiza Inicio y conserva el filtro', (
    tester,
  ) async {
    await tester.pumpWidget(const AulaListaApp());
    expect(find.text('Tu espacio de estudio'), findsOneWidget);
    expect(find.text('33%'), findsOneWidget);
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pendientes'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Preparar la demo de Flutter'));
    await tester.tap(find.text('Preparar la demo de Flutter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    expect(find.text('67%'), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();
    expect(find.text('Preparar la demo de Flutter'), findsNothing);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Pendientes'))
          .selected,
      isTrue,
    );
  });

  testWidgets('el tema y la meta permanecen al navegar y redimensionar', (
    tester,
  ) async {
    await tester.pumpWidget(const AulaListaApp());
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    final slider = tester.widget<Slider>(
      find.byKey(const Key('task-goal-slider')),
    );
    slider.onChanged!(5);
    await tester.pumpAndSettle();
    expect(find.text('5 tareas completadas'), findsOneWidget);
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 5'), findsOneWidget);
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('1 / 5'), findsOneWidget);
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    expect(tester.widget<Slider>(find.byType(Slider)).value, 5);
    expect(tester.takeException(), isNull);
  });
}
