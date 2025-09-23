import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';

/// Widget de contrôle pour les durées (travail/repos)
class TimeControl extends StatelessWidget {
  final String label;
  final Duration value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String decrementSemanticLabel;
  final String incrementSemanticLabel;
  final String valueSemanticLabel;

  const TimeControl({
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
            
            // Valeur formatée
            SizedBox(
              width: 80,
              child: Text(
                _formatDuration(value),
                style: AppTextStyles.valueText,
                textAlign: TextAlign.center,
                semanticsLabel: '${_formatDurationForScreen(value)} $valueSemanticLabel',
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

  /// Formate une durée au format mm:ss
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes : $seconds';
  }

  /// Formate une durée pour les lecteurs d'écran
  String _formatDurationForScreen(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes == 0) {
      return '$seconds seconde${seconds > 1 ? 's' : ''}';
    } else if (seconds == 0) {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''} et $seconds seconde${seconds > 1 ? 's' : ''}';
    }
  }
}
