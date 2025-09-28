import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

/// Widget de contrôle de valeur avec boutons +/-
class ValueControl extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final String decrementAriaLabel;
  final String incrementAriaLabel;

  const ValueControl({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    required this.decrementAriaLabel,
    required this.incrementAriaLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          AppTextStyles.applyTransform(label, 'uppercase'),
          style: AppTextStyles.label,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        
        // Contrôles
        Row(
          children: [
            // Bouton décrément
            _buildControlButton(
              icon: Icons.remove,
              onPressed: onDecrement,
              ariaLabel: decrementAriaLabel,
            ),
            
            // Valeur centrée
            Expanded(
              child: Center(
                child: Text(
                  value,
                  style: AppTextStyles.value,
                ),
              ),
            ),
            
            // Bouton incrément
            _buildControlButton(
              icon: Icons.add,
              onPressed: onIncrement,
              ariaLabel: incrementAriaLabel,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String ariaLabel,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        splashRadius: 18,
        tooltip: ariaLabel,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
