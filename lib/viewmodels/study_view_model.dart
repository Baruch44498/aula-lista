import 'package:flutter/foundation.dart';
import '../models/study_task.dart';

enum TaskFilter {
  all('Todas'),
  pending('Pendientes'),
  completed('Completadas');

  const TaskFilter(this.label);
  final String label;
}

class StudyViewModel extends ChangeNotifier {
  StudyViewModel({Iterable<StudyTask> initial = const []})
    : _tasks = List.of(initial) {
    for (final task in _tasks) {
      if (task.id >= _nextId) _nextId = task.id + 1;
    }
  }

  final List<StudyTask> _tasks;
  int _nextId = 1;
  TaskFilter _filter = TaskFilter.all;

  TaskFilter get filter => _filter;
  int get total => _tasks.length;
  int get completed => _tasks.where((task) => task.done).length;
  double get progress => total == 0 ? 0 : completed / total;

  List<StudyTask> get visibleTasks => List.unmodifiable(
    _tasks.where(
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
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty || cleanTitle.length > 70) return false;
    _tasks.insert(
      0,
      StudyTask(id: _nextId++, title: cleanTitle, subject: subject),
    );
    _filter = TaskFilter.all;
    notifyListeners();
    return true;
  }

  void toggleTask(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    final task = _tasks[index];
    _tasks[index] = task.withDone(!task.done);
    notifyListeners();
  }
}
