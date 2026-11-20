import 'package:flutter/foundation.dart';

import '../models/study_preferences.dart';
import '../repositories/preferences_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required PreferencesRepository repository})
    : _repository = repository {
    _repository.addListener(notifyListeners);
  }

  final PreferencesRepository _repository;
  bool get darkMode => _repository.preferences.darkMode;
  int get taskGoal => _repository.preferences.taskGoal;
  int get minGoal => StudyPreferences.minGoal;
  int get maxGoal => StudyPreferences.maxGoal;

  void setDarkMode(bool value) => _repository.setDarkMode(value);
  void setTaskGoal(double value) {
    if (value.isFinite) _repository.setTaskGoal(value.round());
  }

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    super.dispose();
  }
}
