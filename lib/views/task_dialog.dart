import 'package:flutter/material.dart';
import '../models/study_task.dart';

class TaskDialog extends StatefulWidget {
  const TaskDialog({super.key, required this.onAdd});
  final bool Function(String title, Subject subject) onAdd;

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _title = TextEditingController();
  Subject _subject = Subject.movil;
  bool _invalidTitle = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _save() {
    if (widget.onAdd(_title.text, _subject)) {
      Navigator.of(context).pop();
    } else {
      setState(() => _invalidTitle = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return AlertDialog(
      backgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      scrollable: true,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.edit_note_rounded, color: colors.secondary),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text('Nueva tarea', style: theme.textTheme.titleLarge),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              autofocus: true,
              maxLength: 70,
              onChanged: (_) {
                if (_invalidTitle) setState(() => _invalidTitle = false);
              },
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: 'Nombre de la tarea',
                hintText: 'Ej. Ensayar la exposición',

                errorText:
                    _invalidTitle
                        ? 'Ingresa un nombre de 1 a 70 caracteres.'
                        : null,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Subject>(
              value: _subject,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Curso'),
              items: [
                for (final subject in Subject.values)
                  DropdownMenuItem(value: subject, child: Text(subject.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _subject = value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Guardar')),
      ],
    );
  }
}
