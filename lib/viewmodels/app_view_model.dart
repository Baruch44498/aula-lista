import 'package:flutter/foundation.dart';

enum AppSection { home, tasks, settings }

class AppViewModel extends ChangeNotifier {
  AppSection _section = AppSection.home;
  AppSection get section => _section;

  void selectSection(AppSection value) {
    if (value == _section) return;
    _section = value;
    notifyListeners();
  }
}
