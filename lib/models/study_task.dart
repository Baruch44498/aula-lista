enum Subject {
  movil('Desarrollo móvil'),
  redes('Redes'),
  calidad('Calidad de software');

  const Subject(this.label);
  final String label;
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
