import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

import '../../shared/theme/app_colors.dart';

class AdvancedSlideToSwap extends StatefulWidget {
  final VoidCallback onSwapCompleted;

  const AdvancedSlideToSwap({Key? key, required this.onSwapCompleted}) : super(key: key);

  @override
  State<AdvancedSlideToSwap> createState() => _AdvancedSlideToSwapState();
}

class _AdvancedSlideToSwapState extends State<AdvancedSlideToSwap> {
  bool _isSwapping = false;

  void _startSwap() {
    setState(() {
      _isSwapping = true;
    });

    // Simular procesamiento de swap
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSwapping = false;
      });
      widget.onSwapCompleted();
      Navigator.of(context).pop(); // Cierra el modal automáticamente después del swap
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (!_isSwapping) _startSwap();
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1139), Color(0xFF2A1A4A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderGlow, width: 2),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1139), Color(0xFF2A1A4A)],
                ),
              ),
              child: const Icon(Icons.person, color: AppColors.accentBlue, size: 20),
            ),
            Expanded(
              child: Center(
                child: Text(
                  _isSwapping ? "Swap processing..." : "Slide to Swap",
                  style: TextStyle(
                    color: _isSwapping ? AppColors.textSecondary : AppColors.accentBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Icon(Icons.double_arrow_rounded, color: AppColors.accentBlue),
          ],
        ),
      ),
    );
  }
}

// Esta función debe moverse a notifications.dart
void showSwapModal(BuildContext context, VoidCallback onConfirmed) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "SwapModal",
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.panelBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Desliza para confirmar el contrato",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                AdvancedSlideToSwap(onSwapCompleted: onConfirmed),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}
