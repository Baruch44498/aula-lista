import 'package:flutter/foundation.dart';

import '../models/study_task.dart';

class TaskFormViewModel extends ChangeNotifier {
  TaskFormViewModel({required bool Function(String, Subject) onAdd})
    : _onAdd = onAdd;

  final bool Function(String, Subject) _onAdd;
  String _title = '';
  Subject _subject = Subject.movil;
  bool _invalidTitle = false;

  Subject get subject => _subject;
  String? get errorText =>
      _invalidTitle ? 'Ingresa un nombre de 1 a 70 caracteres.' : null;

  void setTitle(String value) {
    _title = value;
    if (!_invalidTitle) return;
    _invalidTitle = false;
    notifyListeners();
  }

  void setSubject(Subject value) {
    if (value == _subject) return;
    _subject = value;
    notifyListeners();
  }

  bool submit() {
    final added = _onAdd(_title, _subject);
    _invalidTitle = !added;
    notifyListeners();
    return added;
  }
}
