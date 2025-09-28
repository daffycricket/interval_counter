import 'package:flutter/material.dart';
import '../models/timer_preset.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/duration_formatter.dart';

class PresetCard extends StatelessWidget {
  final TimerPreset preset;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const PresetCard({
    super.key,
    required this.preset,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('preset_card_${preset.id}'),
      color: AppColors.presetCardBg,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.getRadius('lg')),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.getSpacing('md')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec nom et durée totale
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      preset.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DurationFormatter.formatTotalDuration(
                      preset.configuration.totalDuration,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.getSpacing('sm')),
              // Détails des paramètres
              _buildParameterRow(
                context,
                'RÉPÉTITIONS ${preset.configuration.repetitions}x',
              ),
              SizedBox(height: AppTheme.getSpacing('xxs')),
              _buildParameterRow(
                context,
                'TRAVAIL ${DurationFormatter.formatDuration(preset.configuration.workDuration)}',
              ),
              SizedBox(height: AppTheme.getSpacing('xxs')),
              _buildParameterRow(
                context,
                'REPOS ${DurationFormatter.formatDuration(preset.configuration.restDuration)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParameterRow(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
