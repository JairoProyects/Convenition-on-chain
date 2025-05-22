import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './convenion/presentation/login/login_page.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_text_styles.dart';
import 'shared/theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(AppColorScheme colors, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      textTheme: _buildTextTheme(colors),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accentBlue,
        onPrimary: colors.textPrimary,
        secondary: colors.accentGreen,
        onSecondary: colors.textHighlight,
        surface: colors.panelBackground,
        onSurface: colors.textPrimary,
        error: Colors.red,
        onError: Colors.white,
      ),
    );
  }

  TextTheme _buildTextTheme(AppColorScheme colors) {
    return TextTheme(
      displayLarge: AppTextStyles.heading1(colors),
      displayMedium: AppTextStyles.heading2(colors),
      titleMedium: AppTextStyles.subtitle(colors),
      bodyLarge: AppTextStyles.body(colors),
      bodyMedium: AppTextStyles.bodyMuted(colors),
      bodySmall: AppTextStyles.caption(colors),
      labelLarge: AppTextStyles.button(colors),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Convenio On-Chain',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: _buildTheme(AppColors.light, Brightness.light),
      darkTheme: _buildTheme(AppColors.dark, Brightness.dark),
      home: const LoginPage(),
    );
  }
}
