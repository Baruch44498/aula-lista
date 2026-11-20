import 'package:material_ui/material_ui.dart';

import '../viewmodels/home_view_model.dart';
import 'widgets/study_progress_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.viewModel,
    required this.onOpenTasks,
    required this.onOpenSettings,
  });

  final HomeViewModel viewModel;
  final VoidCallback onOpenTasks;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          final progress = StudyProgressCard(
            completed: viewModel.completed,
            total: viewModel.total,
            progress: viewModel.progress,
            compact: !wide,
          );
          final overview = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _GoalCard(viewModel: viewModel, onOpenSettings: onOpenSettings),
              const SizedBox(height: 24),
              _NextTasks(viewModel: viewModel),
            ],
          );
          return SingleChildScrollView(
            key: const PageStorageKey('home-scroll'),
            padding: EdgeInsets.all(wide ? 40 : 20),
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
                        Text(
                          'Tu espacio de estudio',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: wide ? 38 : 30,
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: onOpenTasks,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Ver tareas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: progress),
                          const SizedBox(width: 24),
                          Expanded(flex: 7, child: overview),
                        ],
                      )
                    else ...[
                      progress,
                      const SizedBox(height: 24),
                      overview,
                    ],
                    const SizedBox(height: 20),
                    Text(
                      '${viewModel.pending} tareas pendientes de ${viewModel.total} registradas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
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

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.viewModel, required this.onOpenSettings});
  final HomeViewModel viewModel;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meta de estudio', style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            Text(
              '${viewModel.completed} / ${viewModel.taskGoal}',
              key: const Key('home-goal-count'),
              style: theme.textTheme.headlineLarge?.copyWith(
                color: colors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: viewModel.goalProgress,
                minHeight: 8,
                semanticsLabel:
                    'Progreso de la meta, ${viewModel.completed} de ${viewModel.taskGoal} tareas',
                semanticsValue: '${(viewModel.goalProgress * 100).round()}%',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                Text(
                  viewModel.remainingForGoal == 0
                      ? 'Meta alcanzada'
                      : 'Te faltan ${viewModel.remainingForGoal} para tu meta',
                  style: theme.textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: onOpenSettings,
                  child: const Text('Ajustar meta'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NextTasks extends StatelessWidget {
  const _NextTasks({required this.viewModel});
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Próximas tareas', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            if (viewModel.nextTasks.isEmpty)
              Text(
                'Has completado todas tus tareas.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              )
            else
              for (final task in viewModel.nextTasks)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.menu_book_outlined,
                    color: colors.secondary,
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.subject.label),
                ),
          ],
        ),
      ),
    );
  }
}
