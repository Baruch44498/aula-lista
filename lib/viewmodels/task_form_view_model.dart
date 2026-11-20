import 'package:flutter/foundation.dart';

import '../models/study_task.dart';
import 'study_view_model.dart';

class TaskFormViewModel extends ChangeNotifier {
  TaskFormViewModel({required StudyViewModel studyViewModel})
    : _studyViewModel = studyViewModel;

  final StudyViewModel _studyViewModel;
  String _title = '';
  Subject _subject = Subject.movil;
  bool _invalidTitle = false;
  String _subjectDraft = '';
  String? _subjectError;

  List<Subject> get subjects => _studyViewModel.subjects;
  Subject get subject => _subject;
  String? get subjectError => _subjectError;
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

  void beginSubject() {
    _subjectDraft = '';
    _subjectError = null;
  }

  void setSubjectDraft(String value) {
    _subjectDraft = value;
    if (_subjectError == null) return;
    _subjectError = null;
    notifyListeners();
  }

  bool submitSubject() {
    final label = _subjectDraft.trim();
    if (label.isEmpty || label.length > Subject.maxLabelLength) {
      _subjectError =
          'Ingresa un nombre de 1 a ${Subject.maxLabelLength} caracteres.';
      notifyListeners();
      return false;
    }
    final added = _studyViewModel.addSubject(label);
    if (added == null) {
      _subjectError = 'Ya existe un curso con ese nombre.';
      notifyListeners();
      return false;
    }
    setSubject(added);
    return true;
  }

  bool submit() {
    final added = _studyViewModel.addTask(_title, _subject);
    _invalidTitle = !added;
    notifyListeners();
    return added;
  }
}
