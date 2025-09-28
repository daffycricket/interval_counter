import 'package:flutter/material.dart';
import '../models/timer_preset.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/duration_formatter.dart';

/// Widget de carte pour afficher un préréglage de timer
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
      color: AppColors.presetCardBg,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom et durée totale
              _buildHeader(),
              const SizedBox(height: AppTheme.spacingSm),
              
              // Détails de la configuration
              _buildDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Nom du préréglage
        Expanded(
          child: Text(
            preset.name,
            style: AppTextStyles.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Durée totale
        Text(
          DurationFormatter.formatTotalDuration(preset.configuration.totalDuration),
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          'RÉPÉTITIONS ${preset.configuration.repetitions}x',
        ),
        const SizedBox(height: 4),
        _buildDetailRow(
          'TRAVAIL ${DurationFormatter.formatDuration(preset.configuration.workDuration)}',
        ),
        const SizedBox(height: 4),
        _buildDetailRow(
          'REPOS ${DurationFormatter.formatDuration(preset.configuration.restDuration)}',
        ),
      ],
    );
  }

  Widget _buildDetailRow(String text) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}

/// Widget de carte pour l'état vide des préréglages
class EmptyPresetCard extends StatelessWidget {
  final VoidCallback onAddPreset;

  const EmptyPresetCard({
    super.key,
    required this.onAddPreset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.presetCardBg,
      child: InkWell(
        onTap: onAddPreset,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Vous n\'avez pas encore créé de préréglage.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                'Utilisez + Ajouter pour en créer un.',
                style: AppTextStyles.muted,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
