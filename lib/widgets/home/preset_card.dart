import 'package:flutter/material.dart';
import '../../models/preset.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Carte affichant un préréglage
class PresetCard extends StatelessWidget {
  final Preset preset;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PresetCard({
    super.key,
    required this.preset,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dismissible(
      key: Key('dismissible_${preset.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        key: const Key('home__Card-28'),
        color: AppColors.presetCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(2),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec nom et durée
                Row(
                  key: const Key('home__Container-29'),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      preset.name,
                      key: const Key('home__Text-30'),
                      style: AppTextStyles.title,
                    ),
                    Text(
                      preset.formattedDuration,
                      key: const Key('home__Text-31'),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Détails
                Text(
                  '${l10n.repsLabel} ${preset.repetitions}x',
                  key: const Key('home__Text-32'),
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.workLabel} ${_formatTime(preset.workSeconds)}',
                  key: const Key('home__Text-33'),
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.restLabel} ${_formatTime(preset.restSeconds)}',
                  key: const Key('home__Text-34'),
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

