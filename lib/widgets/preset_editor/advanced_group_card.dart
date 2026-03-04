import 'package:flutter/material.dart';
import '../../models/workout_group.dart';
import '../../theme/app_colors.dart';
import 'advanced_step_card.dart';
import 'step_value_control.dart';
import 'add_step_button.dart';

/// Carte groupe : header RÉPÉTITIONS avec ±, liste réordonnéable d'étapes,
/// bouton ajouter étape + sous-total.
class AdvancedGroupCard extends StatelessWidget {
  final WorkoutGroup group;
  final int groupIndex;
  final String subtotal;
  final VoidCallback? onIncrementReps;
  final VoidCallback? onDecrementReps;
  final VoidCallback? onAddStep;
  final void Function(int stepIdx)? onModeToggle;
  final void Function(int stepIdx)? onIncrementStepValue;
  final void Function(int stepIdx)? onDecrementStepValue;
  final void Function(int stepIdx)? onIncrementStepDuration;
  final void Function(int stepIdx)? onDecrementStepDuration;
  final void Function(int stepIdx)? onStepColorTap;
  final void Function(int stepIdx)? onDuplicateStep;
  final void Function(int stepIdx)? onDeleteStep;
  final void Function(int oldIdx, int newIdx)? onReorderStep;

  const AdvancedGroupCard({
    super.key,
    required this.group,
    required this.groupIndex,
    required this.subtotal,
    this.onIncrementReps,
    this.onDecrementReps,
    this.onAddStep,
    this.onModeToggle,
    this.onIncrementStepValue,
    this.onDecrementStepValue,
    this.onIncrementStepDuration,
    this.onDecrementStepDuration,
    this.onStepColorTap,
    this.onDuplicateStep,
    this.onDeleteStep,
    this.onReorderStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.advancedCardBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group header: RÉPÉTITIONS label
          const Text(
            'RÉPÉTITIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.advancedTextPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Reps control (± value)
          StepValueControl(
            value: '${group.repeatCount}',
            onDecrease: onDecrementReps,
            onIncrease: onIncrementReps,
            decreaseSemanticLabel: 'Decrease group repetitions',
            increaseSemanticLabel: 'Increase group repetitions',
            foregroundColor: AppColors.advancedTextPrimary,
            borderColor: AppColors.advancedTextPrimary,
          ),
          const SizedBox(height: 8),

          // Steps list (reorderable)
          if (group.steps.isNotEmpty)
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.steps.length,
              onReorder: (oldIdx, newIdx) => onReorderStep?.call(oldIdx, newIdx),
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) => Material(
                    color: Colors.transparent,
                    elevation: 4,
                    child: child,
                  ),
                  child: child,
                );
              },
              itemBuilder: (context, stepIdx) {
                final step = group.steps[stepIdx];
                return AdvancedStepCard(
                  key: ValueKey(step.id),
                  step: step.copyWith(order: stepIdx),
                  onModeToggle: () => onModeToggle?.call(stepIdx),
                  onIncrementValue: () => onIncrementStepValue?.call(stepIdx),
                  onDecrementValue: () => onDecrementStepValue?.call(stepIdx),
                  onIncrementDuration: () => onIncrementStepDuration?.call(stepIdx),
                  onDecrementDuration: () => onDecrementStepDuration?.call(stepIdx),
                  onColorTap: () => onStepColorTap?.call(stepIdx),
                  onDuplicate: () => onDuplicateStep?.call(stepIdx),
                  onDelete: () => onDeleteStep?.call(stepIdx),
                );
              },
            ),

          // Add step button + subtotal
          AddStepButton(
            onTap: onAddStep,
            subtotal: subtotal,
          ),
        ],
      ),
    );
  }
}
