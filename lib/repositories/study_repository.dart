import 'package:flutter/foundation.dart';

import '../models/study_task.dart';

class StudyRepository extends ChangeNotifier {
  StudyRepository({Iterable<StudyTask> initial = const []})
    : _tasks = List.of(initial) {
    for (final task in _tasks) {
      if (task.id >= _nextId) _nextId = task.id + 1;
    }
  }

  final List<StudyTask> _tasks;
  int _nextId = 1;

  List<StudyTask> get tasks => List.unmodifiable(_tasks);

  bool addTask(String title, Subject subject) {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty || cleanTitle.length > 70) return false;
    _tasks.insert(
      0,
      StudyTask(id: _nextId++, title: cleanTitle, subject: subject),
    );
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
