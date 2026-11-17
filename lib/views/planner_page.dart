import 'package:flutter/material.dart';
import '../viewmodels/study_view_model.dart';
import 'task_dialog.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key, required this.viewModel});
  final StudyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.school_rounded,
                color: colors.tertiaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Aula Lista',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colors.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder:
              (context, _) => LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 840;
                  final summary = _ProgressCard(
                    completed: viewModel.completed,
                    total: viewModel.total,
                    progress: viewModel.progress,
                    compact: !wide,
                  );
                  final list = _TaskPanel(viewModel: viewModel);
                  return SingleChildScrollView(
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
                                      style: theme.textTheme.headlineLarge
                                          ?.copyWith(fontSize: wide ? 40 : 34),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Organiza tus tareas académicas',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                                FilledButton.icon(
                                  onPressed:
                                      () => showDialog<void>(
                                        context: context,
                                        builder:
                                            (_) => TaskDialog(
                                              onAdd: viewModel.addTask,
                                            ),
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
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
    required this.compact,
  });
  final int completed;
  final int total;
  final double progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.16),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: colors.onPrimary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso de estudio',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                color: colors.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Flex(
              direction: compact ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment:
                  compact
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                Text(
                  '$percent%',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: compact ? 52 : 66,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                    height: 1.05,
                    color: colors.onPrimary,
                  ),
                ),
                SizedBox(width: compact ? 24 : 0, height: compact ? 0 : 12),
                Flexible(
                  fit: FlexFit.loose,
                  flex: compact ? 1 : 0,
                  child: Text(
                    '$completed de $total tareas completadas',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                semanticsLabel: 'Progreso de estudio',
                semanticsValue: '$percent%',
                minHeight: 10,
                color: colors.tertiaryContainer,
                backgroundColor: colors.onPrimary.withValues(alpha: 0.18),
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 24),
              Divider(
                height: 1,
                color: colors.onPrimary.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 28,
                runSpacing: 16,
                children: [
                  _ProgressCount(
                    value: total - completed,
                    label: 'Por completar',
                  ),
                  _ProgressCount(value: completed, label: 'Finalizadas'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressCount extends StatelessWidget {
  const _ProgressCount({required this.value, required this.label});
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$value',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
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
                      color:
                          viewModel.filter == filter
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
                    color:
                        task.done
                            ? colors.tertiaryContainer.withValues(alpha: 0.13)
                            : colors.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color:
                            task.done
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
                          color:
                              task.done
                                  ? colors.onSurfaceVariant
                                  : colors.onSurface,
                          decoration:
                              task.done ? TextDecoration.lineThrough : null,
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
