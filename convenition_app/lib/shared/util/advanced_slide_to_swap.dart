import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';

class AdvancedSlideToSwap extends StatefulWidget {
  final Future<void> Function() onSwapCompleted;

  const AdvancedSlideToSwap({super.key, required this.onSwapCompleted});

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

  void _startSwap() async {
    setState(() => _isSwapping = true);

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isSwapping = false;
      _dragPosition = 0.0;
    });

    await widget.onSwapCompleted(); // ✅ Ejecutar lo que venga
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
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: colors.buttonSlideToSwap,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              _isSwapping ? "Procesando..." : "Desliza para confirmar",
              style: TextStyle(
                color: _isSwapping ? colors.textSecondary : colors.accentBlue,
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
                border: Border.all(color: colors.borderGlow, width: 2),
                gradient: colors.buttonSlideToSwap,
              ),
              child: Icon(Icons.double_arrow_rounded, color: colors.accentBlue),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showSwapModal(
  BuildContext context,
  Future<void> Function() onConfirmed,
) {
  final colors =
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.dark
          : AppColors.light;

  return showGeneralDialog(
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
              color: colors.panelBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Desliza para confirmar el contrato",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AdvancedSlideToSwap(
                    onSwapCompleted: () async {
                      Navigator.of(context).pop(); // ✅ cerrar modal
                      await onConfirmed(); // ✅ ejecutar lo que venga
                    },
                  ),
                ],
              ),
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
