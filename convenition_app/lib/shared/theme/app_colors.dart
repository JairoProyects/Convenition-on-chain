import 'package:flutter/material.dart';

class AppColors {
  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textHighlight = Color(0xFFFFFFFF);

  // Íconos y acentos
  static const Color accentBlue = Color(0xFF7BBFD9);
  static const Color accentGreen = Color(0xFF26A17B);
  static const Color borderGlow = Color(0xFF4A3A6A);

  // Fondos
  static const LinearGradient backgroundMain = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1033), // superior
      Color(0xFF0D0522), // inferior
    ],
  );

  static const Color panelBackground = Color(0xFF13091E);
  static const Color modalBackground = Color(0xFF0F0518);

  // Botones
  static const Color buttonPrimary = Color(0xFF7BBFD9); // Botón "Got it"
  static const LinearGradient buttonSlideToSwap = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1139),
      Color(0xFF2A1A4A),
    ],
  );

  // Estados
  static const Color successText = Color(0xFFFFFFFF);
  static const LinearGradient processingIndicator = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A3A6A),
      Color(0xFF4A3A6A),
    ],
  );

  // Fondo de fallback (ej. splash o error)
  static const Color fallbackBackground = Color(0xFF1A1033);
}
