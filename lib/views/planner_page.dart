import 'package:material_ui/material_ui.dart';

import '../viewmodels/study_view_model.dart';
import 'task_dialog.dart';
import 'widgets/study_progress_card.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key, required this.viewModel});
  final StudyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          final summary = StudyProgressCard(
            completed: viewModel.completed,
            total: viewModel.total,
            progress: viewModel.progress,
            compact: !wide,
          );
          final list = _TaskPanel(viewModel: viewModel);
          return SingleChildScrollView(
            key: const PageStorageKey('tasks-scroll'),
            padding: EdgeInsets.fromLTRB(
              wide ? 40 : 20,
              wide ? 40 : 24,
              wide ? 40 : 20,
              32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 24,
                      runSpacing: 20,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mi agenda',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontSize: wide ? 40 : 34,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Organiza tus tareas académicas',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        FilledButton.icon(
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) =>
                                TaskDialog(onAdd: viewModel.addTask),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 22),
                          label: const Text('Nueva tarea'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: summary),
                          const SizedBox(width: 24),
                          Expanded(flex: 7, child: list),
                        ],
                      )
                    else ...[
                      summary,
                      const SizedBox(height: 24),
                      list,
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TaskPanel extends StatelessWidget {
  const _TaskPanel({required this.viewModel});
  final StudyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final tasks = viewModel.visibleTasks;
    return Card(
      color: colors.surface,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mis tareas', style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: [
                for (final filter in TaskFilter.values)
                  ChoiceChip(
                    label: Text(filter.label),
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 12.5,
                      letterSpacing: 0.1,
                      color: viewModel.filter == filter
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    showCheckmark: false,
                    selected: viewModel.filter == filter,
                    onSelected: (_) => viewModel.setFilter(filter),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (tasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.task_alt_rounded,
                      size: 36,
                      color: colors.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay tareas para este filtro.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              for (final task in tasks)
                Padding(
                  key: ValueKey(task.id),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: task.done
                        ? colors.tertiaryContainer.withValues(alpha: 0.13)
                        : colors.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: task.done
                            ? colors.tertiary.withValues(alpha: 0.15)
                            : colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: colors.tertiary,
                      value: task.done,
                      onChanged: (_) => viewModel.toggleTask(task.id),
                      title: Text(
                        task.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: task.done
                              ? colors.onSurfaceVariant
                              : colors.onSurface,
                          decoration: task.done
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: colors.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          task.subject.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
