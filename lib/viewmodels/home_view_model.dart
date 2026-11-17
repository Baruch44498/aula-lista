import 'package:flutter/foundation.dart';

import '../models/study_task.dart';
import '../repositories/preferences_repository.dart';
import '../repositories/study_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required StudyRepository studyRepository,
    required PreferencesRepository preferencesRepository,
  }) : _studyRepository = studyRepository,
       _preferencesRepository = preferencesRepository {
    _studyRepository.addListener(notifyListeners);
    _preferencesRepository.addListener(notifyListeners);
  }

  final StudyRepository _studyRepository;
  final PreferencesRepository _preferencesRepository;

  int get total => _studyRepository.tasks.length;
  int get completed => _studyRepository.tasks.where((task) => task.done).length;
  int get pending => total - completed;
  double get progress => total == 0 ? 0 : completed / total;
  int get taskGoal => _preferencesRepository.preferences.taskGoal;
  double get goalProgress => (completed / taskGoal).clamp(0, 1);
  int get remainingForGoal => (taskGoal - completed).clamp(0, taskGoal);
  List<StudyTask> get nextTasks => List.unmodifiable(
    _studyRepository.tasks.where((task) => !task.done).take(3),
  );

  @override
  void dispose() {
    _studyRepository.removeListener(notifyListeners);
    _preferencesRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
