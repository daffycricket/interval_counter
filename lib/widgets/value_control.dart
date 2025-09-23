import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';

/// Widget de contrôle pour les valeurs numériques (répétitions)
class ValueControl extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String decrementSemanticLabel;
  final String incrementSemanticLabel;
  final String valueSemanticLabel;

  const ValueControl({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.decrementSemanticLabel,
    required this.incrementSemanticLabel,
    required this.valueSemanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label du contrôle
        Text(
          label,
          style: AppTextStyles.label,
        ),
        const SizedBox(height: AppTheme.spacingMd),
        
        // Ligne de contrôle avec boutons et valeur
        Row(
          children: [
            // Espacement depuis le bord gauche (align avec label)
            const SizedBox(width: AppTheme.spacingLg),
            
            // Bouton diminuer
            IconButton(
              key: Key('${label.toLowerCase()}_minus_btn'),
              onPressed: onDecrement,
              icon: const Icon(Icons.remove),
              tooltip: decrementSemanticLabel,
            ),
            
            // Espacement
            const SizedBox(width: AppTheme.spacingLg),
            
            // Valeur
            SizedBox(
              width: 40,
              child: Text(
                value.toString(),
                style: AppTextStyles.valueText,
                textAlign: TextAlign.center,
                semanticsLabel: '$value $valueSemanticLabel',
              ),
            ),
            
            // Espacement
            const SizedBox(width: AppTheme.spacingLg),
            
            // Bouton augmenter
            IconButton(
              key: Key('${label.toLowerCase()}_plus_btn'),
              onPressed: onIncrement,
              icon: const Icon(Icons.add),
              tooltip: incrementSemanticLabel,
            ),
          ],
        ),
      ],
    );
  }
}
