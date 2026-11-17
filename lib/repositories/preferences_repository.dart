import 'package:flutter/foundation.dart';

import '../models/study_preferences.dart';

class PreferencesRepository extends ChangeNotifier {
  StudyPreferences _preferences = const StudyPreferences();
  StudyPreferences get preferences => _preferences;

  void setDarkMode(bool value) {
    if (value == _preferences.darkMode) return;
    _preferences = _preferences.copyWith(darkMode: value);
    notifyListeners();
  }

  void setTaskGoal(int value) {
    final goal = value.clamp(
      StudyPreferences.minGoal,
      StudyPreferences.maxGoal,
    );
    if (goal == _preferences.taskGoal) return;
    _preferences = _preferences.copyWith(taskGoal: goal);
    notifyListeners();
  }
}
