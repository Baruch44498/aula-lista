final class Subject {
  const Subject(this.label);

  static const movil = Subject('Desarrollo móvil');
  static const redes = Subject('Redes');
  static const calidad = Subject('Calidad de software');
  static const values = [movil, redes, calidad];
  static const maxLabelLength = 40;

  final String label;

  @override
  bool operator ==(Object other) => other is Subject && other.label == label;

  @override
  int get hashCode => label.hashCode;
}

class StudyTask {
  const StudyTask({
    required this.id,
    required this.title,
    required this.subject,
    this.done = false,
  });

  final int id;
  final String title;
  final Subject subject;
  final bool done;

  StudyTask withDone(bool value) =>
      StudyTask(id: id, title: title, subject: subject, done: value);
}
