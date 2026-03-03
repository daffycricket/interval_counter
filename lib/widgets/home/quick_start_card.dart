import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../value_control.dart';
import 'package:interval_counter/l10n/app_localizations.dart';

/// Carte de configuration rapide d'intervalle
class QuickStartCard extends StatelessWidget {
  final bool expanded;
  final int reps;
  final String workTime;
  final String restTime;
  final VoidCallback onToggleExpanded;
  final VoidCallback onDecrementReps;
  final VoidCallback onIncrementReps;
  final VoidCallback onDecrementWork;
  final VoidCallback onIncrementWork;
  final VoidCallback onDecrementRest;
  final VoidCallback onIncrementRest;
  final VoidCallback onSave;
  final bool decreaseRepsEnabled;
  final bool decreaseWorkEnabled;
  final bool decreaseRestEnabled;

  const QuickStartCard({
    super.key,
    required this.expanded,
    required this.reps,
    required this.workTime,
    required this.restTime,
    required this.onToggleExpanded,
    required this.onDecrementReps,
    required this.onIncrementReps,
    required this.onDecrementWork,
    required this.onIncrementWork,
    required this.onDecrementRest,
    required this.onIncrementRest,
    required this.onSave,
    required this.decreaseRepsEnabled,
    required this.decreaseWorkEnabled,
    required this.decreaseRestEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      key: const Key('home__Card-6'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec titre et bouton repli
            Row(
              key: const Key('home__Container-7'),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.quickStartTitle,
                  key: const Key('home__Text-8'),
                  style: AppTextStyles.title,
                ),
                Semantics(
                  label: l10n.collapseQuickStartLabel,
                  button: true,
                  child: IconButton(
                    key: const Key('home__IconButton-9'),
                    icon: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textSecondary,
                    ),
                    iconSize: 24,
                    onPressed: onToggleExpanded,
                  ),
                ),
              ],
            ),

            if (expanded) ...[
              const SizedBox(height: 16),

              // Contrôle répétitions
              ValueControl(
                label: l10n.repsLabel,
                value: reps.toString(),
                onDecrease: onDecrementReps,
                onIncrease: onIncrementReps,
                decreaseKey: 'home__IconButton-11',
                valueKey: 'home__Text-12',
                increaseKey: 'home__IconButton-13',
                decreaseSemanticLabel: l10n.decreaseRepsLabel,
                increaseSemanticLabel: l10n.increaseRepsLabel,
                decreaseEnabled: decreaseRepsEnabled,
              ),

              const SizedBox(height: 16),

              // Contrôle temps de travail
              ValueControl(
                label: l10n.workLabel,
                value: workTime,
                onDecrease: onDecrementWork,
                onIncrease: onIncrementWork,
                decreaseKey: 'home__IconButton-15',
                valueKey: 'home__Text-16',
                increaseKey: 'home__IconButton-17',
                decreaseSemanticLabel: l10n.decreaseWorkLabel,
                increaseSemanticLabel: l10n.increaseWorkLabel,
                decreaseEnabled: decreaseWorkEnabled,
              ),

              const SizedBox(height: 16),

              // Contrôle temps de repos
              ValueControl(
                label: l10n.restLabel,
                value: restTime,
                onDecrease: onDecrementRest,
                onIncrease: onIncrementRest,
                decreaseKey: 'home__IconButton-19',
                valueKey: 'home__Text-20',
                increaseKey: 'home__IconButton-21',
                decreaseSemanticLabel: l10n.decreaseRestLabel,
                increaseSemanticLabel: l10n.increaseRestLabel,
                decreaseEnabled: decreaseRestEnabled,
              ),

              const SizedBox(height: 16),

              // Bouton sauvegarder
              Align(
                alignment: Alignment.centerRight,
                child: Semantics(
                  label: l10n.savePresetLabel,
                  button: true,
                  child: TextButton.icon(
                    key: const Key('home__Button-22'),
                    onPressed: onSave,
                    icon: const Icon(Icons.save, color: AppColors.primary, size: 18),
                    label: Text(
                      l10n.saveButton,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

