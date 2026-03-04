import 'package:flutter/material.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../state/workout_state.dart';
import '../../theme/app_colors.dart';

/// Widget de contrôles de navigation (précédent, sortir, suivant)
class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkoutState>();
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      key: const Key('workout__container-2'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton précédent
          IconButton(
            key: const Key('workout__iconbutton-2'),
            icon: const Icon(Icons.skip_previous, color: Colors.black),
            onPressed: state.previousStep,
            tooltip: l10n.workoutPrevious,
          ),

          // Bouton "Maintenir pour sortir"
          GestureDetector(
            key: const Key('workout__button-1'),
            behavior: HitTestBehavior.opaque,
            onLongPress: () {
              state.onLongPress();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.ghostButtonBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                l10n.workoutExitButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Bouton suivant
          IconButton(
            key: const Key('workout__iconbutton-3'),
            icon: const Icon(Icons.skip_next, color: Colors.black),
            onPressed: state.nextStep,
            tooltip: l10n.workoutNext,
          ),
        ],
      ),
    );
  }
}

