import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Bouton de basculement de mode (SIMPLE/ADVANCED)
class ModeToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final String semanticLabel;
  final Key? buttonKey;

  const ModeToggleButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.semanticLabel,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          key: buttonKey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: Text(
            text,
            style: AppTextStyles.label.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.textActive : AppColors.textInactive,
            ),
          ),
        ),
      ),
    );
  }
}
