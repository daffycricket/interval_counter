import 'package:flutter/material.dart';
import 'package:interval_counter/theme/app_colors.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../domain/step_type.dart';
import '../../state/workout_state.dart';

/// Widget d'affichage principal (compteur répétitions, chronomètre, libellé étape)
class WorkoutDisplay extends StatelessWidget {
  const WorkoutDisplay({super.key});
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkoutState>();
    final hsl = HSLColor.fromColor(AppColors.textActive);
    final inactiveTextColor = hsl.withLightness(hsl.lightness * 0.4).toColor();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Compteur de répétitions (espace toujours réservé)
        Visibility(
          visible: state.currentStep == StepType.work || state.currentStep == StepType.rest,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Text(
            key: const Key('workout__text-1'),
            state.remainingReps.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 100,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Chronomètre
        Text(
          key: const Key('workout__text-2'),
          state.formattedTime,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 160,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Libellé de l'étape
        Text(
          key: const Key('workout__text-3'),
          _stepLabel(context, state),
          style: TextStyle(
            color: state.isPaused ? inactiveTextColor : AppColors.textActive,
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _stepLabel(BuildContext context, WorkoutState state) {
    switch (state.currentStep) {
      case StepType.preparation:
        return AppLocalizations.of(context)!.workoutStepPrepare;
      case StepType.work:
        return AppLocalizations.of(context)!.workoutStepWork;
      case StepType.rest:
        return AppLocalizations.of(context)!.workoutStepRest;
      case StepType.cooldown:
        return AppLocalizations.of(context)!.workoutStepCooldown;
    }
  }
}

