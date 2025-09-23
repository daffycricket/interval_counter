import 'package:flutter/material.dart';
import '../models/timer_preset.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';

/// Widget de carte pour afficher un préréglage
class PresetCard extends StatelessWidget {
  final TimerPreset preset;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PresetCard({
    super.key,
    required this.preset,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('preset_card_${preset.id}'),
      color: AppColors.presetCardBg,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec nom et heure
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nom du préréglage
                  Expanded(
                    child: Text(
                      preset.name,
                      style: AppTextStyles.title,
                      semanticsLabel: 'Préréglage ${preset.name}',
                    ),
                  ),
                  
                  // Heure de création
                  Text(
                    preset.formattedCreatedTime,
                    style: AppTextStyles.label,
                    semanticsLabel: 'Créé à ${preset.formattedCreatedTime}',
                  ),
                  
                  // Actions (edit/delete) - optionnelles
                  if (onEdit != null || onDelete != null) ...[
                    const SizedBox(width: AppTheme.spacingSm),
                    PopupMenuButton<String>(
                      key: Key('preset_menu_${preset.id}'),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Modifier'),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Supprimer'),
                          ),
                      ],
                      child: const Icon(
                        Icons.more_vert,
                        size: 20,
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingXs),
              
              // Détails du préréglage
              _buildPresetDetail(
                'RÉPÉTITIONS ${preset.formattedRepetitions}',
                '${preset.repetitions} répétitions',
              ),
              
              _buildPresetDetail(
                'TRAVAIL ${preset.formattedWorkTime}',
                'Temps de travail ${preset.formattedWorkTime}',
              ),
              
              _buildPresetDetail(
                'REPOS ${preset.formattedRestTime}',
                'Temps de repos ${preset.formattedRestTime}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetDetail(String text, String semanticLabel) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spacingXxs),
      child: Text(
        text,
        style: AppTextStyles.body,
        semanticsLabel: semanticLabel,
      ),
    );
  }
}
