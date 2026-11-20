import 'package:material_ui/material_ui.dart';

import 'models/study_task.dart';
import 'repositories/preferences_repository.dart';
import 'repositories/study_repository.dart';
import 'viewmodels/app_view_model.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/settings_view_model.dart';
import 'viewmodels/study_view_model.dart';
import 'views/app_shell.dart';
import 'views/theme/app_theme.dart';

void main() => runApp(const AulaListaApp());

class AulaListaApp extends StatefulWidget {
  const AulaListaApp({super.key});

  @override
  State<AulaListaApp> createState() => _AulaListaAppState();
}

class _AulaListaAppState extends State<AulaListaApp> {
  final _studyRepository = StudyRepository(
    initial: const [
      StudyTask(
        id: 1,
        title: 'Preparar la demo de Flutter',
        subject: Subject.movil,
      ),
      StudyTask(
        id: 2,
        title: 'Repasar VLAN e inter-VLAN',
        subject: Subject.redes,
      ),
      StudyTask(
        id: 3,
        title: 'Diseñar casos de prueba',
        subject: Subject.calidad,
        done: true,
      ),
    ],
  );
  final _preferencesRepository = PreferencesRepository();
  final _appViewModel = AppViewModel();
  late final _studyViewModel = StudyViewModel(repository: _studyRepository);
  late final _homeViewModel = HomeViewModel(
    studyRepository: _studyRepository,
    preferencesRepository: _preferencesRepository,
  );
  late final _settingsViewModel = SettingsViewModel(
    repository: _preferencesRepository,
  );

  @override
  void dispose() {
    _appViewModel.dispose();
    _homeViewModel.dispose();
    _studyViewModel.dispose();
    _settingsViewModel.dispose();
    _studyRepository.dispose();
    _preferencesRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _settingsViewModel,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula Lista',
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: _settingsViewModel.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: AppShell(
        appViewModel: _appViewModel,
        studyViewModel: _studyViewModel,
        homeViewModel: _homeViewModel,
        settingsViewModel: _settingsViewModel,
      ),
    ),
  );
}
