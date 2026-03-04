import 'package:flutter/material.dart';
import '../../models/advanced_step.dart';
import '../../domain/step_mode.dart';
import '../../domain/time_formatter.dart';
import 'step_mode_toggle.dart';
import 'step_value_control.dart';
import 'step_action_bar.dart';

/// Carte d'une étape dans le mode ADVANCED.
/// Affiche le nom, le toggle TIME/REPS, les contrôles de valeur,
/// et les actions (COLOR, dupliquer, supprimer).
class AdvancedStepCard extends StatelessWidget {
  final AdvancedStep step;
  final VoidCallback? onModeToggle;
  final VoidCallback? onIncrementValue;
  final VoidCallback? onDecrementValue;
  final VoidCallback? onIncrementDuration;
  final VoidCallback? onDecrementDuration;
  final VoidCallback? onColorTap;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

  const AdvancedStepCard({
    super.key,
    required this.step,
    this.onModeToggle,
    this.onIncrementValue,
    this.onDecrementValue,
    this.onIncrementDuration,
    this.onDecrementDuration,
    this.onColorTap,
    this.onDuplicate,
    this.onDelete,
  });

  /// Determine text color based on background luminance.
  Color get _foreground =>
      step.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  Color get _mutedColor =>
      step.color.computeLuminance() > 0.5
          ? Colors.black.withAlpha(128)
          : Colors.white.withAlpha(128);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: step.color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: step name + drag handle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                step.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _foreground,
                ),
              ),
              ReorderableDragStartListener(
                index: step.order,
                child: Semantics(
                  label: 'Reorder ${step.name}',
                  button: true,
                  child: Icon(Icons.drag_handle, color: _foreground, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Mode toggle: TIME / REPS
          StepModeToggle(
            mode: step.mode,
            onModeChanged: (_) => onModeToggle?.call(),
            textActiveColor: _foreground,
            textInactiveColor: _mutedColor,
          ),
          const SizedBox(height: 8),

          // Primary value control (time or reps depending on mode)
          if (step.mode == StepMode.time)
            StepValueControl(
              value: TimeFormatter.format(step.durationSeconds),
              onDecrease: onDecrementValue,
              onIncrease: onIncrementValue,
              decreaseSemanticLabel: 'Decrease time ${step.name}',
              increaseSemanticLabel: 'Increase time ${step.name}',
              foregroundColor: _foreground,
              borderColor: _foreground,
            )
          else ...[
            // REPS mode: show reps counter
            StepValueControl(
              value: '${step.repeatCount}',
              onDecrease: onDecrementValue,
              onIncrease: onIncrementValue,
              decreaseSemanticLabel: 'Decrease reps ${step.name}',
              increaseSemanticLabel: 'Increase reps ${step.name}',
              foregroundColor: _foreground,
              borderColor: _foreground,
            ),
            const SizedBox(height: 8),
            // Duration control for REPS mode
            StepValueControl(
              value: '${step.durationSeconds.toDouble().toStringAsFixed(1)}s',
              onDecrease: onDecrementDuration,
              onIncrease: onIncrementDuration,
              decreaseSemanticLabel: 'Decrease duration ${step.name}',
              increaseSemanticLabel: 'Increase duration ${step.name}',
              foregroundColor: _foreground,
              borderColor: _foreground,
            ),
          ],
          const SizedBox(height: 8),

          // Action bar: COLOR, duplicate, delete
          StepActionBar(
            onColorTap: onColorTap,
            onDuplicate: onDuplicate,
            onDelete: onDelete,
            foregroundColor: _foreground,
          ),
        ],
      ),
    );
  }
}
