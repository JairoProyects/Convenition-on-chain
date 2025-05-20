import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle heading1(AppColorScheme colors) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      );

  static TextStyle heading2(AppColorScheme colors) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      );

  static TextStyle subtitle(AppColorScheme colors) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
      );

  static TextStyle body(AppColorScheme colors) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colors.textPrimary,
      );

  static TextStyle bodyMuted(AppColorScheme colors) => TextStyle(
        fontSize: 14,
        color: colors.textSecondary,
      );

  static TextStyle caption(AppColorScheme colors) => TextStyle(
        fontSize: 12,
        color: colors.textSecondary,
      );

  static TextStyle emphasis(AppColorScheme colors) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.textHighlight,
      );

  static TextStyle button(AppColorScheme colors) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      );
}
