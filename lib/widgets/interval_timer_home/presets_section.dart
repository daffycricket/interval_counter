import 'package:flutter/material.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Presets section header with title and action buttons
/// Corresponds to Container-24, Text-25, IconButton-26, Button-27 from plan.md
class PresetsSection extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onAdd;

  const PresetsSection({
    super.key,
    required this.onEdit,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const Key('interval_timer_home__Container-24'),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title (Text-25)
          Text(
            l10n.presetsTitle,
            key: const Key('interval_timer_home__Text-25'),
            style: AppTextStyles.title.copyWith(fontSize: 16),
          ),

          const SizedBox(width: 12),

          // Edit button (IconButton-26)
          IconButton(
            key: const Key('interval_timer_home__IconButton-26'),
            icon: const Icon(Icons.edit, size: 20),
            color: AppColors.textSecondary,
            onPressed: onEdit,
            tooltip: l10n.editPresetsLabel,
            splashRadius: 20,
          ),

          const Spacer(),

          // Add button (Button-27)
          OutlinedButton.icon(
            key: const Key('interval_timer_home__Button-27'),
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.addButton),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
