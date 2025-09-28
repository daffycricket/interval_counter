import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';

/// Widget d'en-tête de section avec titre et actions optionnelles
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailingAction;
  final Widget? leadingAction;
  final bool uppercase;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailingAction,
    this.leadingAction,
    this.uppercase = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Action de début (optionnelle)
        if (leadingAction != null) ...[
          leadingAction!,
          const SizedBox(width: 8),
        ],
        
        // Titre
        Expanded(
          child: Text(
            uppercase ? title.toUpperCase() : title,
            style: uppercase ? AppTextStyles.title : AppTextStyles.titleLarge,
          ),
        ),
        
        // Action de fin (optionnelle)
        if (trailingAction != null) ...[
          const SizedBox(width: 8),
          trailingAction!,
        ],
      ],
    );
  }
}

/// Widget d'en-tête de section avec bouton de repli/dépli
class CollapsibleSectionHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String toggleAriaLabel;

  const CollapsibleSectionHeader({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.toggleAriaLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: title,
      trailingAction: IconButton(
        onPressed: onToggle,
        icon: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: AppColors.textSecondary,
        ),
        tooltip: toggleAriaLabel,
        splashRadius: 12,
      ),
    );
  }
}
