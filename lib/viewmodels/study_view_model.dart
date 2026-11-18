import 'package:flutter/foundation.dart';

import '../models/study_task.dart';
import '../repositories/study_repository.dart';

enum TaskFilter {
  all('Todas'),
  pending('Pendientes'),
  completed('Completadas');

  const TaskFilter(this.label);
  final String label;
}

class StudyViewModel extends ChangeNotifier {
  StudyViewModel({
    Iterable<StudyTask> initial = const [],
    StudyRepository? repository,
  }) : _repository = repository ?? StudyRepository(initial: initial),
       _ownsRepository = repository == null {
    _repository.addListener(notifyListeners);
  }

  final StudyRepository _repository;
  final bool _ownsRepository;
  TaskFilter _filter = TaskFilter.all;

  TaskFilter get filter => _filter;
  List<Subject> get subjects => _repository.subjects;
  int get total => _repository.tasks.length;
  int get completed => _repository.tasks.where((task) => task.done).length;
  double get progress => total == 0 ? 0 : completed / total;

  List<StudyTask> get visibleTasks => List.unmodifiable(
    _repository.tasks.where(
      (task) => switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.pending => !task.done,
        TaskFilter.completed => task.done,
      },
    ),
  );

  void setFilter(TaskFilter value) {
    if (value == _filter) return;
    _filter = value;
    notifyListeners();
  }

  bool addTask(String title, Subject subject) {
    // Select the filter before notifying so every observer sees the final state.
    final oldFilter = _filter;
    _filter = TaskFilter.all;
    final added = _repository.addTask(title, subject);
    if (!added) _filter = oldFilter;
    return added;
  }

  Subject? addSubject(String label) => _repository.addSubject(label);

  void toggleTask(int id) => _repository.toggleTask(id);

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    if (_ownsRepository) _repository.dispose();
    super.dispose();
  }
}
