import 'package:material_ui/material_ui.dart';

import '../viewmodels/app_view_model.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/settings_view_model.dart';
import '../viewmodels/study_view_model.dart';
import 'home_page.dart';
import 'planner_page.dart';
import 'settings_page.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.appViewModel,
    required this.studyViewModel,
    required this.homeViewModel,
    required this.settingsViewModel,
  });

  final AppViewModel appViewModel;
  final StudyViewModel studyViewModel;
  final HomeViewModel homeViewModel;
  final SettingsViewModel settingsViewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListenableBuilder(
      listenable: appViewModel,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          final page = switch (appViewModel.section) {
            AppSection.home => HomePage(
              viewModel: homeViewModel,
              onOpenTasks: () => appViewModel.selectSection(AppSection.tasks),
              onOpenSettings: () =>
                  appViewModel.selectSection(AppSection.settings),
            ),
            AppSection.tasks => PlannerPage(viewModel: studyViewModel),
            AppSection.settings => SettingsPage(viewModel: settingsViewModel),
          };
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
                    child: Icon(Icons.school_rounded, color: colors.onPrimary),
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
                child: Divider(height: 1, color: colors.outlineVariant),
              ),
            ),
            body: SafeArea(
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        NavigationRail(
                          selectedIndex: appViewModel.section.index,
                          onDestinationSelected: (index) => appViewModel
                              .selectSection(AppSection.values[index]),
                          labelType: NavigationRailLabelType.all,
                          backgroundColor: colors.surface,
                          groupAlignment: -1,
                          destinations: const [
                            NavigationRailDestination(
                              icon: Icon(Icons.space_dashboard_outlined),
                              selectedIcon: Icon(Icons.space_dashboard_rounded),
                              label: Text('Inicio'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.checklist_rounded),
                              label: Text('Tareas'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.tune_rounded),
                              label: Text('Ajustes'),
                            ),
                          ],
                        ),
                        VerticalDivider(width: 1, color: colors.outlineVariant),
                        Expanded(child: page),
                      ],
                    )
                  : page,
            ),
            bottomNavigationBar: wide
                ? null
                : NavigationBar(
                    selectedIndex: appViewModel.section.index,
                    onDestinationSelected: (index) =>
                        appViewModel.selectSection(AppSection.values[index]),
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.space_dashboard_outlined),
                        selectedIcon: Icon(Icons.space_dashboard_rounded),
                        label: 'Inicio',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.checklist_rounded),
                        label: 'Tareas',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.tune_rounded),
                        label: 'Ajustes',
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
