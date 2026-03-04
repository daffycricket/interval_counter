import 'package:flutter/material.dart';
import 'package:interval_counter/services/impl/beep_audio_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/step_type.dart';
import '../models/preset.dart';
import '../routes/app_routes.dart';
import '../state/workout_state.dart';
import '../theme/app_colors.dart';
import '../widgets/volume_header.dart';
import '../widgets/workout/navigation_controls.dart';
import '../widgets/workout/workout_display.dart';
import '../widgets/workout/pause_button.dart';
import '../services/impl/system_ticker_service.dart';
import '../services/impl/shared_prefs_repository.dart';

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
      future: _createWorkoutState(),
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
          child: _WorkoutScreenContent(preset: preset),
        );
      },
    );
  }
  
  /// Crée le WorkoutState avec injection de dépendances
  Future<WorkoutState> _createWorkoutState() async {
    // Instancier les services concrets
    final tickerService = SystemTickerService();
    final audioService = BeepAudioService();
    await audioService.initialize();
    final prefs = await SharedPreferences.getInstance();
    final prefsRepo = SharedPrefsRepository(prefs);
    return WorkoutState(preset: preset, tickerService: tickerService, audioService: audioService, prefsRepo: prefsRepo);
  }
}

class _WorkoutScreenContent extends StatefulWidget {
  final Preset preset;

  const _WorkoutScreenContent({required this.preset});

  @override
  State<_WorkoutScreenContent> createState() => _WorkoutScreenContentState();
}

class _WorkoutScreenContentState extends State<_WorkoutScreenContent> {
  late final WorkoutState _workoutState;

  @override
  void initState() {
    super.initState();
    _workoutState = context.read<WorkoutState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _workoutState.addListener(_checkWorkoutComplete);
    });    
  }
  
  void _checkWorkoutComplete() {
    // fin manuelle de la session
    if (_workoutState.isExiting) {
      _workoutState.removeListener(_checkWorkoutComplete);
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    // fin naturelle de la session → écran de fin de workout
    if (_workoutState.isComplete) {
      _workoutState.removeListener(_checkWorkoutComplete);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.endWorkout,
          arguments: widget.preset,
        );
      }
    }
  }
  
  @override
  void dispose() {
    _workoutState.removeListener(_checkWorkoutComplete);
    _workoutState.dispose();
    super.dispose();
  }
  
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

    if (state.isPaused) {
      final hsl = HSLColor.fromColor(backgroundColor);
      backgroundColor = hsl.withLightness(hsl.lightness * 0.4).toColor();
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
                    child: VolumeHeader(
                      volume: state.volume,
                      backgroundColor: backgroundColor,
                      activeColor: AppColors.sliderActiveDark,
                      inactiveColor: AppColors.sliderInactiveDark,
                      onVolumeChange: state.onVolumeChange,
                      onMenuPressed: null, // Pas de menu dans Workout
                    ),
                  ),
                  
                  // Contrôles de navigation
                  AnimatedOpacity(
                    opacity: state.controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const NavigationControls(),
                  ),
                  
                  const Spacer(),
                  
                  const WorkoutDisplay(),
                  
                  const Spacer(),
                  
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
