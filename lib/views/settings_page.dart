import 'package:material_ui/material_ui.dart';

import '../viewmodels/settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.viewModel});
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => SingleChildScrollView(
        key: const PageStorageKey('settings-scroll'),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ajustes de estudio',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 28),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: colors.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: Icon(
                        Icons.dark_mode_outlined,
                        color: colors.secondary,
                      ),
                      title: const Text('Modo oscuro'),
                      value: viewModel.darkMode,
                      onChanged: viewModel.setDarkMode,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
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
                        Text(
                          'Meta de estudio',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${viewModel.taskGoal} tareas completadas',
                          key: const Key('settings-goal-count'),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Slider(
                          key: const Key('task-goal-slider'),
                          value: viewModel.taskGoal.toDouble(),
                          min: viewModel.minGoal.toDouble(),
                          max: viewModel.maxGoal.toDouble(),
                          divisions: viewModel.maxGoal - viewModel.minGoal,
                          label: '${viewModel.taskGoal}',
                          semanticFormatterCallback: (value) =>
                              '${value.round()} tareas',
                          onChanged: viewModel.setTaskGoal,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Elige cuántas tareas quieres completar.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Las tareas y preferencias se conservan durante esta sesión.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
