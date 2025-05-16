import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

import '../../shared/theme/app_colors.dart';

class AdvancedSlideToSwap extends StatefulWidget {
  final VoidCallback onSwapCompleted;

  const AdvancedSlideToSwap({Key? key, required this.onSwapCompleted})
      : super(key: key);

  @override
  State<AdvancedSlideToSwap> createState() => _AdvancedSlideToSwapState();
}

class _AdvancedSlideToSwapState extends State<AdvancedSlideToSwap>
    with SingleTickerProviderStateMixin {
  bool _isSwapping = false;
  double _dragPosition = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller);
  }

  void _startSwap() {
    setState(() {
      _isSwapping = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSwapping = false;
        _dragPosition = 0.0;
      });
      widget.onSwapCompleted();
      Navigator.of(context).pop();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(
        0.0,
        MediaQuery.of(context).size.width - 100,
      );
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragPosition > MediaQuery.of(context).size.width * 0.6) {
      _startSwap();
    } else {
      _controller.reset();
      setState(() {
        _dragPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          Container(
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
            alignment: Alignment.center,
            child: Text(
              _isSwapping ? "Swap processing..." : "Slide to Swap",
              style: TextStyle(
                color:
                    _isSwapping ? AppColors.textSecondary : AppColors.accentBlue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            left: _dragPosition,
            top: 0,
            bottom: 0,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderGlow, width: 2),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1139), Color(0xFF2A1A4A)],
                ),
              ),
              child: const Icon(
                Icons.double_arrow_rounded,
                color: AppColors.accentBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.panelBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Desliza para confirmar el contrato",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 20),
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
