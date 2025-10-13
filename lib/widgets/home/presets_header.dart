import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/interval_timer_home_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Barre d'en-tête de la section préréglages
class PresetsHeader extends StatelessWidget {
  final VoidCallback onAdd;
  
  const PresetsHeader({
    super.key,
    required this.onAdd,
  });
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<IntervalTimerHomeState>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titre VOS PRÉRÉGLAGES
          Row(
            children: [
              Text(
                'VOS PRÉRÉGLAGES',
                key: const Key('interval_timer_home__Text-25'),
                style: AppTextStyles.title.copyWith(fontSize: 16),
              ),
              const SizedBox(width: 8),
              
              // Bouton éditer
              IconButton(
                key: const Key('interval_timer_home__IconButton-26'),
                icon: const Icon(Icons.edit, size: 20),
                color: AppColors.textSecondary,
                onPressed: () {
                  if (state.presetsEditMode) {
                    state.exitEditMode();
                  } else {
                    state.enterEditMode();
                  }
                },
                tooltip: 'Éditer les préréglages',
              ),
            ],
          ),
          
          // Bouton + AJOUTER
          OutlinedButton.icon(
            key: const Key('interval_timer_home__Button-27'),
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('+ AJOUTER'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyles.label,
              side: const BorderSide(color: AppColors.border, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 1,
            ),
          ),
        ],
      ),
    );
  }
}

