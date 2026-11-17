import 'package:flutter/material.dart';
import 'models/study_task.dart';
import 'viewmodels/study_view_model.dart';
import 'views/planner_page.dart';

void main() => runApp(const AulaListaApp());

class AulaListaApp extends StatefulWidget {
  const AulaListaApp({super.key});

  @override
  State<AulaListaApp> createState() => _AulaListaAppState();
}

class _AulaListaAppState extends State<AulaListaApp> {
  final _viewModel = StudyViewModel(
    initial: const [
      StudyTask(
        id: 1,
        title: 'Preparar la demo de Flutter',
        subject: Subject.movil,
      ),
      StudyTask(
        id: 2,
        title: 'Repasar VLAN e inter-VLAN',
        subject: Subject.redes,
      ),
      StudyTask(
        id: 3,
        title: 'Diseñar casos de prueba',
        subject: Subject.calidad,
        done: true,
      ),
    ],
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Aula Lista',
    theme: _buildTheme(),
    home: PlannerPage(viewModel: _viewModel),
  );
}

ThemeData _buildTheme() {
  final colors = ColorScheme.fromSeed(
    seedColor: const Color(0xFF304DBA),
  ).copyWith(
    primary: const Color(0xFF16234E),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFFE8EDFF),
    onPrimaryContainer: const Color(0xFF16234E),
    secondary: const Color(0xFF304DBA),
    onSecondary: const Color(0xFFFFFFFF),
    tertiary: const Color(0xFF28654E),
    tertiaryContainer: const Color(0xFFB4FFD8),
    onTertiaryContainer: const Color(0xFF153D2D),
    surface: const Color(0xFFFFFFFF),
    surfaceContainerLowest: const Color(0xFFFFFFFF),
    surfaceContainerLow: const Color(0xFFF1F4FB),
    surfaceContainer: const Color(0xFFEBEFF8),
    onSurface: const Color(0xFF16234E),
    onSurfaceVariant: const Color(0xFF59647E),
    outline: const Color(0xFF7D88A2),
    outlineVariant: const Color(0xFFDDE3F0),
    inverseSurface: const Color(0xFF16234E),
    onInverseSurface: const Color(0xFFFFFFFF),
  );
  final base = ThemeData(useMaterial3: true, colorScheme: colors);
  final rounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  return base.copyWith(
    scaffoldBackgroundColor: colors.surfaceContainerLow,
    textTheme: base.textTheme
        .copyWith(
          headlineLarge: base.textTheme.headlineLarge?.copyWith(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.4,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.45),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.45),
        )
        .apply(bodyColor: colors.onSurface, displayColor: colors.onSurface),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      surfaceTintColor: colors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      titleSpacing: 20,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        shape: rounded,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        shape: rounded,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colors.surfaceContainerLow,
      selectedColor: colors.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      labelStyle: TextStyle(
        color: colors.onSurfaceVariant,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      side: BorderSide(color: colors.outline, width: 1.5),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.secondary, width: 2),
      ),
      errorMaxLines: 2,
    ),
  );
}
