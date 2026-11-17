class StudyPreferences {
  const StudyPreferences({this.darkMode = false, this.taskGoal = 3});

  static const minGoal = 1;
  static const maxGoal = 10;

  final bool darkMode;
  final int taskGoal;

  StudyPreferences copyWith({bool? darkMode, int? taskGoal}) =>
      StudyPreferences(
        darkMode: darkMode ?? this.darkMode,
        taskGoal: taskGoal ?? this.taskGoal,
      );
}
