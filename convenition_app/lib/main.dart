import 'package:flutter/material.dart';
import 'home/bottom_navigation_bar.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convenio On-Chain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.heading1,
          displayMedium: AppTextStyles.heading2,
          titleMedium: AppTextStyles.subtitle,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.bodyMuted,
          bodySmall: AppTextStyles.caption,
          labelLarge: AppTextStyles.button,
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: AppColors.accentBlue,
          onPrimary: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
        ),
      ),
      home: const MenuTopTabsPage(),
    );
  }
}
