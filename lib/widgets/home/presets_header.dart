import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// En-tête de la section préréglages
class PresetsHeader extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onAdd;

  const PresetsHeader({
    super.key,
    required this.onEdit,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const Key('home__Container-24'),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titre
          Text(
            l10n.presetsTitle,
            key: const Key('home__Text-25'),
            style: AppTextStyles.label.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [
              // Bouton éditer
              Semantics(
                label: l10n.editPresetsLabel,
                button: true,
                child: IconButton(
                  key: const Key('home__IconButton-26'),
                  icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                  iconSize: 24,
                  onPressed: onEdit,
                ),
              ),

              const SizedBox(width: 8),

              // Bouton ajouter
              Semantics(
                label: l10n.addPresetLabel,
                button: true,
                child: OutlinedButton.icon(
                  key: const Key('home__Button-27'),
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, color: AppColors.primary, size: 18),
                  label: Text(
                    l10n.addButton,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

