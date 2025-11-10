import 'package:flutter/foundation.dart' show immutable;
import '../models/preset.dart';

/// Type d'étape dans la session d'entraînement
enum StepType {
  preparation,
  work,
  rest,
  cooldown,
}

/// Moteur de logique métier pour la session d'entraînement.
/// Pure business logic, pas de dépendances Flutter (sauf foundation).
/// Gère les transitions d'étapes, le timing et les règles métier.
@immutable
class WorkoutEngine {
  final Preset preset;
  final StepType currentStep;
  final int remainingTime;
  final int remainingReps;
  final bool isPaused;
  
  /// Constructeur principal
  const WorkoutEngine({
    required this.preset,
    required this.currentStep,
    required this.remainingTime,
    required this.remainingReps,
    this.isPaused = false,
  });
  
  /// Factory: initialise l'engine avec un preset
  factory WorkoutEngine.fromPreset(Preset preset) {
    // Déterminer l'étape initiale selon les règles métier
    StepType initialStep;
    int initialTime;
    
    if (preset.prepareSeconds > 0) {
      initialStep = StepType.preparation;
      initialTime = preset.prepareSeconds;
    } else if (preset.workSeconds > 0) {
      initialStep = StepType.work;
      initialTime = preset.workSeconds;
    } else {
      // Fallback (ne devrait pas arriver)
      initialStep = StepType.work;
      initialTime = 0;
    }
    
    return WorkoutEngine(
      preset: preset,
      currentStep: initialStep,
      remainingTime: initialTime,
      remainingReps: preset.repetitions,
      isPaused: false,
    );
  }
  
  /// Indique si un bip sonore doit être émis
  /// Règle: 3, 2, 1 secondes avant la fin de l'étape
  bool get shouldPlayBeep => remainingTime <= 3 && remainingTime > 0;
  
  /// Indique si le compteur de répétitions doit être affiché
  /// Règle: visible uniquement pour work et rest
  bool get shouldShowRepsCounter => 
      currentStep == StepType.work || currentStep == StepType.rest;
  
  /// Indique si la session est terminée
  bool get isComplete => 
      currentStep == StepType.cooldown && remainingTime == 0;
  
  /// Tick: décrémente le temps, retourne un nouvel engine
  /// Appeler nextStep() si le temps atteint 0
  WorkoutEngine tick() {
    if (isPaused) {
      return this; // Pas de tick en pause
    }
    
    if (remainingTime > 0) {
      return copyWith(remainingTime: remainingTime - 1);
    } else {
      // Temps écoulé, passer à l'étape suivante
      return nextStep();
    }
  }
  
  /// Passe à l'étape suivante selon les règles métier
  WorkoutEngine nextStep() {
    switch (currentStep) {
      case StepType.preparation:
        // Préparation → Travail
        return copyWith(
          currentStep: StepType.work,
          remainingTime: preset.workSeconds,
        );
        
      case StepType.work:
        // Travail → Repos (sauf dernière répétition)
        final newRemainingReps = remainingReps - 1;
        
        if (newRemainingReps > 0 && preset.restSeconds > 0) {
          // Encore des répétitions et repos configuré
          return copyWith(
            currentStep: StepType.rest,
            remainingTime: preset.restSeconds,
            remainingReps: newRemainingReps,
          );
        } else {
          // Dernière répétition ou pas de repos → Refroidissement
          return _goToCooldownOrEnd(newRemainingReps);
        }
        
      case StepType.rest:
        // Repos → Travail (si encore des répétitions)
        if (remainingReps > 0) {
          return copyWith(
            currentStep: StepType.work,
            remainingTime: preset.workSeconds,
          );
        } else {
          return _goToCooldownOrEnd(0);
        }
        
      case StepType.cooldown:
        // Refroidissement → Fin (temps déjà à 0)
        return this;
    }
  }
  
  /// Revient à l'étape précédente
  WorkoutEngine previousStep() {
    switch (currentStep) {
      case StepType.preparation:
        // Déjà au début, recommencer la préparation
        return copyWith(remainingTime: preset.prepareSeconds);
        
      case StepType.work:
        // Si préparation existe, retour à préparation
        if (preset.prepareSeconds > 0) {
          return copyWith(
            currentStep: StepType.preparation,
            remainingTime: preset.prepareSeconds,
            remainingReps: preset.repetitions,
          );
        } else {
          // Sinon, recommencer le travail
          return copyWith(remainingTime: preset.workSeconds);
        }
        
      case StepType.rest:
        // Repos → Travail avec incrémentation des répétitions
        return copyWith(
          currentStep: StepType.work,
          remainingTime: preset.workSeconds,
          remainingReps: remainingReps + 1,
        );
        
      case StepType.cooldown:
        // Retour à la dernière répétition de travail
        return copyWith(
          currentStep: StepType.work,
          remainingTime: preset.workSeconds,
          remainingReps: 1,
        );
    }
  }
  
  /// Toggle pause
  WorkoutEngine togglePause() {
    return copyWith(isPaused: !isPaused);
  }
  
  /// Méthode privée: va au refroidissement ou termine
  WorkoutEngine _goToCooldownOrEnd(int newRemainingReps) {
    if (preset.cooldownSeconds > 0) {
      return copyWith(
        currentStep: StepType.cooldown,
        remainingTime: preset.cooldownSeconds,
        remainingReps: newRemainingReps,
      );
    } else {
      // Pas de refroidissement, marquer comme terminé
      return copyWith(
        currentStep: StepType.cooldown,
        remainingTime: 0,
        remainingReps: newRemainingReps,
      );
    }
  }
  
  /// CopyWith pattern pour immutabilité
  WorkoutEngine copyWith({
    Preset? preset,
    StepType? currentStep,
    int? remainingTime,
    int? remainingReps,
    bool? isPaused,
  }) {
    return WorkoutEngine(
      preset: preset ?? this.preset,
      currentStep: currentStep ?? this.currentStep,
      remainingTime: remainingTime ?? this.remainingTime,
      remainingReps: remainingReps ?? this.remainingReps,
      isPaused: isPaused ?? this.isPaused,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutEngine &&
          runtimeType == other.runtimeType &&
          preset == other.preset &&
          currentStep == other.currentStep &&
          remainingTime == other.remainingTime &&
          remainingReps == other.remainingReps &&
          isPaused == other.isPaused;
  
  @override
  int get hashCode =>
      preset.hashCode ^
      currentStep.hashCode ^
      remainingTime.hashCode ^
      remainingReps.hashCode ^
      isPaused.hashCode;
}









