import 'package:flutter/material.dart';

class AppColorScheme {
  final Color textPrimary;
  final Color textSecondary;
  final Color textHighlight;

  final Color accentBlue;
  final Color accentGreen;
  final Color borderGlow;

  final LinearGradient backgroundMain;
  final Color panelBackground;
  final Color modalBackground;

  final Color buttonPrimary;
  final LinearGradient buttonSlideToSwap;

  final Color successText;
  final LinearGradient processingIndicator;

  final Color fallbackBackground;

  const AppColorScheme({
    required this.textPrimary,
    required this.textSecondary,
    required this.textHighlight,
    required this.accentBlue,
    required this.accentGreen,
    required this.borderGlow,
    required this.backgroundMain,
    required this.panelBackground,
    required this.modalBackground,
    required this.buttonPrimary,
    required this.buttonSlideToSwap,
    required this.successText,
    required this.processingIndicator,
    required this.fallbackBackground,
  });
}

class AppColors {
  // 🌙 Modo Oscuro (basado en la imagen del botón oscuro)
  static const AppColorScheme dark = AppColorScheme(
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF8A8A8A),
    textHighlight: Color(0xFF13091E),
    accentBlue: Color(0xFF7BBFD9),
    accentGreen: Color(0xFF26A17B),
    borderGlow: Color(0xFF4A3A6A),
    backgroundMain: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A1033), Color(0xFF0D0522)],
    ),
    panelBackground: Color(0xFF13091E),
    modalBackground: Color(0xFF0F0518),
    buttonPrimary: Color(0xFF00D4FF), // Cyan brillante del botón oscuro
    buttonSlideToSwap: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A0B2E), Color(0xFF16213E)], // Gradiente oscuro azulado
    ),
    successText: Color(0xFFFFFFFF),
    processingIndicator: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A3A6A), Color(0xFF4A3A6A)],
    ),
    fallbackBackground: Color(0xFF1A1033),
  );

  // ☀️ Modo Claro (basado en la imagen del botón claro)
  static const AppColorScheme light = AppColorScheme(
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF666666),
    textHighlight: Color(0xFF000000),
    accentBlue: Color(0xFF2196F3),
    accentGreen: Color(0xFF4CAF50),
    borderGlow: Color(0xFFBDBDBD),
    backgroundMain: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
    ),
    panelBackground: Color(0xFFF5F5F5),
    modalBackground: Color(0xFFFFFFFF),
    buttonPrimary: Color(0xFF0BC5EA), // Azul vibrante del botón claro
    buttonSlideToSwap: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0F172A), Color(0xFF1E293B)], // Gradiente slate oscuro
    ),
    successText: Color(0xFF000000),
    processingIndicator: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFCCCCCC), Color(0xFFAAAAAA)],
    ),
    fallbackBackground: Color(0xFFFFFFFF),
  );
}