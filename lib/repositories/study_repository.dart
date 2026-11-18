import 'package:flutter/foundation.dart';

import '../models/study_task.dart';

class StudyRepository extends ChangeNotifier {
  StudyRepository({Iterable<StudyTask> initial = const []})
    : _tasks = List.of(initial) {
    for (final task in _tasks) {
      if (task.id >= _nextId) _nextId = task.id + 1;
      if (!_subjects.contains(task.subject)) _subjects.add(task.subject);
    }
  }

  final List<StudyTask> _tasks;
  final List<Subject> _subjects = [...Subject.values];
  int _nextId = 1;

  List<StudyTask> get tasks => List.unmodifiable(_tasks);
  List<Subject> get subjects => List.unmodifiable(_subjects);

  Subject? addSubject(String label) {
    final cleanLabel = label.trim();
    if (cleanLabel.isEmpty || cleanLabel.length > Subject.maxLabelLength) {
      return null;
    }
    final normalized = cleanLabel.toLowerCase();
    if (_subjects.any((subject) => subject.label.toLowerCase() == normalized)) {
      return null;
    }
    final subject = Subject(cleanLabel);
    _subjects.add(subject);
    notifyListeners();
    return subject;
  }

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
