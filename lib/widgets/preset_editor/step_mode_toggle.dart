import 'package:flutter/material.dart';
import '../../domain/step_mode.dart';
import '../../theme/app_colors.dart';

/// Toggle TIME/REPS pour une étape avancée.
/// Le mode actif est affiché en gras, le mode inactif en semi-transparent.
class StepModeToggle extends StatelessWidget {
  final StepMode mode;
  final ValueChanged<StepMode> onModeChanged;
  final Color textActiveColor;
  final Color textInactiveColor;

  const StepModeToggle({
    super.key,
    required this.mode,
    required this.onModeChanged,
    this.textActiveColor = AppColors.advancedTextPrimary,
    this.textInactiveColor = AppColors.advancedTextSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onModeChanged(StepMode.time),
          child: Text(
            'TIME',
            style: TextStyle(
              fontSize: 12,
              fontWeight: mode == StepMode.time ? FontWeight.bold : FontWeight.w500,
              color: mode == StepMode.time ? textActiveColor : textInactiveColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onModeChanged(StepMode.reps),
          child: Text(
            'REPS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: mode == StepMode.reps ? FontWeight.bold : FontWeight.w500,
              color: mode == StepMode.reps ? textActiveColor : textInactiveColor,
            ),
          ),
        ),
      ],
    );
  }
}
