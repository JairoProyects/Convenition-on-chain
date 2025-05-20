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
  // 🌙 Modo Oscuro
  static const AppColorScheme dark = AppColorScheme(
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF8A8A8A),
    textHighlight: Color(0xFFFFFFFF),
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
    buttonPrimary: Color(0xFF7BBFD9),
    buttonSlideToSwap: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E1139), Color(0xFF2A1A4A)],
    ),
    successText: Color(0xFFFFFFFF),
    processingIndicator: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A3A6A), Color(0xFF4A3A6A)],
    ),
    fallbackBackground: Color(0xFF1A1033),
  );

  // ☀️ Modo Claro
  static final AppColorScheme light = AppColorScheme(
    textPrimary: Colors.black,
    textSecondary: Colors.grey.shade600,
    textHighlight: Colors.black,
    accentBlue: Colors.blue,
    accentGreen: Colors.green.shade600,
    borderGlow: Colors.grey.shade400,
    backgroundMain: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.white],
    ),
    panelBackground: Colors.grey.shade100,
    modalBackground: Colors.white,
    buttonPrimary: Colors.blue,
    buttonSlideToSwap: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE3E3E3), Color(0xFFD5D5D5)],
    ),
    successText: Colors.black,
    processingIndicator: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFCCCCCC), Color(0xFFAAAAAA)],
    ),
    fallbackBackground: Colors.white,
  );
}
