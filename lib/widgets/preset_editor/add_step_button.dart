import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Bouton "+" pour ajouter une étape au groupe, avec le sous-total à droite.
class AddStepButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String subtotal;
  final String semanticLabel;

  const AddStepButton({
    super.key,
    this.onTap,
    required this.subtotal,
    this.semanticLabel = 'Add step to group',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Semantics(
            label: semanticLabel,
            button: true,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.addButtonBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.addButtonFg,
                  size: 20,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            subtotal,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.advancedTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
