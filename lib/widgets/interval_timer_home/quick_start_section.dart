import 'package:flutter/material.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../value_control.dart';

/// Quick start configuration section
/// Corresponds to Card-6, Container-7, Text-8, IconButton-9, Button-22, Button-23 from plan.md
class QuickStartSection extends StatelessWidget {
  final bool expanded;
  final int reps;
  final int workSeconds;
  final int restSeconds;
  final VoidCallback onToggleExpand;
  final VoidCallback onIncrementReps;
  final VoidCallback onDecrementReps;
  final VoidCallback onIncrementWork;
  final VoidCallback onDecrementWork;
  final VoidCallback onIncrementRest;
  final VoidCallback onDecrementRest;
  final VoidCallback onSave;
  final VoidCallback onStart;

  const QuickStartSection({
    super.key,
    required this.expanded,
    required this.reps,
    required this.workSeconds,
    required this.restSeconds,
    required this.onToggleExpand,
    required this.onIncrementReps,
    required this.onDecrementReps,
    required this.onIncrementWork,
    required this.onDecrementWork,
    required this.onIncrementRest,
    required this.onDecrementRest,
    required this.onSave,
    required this.onStart,
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      key: const Key('interval_timer_home__Card-6'),
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(color: AppColors.divider, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with title and collapse button (Container-7)
            Row(
              key: const Key('interval_timer_home__Container-7'),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title (Text-8)
                Text(
                  l10n.quickStartTitle,
                  key: const Key('interval_timer_home__Text-8'),
                  style: AppTextStyles.titleLarge,
                ),

                // Collapse/expand button (IconButton-9)
                IconButton(
                  key: const Key('interval_timer_home__IconButton-9'),
                  icon: Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  color: AppColors.textSecondary,
                  onPressed: onToggleExpand,
                  tooltip: l10n.collapseQuickStartLabel,
                  splashRadius: 20,
                ),
              ],
            ),

            // Collapsible content
            if (expanded) ...[
              const SizedBox(height: 16),

              // RÉPÉTITIONS ValueControl (Text-10 to IconButton-13)
              ValueControl(
                label: l10n.repsLabel,
                value: reps.toString(),
                onDecrease: onDecrementReps,
                onIncrease: onIncrementReps,
                decreaseKey: 'interval_timer_home__IconButton-11',
                valueKey: 'interval_timer_home__Text-12',
                increaseKey: 'interval_timer_home__IconButton-13',
                decreaseSemanticLabel: l10n.decreaseRepsLabel,
                increaseSemanticLabel: l10n.increaseRepsLabel,
                decreaseEnabled: reps > 1,
                increaseEnabled: reps < 99,
              ),

              const SizedBox(height: 16),

              // TRAVAIL ValueControl (Text-14 to IconButton-17)
              ValueControl(
                label: l10n.workLabel,
                value: _formatTime(workSeconds),
                onDecrease: onDecrementWork,
                onIncrease: onIncrementWork,
                decreaseKey: 'interval_timer_home__IconButton-15',
                valueKey: 'interval_timer_home__Text-16',
                increaseKey: 'interval_timer_home__IconButton-17',
                decreaseSemanticLabel: l10n.decreaseWorkLabel,
                increaseSemanticLabel: l10n.increaseWorkLabel,
                decreaseEnabled: workSeconds > 5,
                increaseEnabled: workSeconds < 3600,
              ),

              const SizedBox(height: 16),

              // REPOS ValueControl (Text-18 to IconButton-21)
              ValueControl(
                label: l10n.restLabel,
                value: _formatTime(restSeconds),
                onDecrease: onDecrementRest,
                onIncrease: onIncrementRest,
                decreaseKey: 'interval_timer_home__IconButton-19',
                valueKey: 'interval_timer_home__Text-20',
                increaseKey: 'interval_timer_home__IconButton-21',
                decreaseSemanticLabel: l10n.decreaseRestLabel,
                increaseSemanticLabel: l10n.increaseRestLabel,
                decreaseEnabled: restSeconds > 0,
                increaseEnabled: restSeconds < 3600,
              ),

              const SizedBox(height: 16),

              // Save button (Button-22)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  key: const Key('interval_timer_home__Button-22'),
                  onPressed: onSave,
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(l10n.saveButton),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Start button (Button-23)
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  key: const Key('interval_timer_home__Button-23'),
                  onPressed: onStart,
                  icon: const Icon(Icons.bolt, color: AppColors.accent),
                  label: Text(l10n.startButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cta,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: AppTextStyles.buttonCta,
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
