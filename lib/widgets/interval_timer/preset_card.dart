import 'package:flutter/material.dart';
import '../../models/preset.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Carte représentant un préréglage
class PresetCard extends StatelessWidget {
  final Preset preset;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const PresetCard({
    super.key,
    required this.preset,
    this.onTap,
    this.onDelete,
    this.showDeleteButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('interval_timer_home__Card-28-${preset.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: AppColors.presetCardBg,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : nom et durée
              Row(
                key: Key('interval_timer_home__Container-29-${preset.id}'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      preset.name,
                      key: Key('interval_timer_home__Text-30-${preset.id}'),
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Text(
                        preset.formattedDuration,
                        key: Key('interval_timer_home__Text-31-${preset.id}'),
                        style: AppTextStyles.duration,
                      ),
                      if (showDeleteButton) ...[
                        const SizedBox(width: 8),
                        Semantics(
                          label: 'Supprimer ${preset.name}',
                          button: true,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onDelete,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Détails : répétitions, travail, repos
              Text(
                'RÉPÉTITIONS ${preset.repetitions}x',
                key: Key('interval_timer_home__Text-32-${preset.id}'),
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),
              Text(
                'TRAVAIL ${_formatDuration(preset.workSeconds)}',
                key: Key('interval_timer_home__Text-33-${preset.id}'),
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),
              Text(
                'REPOS ${_formatDuration(preset.restSeconds)}',
                key: Key('interval_timer_home__Text-34-${preset.id}'),
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
