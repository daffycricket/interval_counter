import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Bouton "+" pour ajouter un nouveau groupe, avec TOTAL à droite.
class AddGroupButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String formattedTotal;
  final String semanticLabel;

  const AddGroupButton({
    super.key,
    this.onTap,
    required this.formattedTotal,
    this.semanticLabel = 'Add a new group',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.addButtonBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.addButtonFg,
                  size: 24,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            formattedTotal,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.advancedTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
