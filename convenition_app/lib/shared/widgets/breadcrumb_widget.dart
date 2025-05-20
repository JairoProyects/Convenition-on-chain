import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BreadcrumbWidget extends StatelessWidget {
  final List<String> items;
  final void Function(int index)? onTap;
  final AppColorScheme colors;

  const BreadcrumbWidget({
    super.key,
    required this.items,
    required this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length * 2 - 1, (index) {
        if (index.isEven) {
          final itemIndex = index ~/ 2;
          final isLast = itemIndex == items.length - 1;
          final label = items[itemIndex];

          if (isLast || onTap == null) {
            return Text(label, style: AppTextStyles.caption(colors));
          } else {
            return GestureDetector(
              onTap: () => onTap!(itemIndex),
              child: Text(
                label,
                style: AppTextStyles.caption(colors).copyWith(
                  color: colors.accentBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          }
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.chevron_right, size: 14, color: colors.textSecondary),
          );
        }
      }),
    );
  }
}
