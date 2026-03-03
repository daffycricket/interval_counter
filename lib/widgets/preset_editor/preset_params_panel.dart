import 'package:flutter/material.dart';
import '../value_control.dart';
import 'package:interval_counter/l10n/app_localizations.dart';

/// Widget du panneau de configuration des paramètres en mode SIMPLE
class PresetParamsPanel extends StatelessWidget {
  final int prepareSeconds;
  final int repetitions;
  final int workSeconds;
  final int restSeconds;
  final int cooldownSeconds;
  final String formattedPrepareTime;
  final String formattedWorkTime;
  final String formattedRestTime;
  final String formattedCooldownTime;
  final VoidCallback onDecrementPrepare;
  final VoidCallback onIncrementPrepare;
  final VoidCallback onDecrementReps;
  final VoidCallback onIncrementReps;
  final VoidCallback onDecrementWork;
  final VoidCallback onIncrementWork;
  final VoidCallback onDecrementRest;
  final VoidCallback onIncrementRest;
  final VoidCallback onDecrementCooldown;
  final VoidCallback onIncrementCooldown;

  const PresetParamsPanel({
    super.key,
    required this.prepareSeconds,
    required this.repetitions,
    required this.workSeconds,
    required this.restSeconds,
    required this.cooldownSeconds,
    required this.formattedPrepareTime,
    required this.formattedWorkTime,
    required this.formattedRestTime,
    required this.formattedCooldownTime,
    required this.onDecrementPrepare,
    required this.onIncrementPrepare,
    required this.onDecrementReps,
    required this.onIncrementReps,
    required this.onDecrementWork,
    required this.onIncrementWork,
    required this.onDecrementRest,
    required this.onIncrementRest,
    required this.onDecrementCooldown,
    required this.onIncrementCooldown,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const Key('preset_editor__container-7'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PRÉPARER
          ValueControl(
            label: l10n.prepareLabel,
            value: formattedPrepareTime,
            onDecrease: onDecrementPrepare,
            onIncrease: onIncrementPrepare,
            decreaseKey: 'preset_editor__iconbutton-9',
            valueKey: 'preset_editor__text-10',
            increaseKey: 'preset_editor__iconbutton-11',
            decreaseSemanticLabel: l10n.decreasePrepareLabel,
            increaseSemanticLabel: l10n.increasePrepareLabel,
            decreaseEnabled: prepareSeconds > 0,
            increaseEnabled: prepareSeconds < 3599,
          ),
          const SizedBox(height: 16),

          // RÉPÉTITIONS
          ValueControl(
            label: l10n.repsLabel,
            value: repetitions.toString(),
            onDecrease: onDecrementReps,
            onIncrease: onIncrementReps,
            decreaseKey: 'preset_editor__iconbutton-13',
            valueKey: 'preset_editor__text-14',
            increaseKey: 'preset_editor__iconbutton-15',
            decreaseSemanticLabel: l10n.decreaseRepsLabel,
            increaseSemanticLabel: l10n.increaseRepsLabel,
            decreaseEnabled: repetitions > 1,
            increaseEnabled: repetitions < 999,
          ),
          const SizedBox(height: 16),

          // TRAVAIL
          ValueControl(
            label: l10n.workLabel,
            value: formattedWorkTime,
            onDecrease: onDecrementWork,
            onIncrease: onIncrementWork,
            decreaseKey: 'preset_editor__iconbutton-17',
            valueKey: 'preset_editor__text-18',
            increaseKey: 'preset_editor__iconbutton-19',
            decreaseSemanticLabel: l10n.decreaseWorkLabel,
            increaseSemanticLabel: l10n.increaseWorkLabel,
            decreaseEnabled: workSeconds > 0,
            increaseEnabled: workSeconds < 3599,
          ),
          const SizedBox(height: 16),

          // REPOS
          ValueControl(
            label: l10n.restLabel,
            value: formattedRestTime,
            onDecrease: onDecrementRest,
            onIncrease: onIncrementRest,
            decreaseKey: 'preset_editor__iconbutton-21',
            valueKey: 'preset_editor__text-22',
            increaseKey: 'preset_editor__iconbutton-23',
            decreaseSemanticLabel: l10n.decreaseRestLabel,
            increaseSemanticLabel: l10n.increaseRestLabel,
            decreaseEnabled: restSeconds > 0,
            increaseEnabled: restSeconds < 3599,
          ),
          const SizedBox(height: 16),

          // REFROIDIR
          ValueControl(
            label: l10n.cooldownLabel,
            value: formattedCooldownTime,
            onDecrease: onDecrementCooldown,
            onIncrease: onIncrementCooldown,
            decreaseKey: 'preset_editor__iconbutton-25',
            valueKey: 'preset_editor__text-26',
            increaseKey: 'preset_editor__iconbutton-27',
            decreaseSemanticLabel: l10n.decreaseCooldownLabel,
            increaseSemanticLabel: l10n.increaseCooldownLabel,
            decreaseEnabled: cooldownSeconds > 0,
            increaseEnabled: cooldownSeconds < 3599,
          ),
        ],
      ),
    );
  }
}

