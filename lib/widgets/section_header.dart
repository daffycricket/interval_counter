import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';

/// Widget d'en-tête de section avec titre et bouton d'action optionnel
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? actionButton;
  final String? semanticLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionButton,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre de la section
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.title,
              semanticsLabel: semanticLabel ?? title,
            ),
          ),
          
          // Bouton d'action optionnel
          if (actionButton != null) actionButton!,
        ],
      ),
    );
  }
}
