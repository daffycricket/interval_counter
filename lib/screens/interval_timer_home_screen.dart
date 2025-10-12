import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/presets_state.dart';
import '../widgets/home/volume_header.dart';
import '../widgets/home/quick_start_card.dart';
import '../widgets/home/preset_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Écran principal - Interval Timer Home
class IntervalTimerHomeScreen extends StatelessWidget {
  const IntervalTimerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presetsState = context.watch<PresetsState>();
    final presets = presetsState.presets;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec contrôle volume
              const VolumeHeader(),
              const SizedBox(height: 8),

              // Carte démarrage rapide
              const QuickStartCard(),
              const SizedBox(height: 8),

              // En-tête section préréglages
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Titre et bouton éditer
                    Row(
                      children: [
                        Text(
                          'VOS PRÉRÉGLAGES',
                          key: const Key('interval_timer_home__text_25'),
                          style: AppTextStyles.title.copyWith(fontSize: 16),
                        ),
                        IconButton(
                          key: const Key('interval_timer_home__icon_button_26'),
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            presetsState.enterEditMode();
                            // TODO: Implémenter mode édition
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mode édition (à implémenter)'),
                              ),
                            );
                          },
                          tooltip: 'Éditer les préréglages',
                        ),
                      ],
                    ),

                    // Bouton ajouter
                    OutlinedButton.icon(
                      key: const Key('interval_timer_home__button_27'),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('AJOUTER'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        textStyle: AppTextStyles.label,
                      ),
                      onPressed: () {
                        // Navigation vers éditeur de préréglages
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Éditeur de préréglages (à implémenter)'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Liste des préréglages ou état vide
              if (presets.isEmpty)
                _buildEmptyState()
              else
                ...presets.map((preset) => PresetCard(preset: preset)),

              // Espacement final
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun préréglage',
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Créez-en un avec + AJOUTER',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

