import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/interval_timer_home_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// En-tête de la section Démarrage rapide avec titre et bouton toggle
class QuickStartHeader extends StatelessWidget {
  const QuickStartHeader({super.key});
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<IntervalTimerHomeState>();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Titre "Démarrage rapide"
        Text(
          'Démarrage rapide',
          key: const Key('interval_timer_home__Text-8'),
          style: AppTextStyles.titleLarge,
        ),
        
        // Bouton toggle expand/collapse
        IconButton(
          key: const Key('interval_timer_home__IconButton-9'),
          icon: Icon(
            state.quickStartExpanded
                ? Icons.expand_less
                : Icons.expand_more,
          ),
          color: AppColors.textSecondary,
          onPressed: state.toggleQuickStartSection,
          tooltip: state.quickStartExpanded
              ? 'Replier la section Démarrage rapide'
              : 'Déplier la section Démarrage rapide',
        ),
      ],
    );
  }
}

