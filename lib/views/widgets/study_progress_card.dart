import 'package:material_ui/material_ui.dart';

class StudyProgressCard extends StatelessWidget {
  const StudyProgressCard({
    super.key,
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
              crossAxisAlignment: compact
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
