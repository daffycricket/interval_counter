import 'package:flutter/material.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../state/interval_timer_home_state.dart';

/// Individual preset card
/// Corresponds to Card-28, Container-29, Text-30 to Text-34 from plan.md
class PresetCard extends StatelessWidget {
  final Preset preset;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool editMode;

  const PresetCard({
    super.key,
    required this.preset,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.editMode = false,
  });

  String _formatDuration() {
    final totalSeconds = preset.reps * (preset.workSeconds + preset.restSeconds);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      key: Key('interval_timer_home__Card-28_${preset.id}'),
      color: AppColors.presetCardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: const BorderSide(color: AppColors.divider, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: InkWell(
        onTap: editMode ? null : onTap,
        onLongPress: editMode ? null : () {
          // Show context menu on long press
          _showContextMenu(context);
        },
        borderRadius: BorderRadius.circular(2),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and duration (Container-29)
              Row(
                key: Key('interval_timer_home__Container-29_${preset.id}'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Preset name (Text-30)
                  Expanded(
                    child: Text(
                      preset.name,
                      key: Key('interval_timer_home__Text-30_${preset.id}'),
                      style: AppTextStyles.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Total duration (Text-31)
                  Text(
                    _formatDuration(),
                    key: Key('interval_timer_home__Text-31_${preset.id}'),
                    style: AppTextStyles.value.copyWith(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // Delete button in edit mode
                  if (editMode) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      color: Colors.red,
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // Details
              Text(
                '${l10n.repsLabel} ${preset.reps}x',
                key: Key('interval_timer_home__Text-32_${preset.id}'),
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 4),

              Text(
                '${l10n.workLabel} ${_formatTime(preset.workSeconds)}',
                key: Key('interval_timer_home__Text-33_${preset.id}'),
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 4),

              Text(
                '${l10n.restLabel} ${_formatTime(preset.restSeconds)}',
                key: Key('interval_timer_home__Text-34_${preset.id}'),
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.editPresetsLabel),
                onTap: () {
                  Navigator.pop(context);
                  onEdit!();
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text('Supprimer', style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete!();
                },
              ),
          ],
        ),
      ),
    );
  }
}
