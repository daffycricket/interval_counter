import '../models/preset.dart';
import 'step_type.dart';

/// Represents a single step in the workout sequence
class WorkoutStep {
  final StepType type;
  final int duration;
  final int reps;

  const WorkoutStep({
    required this.type,
    required this.duration,
    required this.reps,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutStep &&
          other.type == type &&
          other.duration == duration &&
          other.reps == reps;

  @override
  int get hashCode => Object.hash(type, duration, reps);

  @override
  String toString() =>
      'WorkoutStep(type: $type, duration: $duration, reps: $reps)';
}

/// Pure business logic engine for workout session progression.
///
/// Generates a flat list of steps from a [Preset] and manages
/// countdown, beep triggers, repetition counting, and step navigation.
/// No Flutter dependencies — fully deterministic and testable.
class WorkoutEngine {
  final List<WorkoutStep> steps;
  int _currentIndex = 0;
  int _remainingTime = 0;
  bool _isComplete = false;

  /// Builds the engine from a [Preset], generating the flat step list.
  ///
  /// Rules applied:
  /// - Steps with duration 0 are skipped
  /// - Last repetition's rest is skipped
  /// - Reps counter starts at [preset.repetitions] and decrements on rest→work
  factory WorkoutEngine({required Preset preset}) {
    final steps = _buildSteps(preset);
    return WorkoutEngine.fromSteps(steps);
  }

  /// Internal constructor for testing with pre-built steps.
  WorkoutEngine.fromSteps(this.steps) {
    if (steps.isNotEmpty) {
      _remainingTime = steps[0].duration;
    } else {
      _isComplete = true;
    }
  }

  static List<WorkoutStep> _buildSteps(Preset preset) {
    final steps = <WorkoutStep>[];

    // Preparation
    if (preset.prepareSeconds > 0) {
      steps.add(WorkoutStep(
        type: StepType.preparation,
        duration: preset.prepareSeconds,
        reps: 0,
      ));
    }

    // Repetitions
    var currentReps = preset.repetitions;
    for (var i = 0; i < preset.repetitions; i++) {
      final isLast = i == preset.repetitions - 1;

      // Work
      if (preset.workSeconds > 0) {
        steps.add(WorkoutStep(
          type: StepType.work,
          duration: preset.workSeconds,
          reps: currentReps,
        ));
      }

      // Rest (skip on last repetition)
      if (!isLast && preset.restSeconds > 0) {
        steps.add(WorkoutStep(
          type: StepType.rest,
          duration: preset.restSeconds,
          reps: currentReps,
        ));
        // Decrement reps on rest→work transition (applied to next work step)
        currentReps--;
      }
    }

    // Cooldown
    if (preset.cooldownSeconds > 0) {
      steps.add(WorkoutStep(
        type: StepType.cooldown,
        duration: preset.cooldownSeconds,
        reps: 0,
      ));
    }

    return steps;
  }

  // --- Getters ---

  StepType get currentStep =>
      _isComplete ? steps.last.type : steps[_currentIndex].type;

  int get remainingTime => _remainingTime;

  int get remainingReps =>
      _isComplete ? steps.last.reps : steps[_currentIndex].reps;

  bool get isComplete => _isComplete;

  int get currentIndex => _currentIndex;

  int get stepCount => steps.length;

  String get formattedTime {
    final minutes = _remainingTime ~/ 60;
    final seconds = _remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // --- Actions ---

  /// Processes one tick (1 second). Returns whether a beep should be played.
  ///
  /// Beep rules: beep when displayed time is 2, 1, or 0 (after decrement).
  /// Transition: when time reaches 0, the *next* tick advances to the next step.
  bool tick() {
    if (_isComplete) return false;

    if (_remainingTime > 0) {
      _remainingTime--;
      return _remainingTime <= 2;
    }

    // remainingTime was already 0 — advance to next step
    _advanceToNextStep();
    return false;
  }

  /// Manually move to the next step.
  void moveToNext() {
    if (_isComplete) return;
    _advanceToNextStep();
  }

  /// Manually move to the previous step.
  void moveToPrevious() {
    if (_isComplete || _currentIndex <= 0) return;
    _currentIndex--;
    _remainingTime = steps[_currentIndex].duration;
  }

  void _advanceToNextStep() {
    if (_currentIndex < steps.length - 1) {
      _currentIndex++;
      _remainingTime = steps[_currentIndex].duration;
    } else {
      _isComplete = true;
    }
  }
}
