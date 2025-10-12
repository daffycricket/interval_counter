import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/interval_timer_home_state.dart';
import '../../state/presets_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../value_control.dart';

/// Carte de configuration de démarrage rapide
class QuickStartCard extends StatelessWidget {
  const QuickStartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<IntervalTimerHomeState>();
    final presetsState = context.watch<PresetsState>();
    final isExpanded = homeState.quickStartExpanded;

    return Card(
      key: const Key('interval_timer_home__card_6'),
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec titre et bouton replier
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Démarrage rapide',
                  key: const Key('interval_timer_home__text_8'),
                  style: AppTextStyles.titleLarge,
                ),
                IconButton(
                  key: const Key('interval_timer_home__icon_button_9'),
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    context.read<IntervalTimerHomeState>().toggleQuickStartSection();
                  },
                  tooltip: isExpanded
                      ? 'Replier la section Démarrage rapide'
                      : 'Déplier la section Démarrage rapide',
                  iconSize: 24,
                ),
              ],
            ),

            if (isExpanded) ...[
              const SizedBox(height: 16),

              // Contrôle répétitions
              ValueControl(
                label: 'RÉPÉTITIONS',
                value: homeState.reps.toString(),
                onDecrease: homeState.decrementReps,
                onIncrease: homeState.incrementReps,
                decreaseKey: 'interval_timer_home__icon_button_11',
                valueKey: 'interval_timer_home__text_12',
                increaseKey: 'interval_timer_home__icon_button_13',
                decreaseSemanticLabel: 'Diminuer les répétitions',
                increaseSemanticLabel: 'Augmenter les répétitions',
                decreaseEnabled: homeState.reps > IntervalTimerHomeState.minReps,
                increaseEnabled: homeState.reps < IntervalTimerHomeState.maxReps,
              ),

              const SizedBox(height: 16),

              // Contrôle temps de travail
              ValueControl(
                label: 'TRAVAIL',
                value: homeState.formattedWorkTime,
                onDecrease: homeState.decrementWorkTime,
                onIncrease: homeState.incrementWorkTime,
                decreaseKey: 'interval_timer_home__icon_button_15',
                valueKey: 'interval_timer_home__text_16',
                increaseKey: 'interval_timer_home__icon_button_17',
                decreaseSemanticLabel: 'Diminuer le temps de travail',
                increaseSemanticLabel: 'Augmenter le temps de travail',
                decreaseEnabled: homeState.workSeconds > IntervalTimerHomeState.minWorkSeconds,
                increaseEnabled: homeState.workSeconds < IntervalTimerHomeState.maxWorkSeconds,
              ),

              const SizedBox(height: 16),

              // Contrôle temps de repos
              ValueControl(
                label: 'REPOS',
                value: homeState.formattedRestTime,
                onDecrease: homeState.decrementRestTime,
                onIncrease: homeState.incrementRestTime,
                decreaseKey: 'interval_timer_home__icon_button_19',
                valueKey: 'interval_timer_home__text_20',
                increaseKey: 'interval_timer_home__icon_button_21',
                decreaseSemanticLabel: 'Diminuer le temps de repos',
                increaseSemanticLabel: 'Augmenter le temps de repos',
                decreaseEnabled: homeState.restSeconds > IntervalTimerHomeState.minRestSeconds,
                increaseEnabled: homeState.restSeconds < IntervalTimerHomeState.maxRestSeconds,
              ),

              const SizedBox(height: 16),

              // Bouton sauvegarder
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  key: const Key('interval_timer_home__button_22'),
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('SAUVEGARDER'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: AppTextStyles.label,
                  ),
                  onPressed: () => _showSaveDialog(context, homeState, presetsState),
                ),
              ),

              const SizedBox(height: 8),

              // Bouton commencer (CTA)
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  key: const Key('interval_timer_home__button_23'),
                  icon: const Icon(Icons.bolt, color: AppColors.accent),
                  label: const Text('COMMENCER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cta,
                    foregroundColor: AppColors.onPrimary,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 1,
                  ),
                  onPressed: homeState.canStart
                      ? () {
                          // Navigation vers écran de minuteur
                          _startInterval(context, homeState);
                        }
                      : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(
    BuildContext context,
    IntervalTimerHomeState homeState,
    PresetsState presetsState,
  ) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sauvegarder le préréglage'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nom du préréglage',
            hintText: 'Ex: Gainage',
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _savePreset(context, nameController.text, homeState, presetsState);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _savePreset(context, nameController.text, homeState, presetsState);
              }
            },
            child: const Text('SAUVEGARDER'),
          ),
        ],
      ),
    );
  }

  void _savePreset(
    BuildContext context,
    String name,
    IntervalTimerHomeState homeState,
    PresetsState presetsState,
  ) {
    final preset = homeState.createPresetFromCurrentValues(
      DateTime.now().millisecondsSinceEpoch.toString(),
      name,
    );
    presetsState.addPreset(preset);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Préréglage sauvegardé')),
    );
  }

  void _startInterval(BuildContext context, IntervalTimerHomeState homeState) {
    // Navigation vers écran de minuteur (placeholder)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Démarrage : ${homeState.reps} × (${homeState.workSeconds}s travail + ${homeState.restSeconds}s repos)',
        ),
      ),
    );
  }
}

