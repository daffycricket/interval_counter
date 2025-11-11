import '../models/preset.dart';
import 'step_type.dart';

/// Moteur de progression pour une session d'entraînement.
/// Contient toute la logique métier pure (sans side effects) pour :
/// - La progression du temps
/// - Les transitions entre étapes
/// - La gestion des répétitions
/// - La détection du moment pour jouer les bips sonores
/// 
/// Cette classe est pure Dart (pas d'import Flutter) et 100% testable.
class WorkoutEngine {
  final Preset preset;
  
  StepType _currentStep = StepType.preparation;
  int _remainingTime = 0;
  int _remainingReps = 0;
  
  /// Constructeur - initialise l'engine avec le preset
  WorkoutEngine({required this.preset}) {
    _initialize();
  }
  
  /// Initialise l'état initial selon le preset
  void _initialize() {
    _remainingReps = preset.repetitions;
    
    // Si préparation = 0, on commence directement au travail
    if (preset.prepareSeconds > 0) {
      _currentStep = StepType.preparation;
      _remainingTime = preset.prepareSeconds;
    } else {
      _currentStep = StepType.work;
      _remainingTime = preset.workSeconds;
    }
  }
  
  /// Étape actuelle
  StepType get currentStep => _currentStep;
  
  /// Temps restant en secondes pour l'étape actuelle
  int get remainingTime => _remainingTime;
  
  /// Nombre de répétitions restantes
  int get remainingReps => _remainingReps;
  
  /// Indique si un bip sonore doit être joué
  /// Bip aux 3 dernières secondes : 2, 1, 0 (mais pas à 3)
  bool get shouldPlayBeep => _remainingTime >= 0 && _remainingTime <= 2;
  
  /// Indique si la session est terminée
  bool get isFinished => _currentStep == StepType.cooldown && _remainingTime == 0;
  
  /// Fait progresser le temps d'une seconde
  /// Retourne true si une transition d'étape a eu lieu
  bool tick() {
    if (_remainingTime > 0) {
      _remainingTime--;
      
      // Si l'étape est terminée, passer à la suivante
      if (_remainingTime == 0) {
        _transitionToNextStep();
        return true;
      }
    }
    return false;
  }
  
  /// Passe à l'étape suivante manuellement (bouton "Suivant")
  void nextStep() {
    _transitionToNextStep();
  }
  
  /// Revient à l'étape précédente manuellement (bouton "Précédent")
  void previousStep() {
    switch (_currentStep) {
      case StepType.preparation:
        // Pas d'étape avant la préparation, on reste sur préparation
        _remainingTime = preset.prepareSeconds;
        break;
        
      case StepType.work:
        // Retour à la préparation ou au repos de la répétition précédente
        if (preset.prepareSeconds > 0 && _remainingReps == preset.repetitions) {
          // Si on est à la première répétition et qu'il y a une préparation
          _currentStep = StepType.preparation;
          _remainingTime = preset.prepareSeconds;
        } else {
          // Sinon retour au repos de la répétition précédente
          _currentStep = StepType.rest;
          _remainingTime = preset.restSeconds;
          // On incrémente les reps car on revient en arrière
          if (_remainingReps < preset.repetitions) {
            _remainingReps++;
          }
        }
        break;
        
      case StepType.rest:
        // Retour au travail de la même répétition
        _currentStep = StepType.work;
        _remainingTime = preset.workSeconds;
        break;
        
      case StepType.cooldown:
        // Retour au travail de la dernière répétition (sans rest)
        _currentStep = StepType.work;
        _remainingTime = preset.workSeconds;
        _remainingReps = 1;
        break;
    }
  }
  
  /// Gère la transition vers l'étape suivante selon la logique métier
  void _transitionToNextStep() {
    switch (_currentStep) {
      case StepType.preparation:
        // Préparation → Travail (première répétition)
        _currentStep = StepType.work;
        _remainingTime = preset.workSeconds;
        break;
        
      case StepType.work:
        _remainingReps--;
        
        if (_remainingReps > 0) {
          // Encore des répétitions → Repos
          _currentStep = StepType.rest;
          _remainingTime = preset.restSeconds;
        } else {
          // Dernière répétition terminée → Refroidissement (pas de repos)
          if (preset.cooldownSeconds > 0) {
            _currentStep = StepType.cooldown;
            _remainingTime = preset.cooldownSeconds;
          } else {
            // Pas de refroidissement → session terminée
            _currentStep = StepType.cooldown;
            _remainingTime = 0;
          }
        }
        break;
        
      case StepType.rest:
        // Repos → Travail (répétition suivante)
        _currentStep = StepType.work;
        _remainingTime = preset.workSeconds;
        break;
        
      case StepType.cooldown:
        // Refroidissement terminé → reste à cooldown avec temps = 0
        _remainingTime = 0;
        break;
    }
  }
  
  /// Formate le temps restant au format MM:SS
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

