import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/preset.dart';
import '../state/workout_state.dart';
import '../theme/app_colors.dart';
import '../widgets/workout/volume_controls.dart';
import '../widgets/workout/navigation_controls.dart';
import '../widgets/workout/workout_display.dart';
import '../widgets/workout/pause_button.dart';

/// Écran principal de la session d'entraînement
class WorkoutScreen extends StatelessWidget {
  final Preset preset;
  
  const WorkoutScreen({
    super.key,
    required this.preset,
  });
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WorkoutState>(
      future: WorkoutState.create(
        preset,
        onWorkoutComplete: () {
          // Retour à l'écran Home
          Navigator.of(context).pop();
        },
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return ChangeNotifierProvider.value(
          value: snapshot.data!,
          child: const _WorkoutScreenContent(),
        );
      },
    );
  }
}

class _WorkoutScreenContent extends StatelessWidget {
  const _WorkoutScreenContent();
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkoutState>();
    
    // Déterminer la couleur de fond selon l'étape
    Color backgroundColor;
    switch (state.currentStep) {
      case StepType.preparation:
        backgroundColor = AppColors.prepareColor;
        break;
      case StepType.work:
        backgroundColor = AppColors.workColor;
        break;
      case StepType.rest:
        backgroundColor = AppColors.restColor;
        break;
      case StepType.cooldown:
        backgroundColor = AppColors.cooldownColor;
        break;
    }
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        key: const Key('workout__container-1'),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Tap sur l'écran pour afficher/masquer les contrôles
          state.onScreenTap();
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Contenu principal
              Column(
                children: [
                  // Contrôles de volume (en haut)
                  AnimatedOpacity(
                    opacity: state.controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const VolumeControls(),
                  ),
                  
                  // Contrôles de navigation
                  AnimatedOpacity(
                    opacity: state.controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const NavigationControls(),
                  ),
                  
                  // const SizedBox(height: 24),
                  WorkoutDisplay(),
                  // Affichage principal (chronomètre et étape)
                  // const Expanded(
                  //   child: Center(
                  //     child: WorkoutDisplay(),
                  //   ),
                  // ),
                  
                  const SizedBox(height: 80), // Espace pour le FAB
                ],
              ),
              
              // Bouton pause (FAB en bas à droite)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: 16,
                bottom: state.controlsVisible ? 16 : -80, // Masque en bas
                child: const PauseButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

