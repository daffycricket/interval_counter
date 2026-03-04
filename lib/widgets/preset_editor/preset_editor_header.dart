import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/view_mode.dart';
import '../../state/preset_editor_state.dart';
import '../../theme/app_colors.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import 'mode_toggle_button.dart';

/// Widget de l'en-tête PresetEditor avec navigation et modes
class PresetEditorHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;

  const PresetEditorHeader({
    super.key,
    required this.onClose,
    required this.onSave,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<PresetEditorState>();

    return SafeArea(
      child: Container(
        key: const Key('preset_editor__container-1'),
        height: 90,
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bouton fermer
            Semantics(
              label: l10n.closeButtonLabel,
              button: true,
              child: IconButton(
                key: const Key('preset_editor__iconbutton-2'),
                icon: const Icon(Icons.close, color: AppColors.onPrimary),
                iconSize: 24,
                onPressed: onClose,
              ),
            ),

            // Boutons mode SIMPLE / ADVANCED
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bouton SIMPLE
                ModeToggleButton(
                  text: l10n.simpleModeButton,
                  isSelected: state.viewMode == ViewMode.simple,
                  onTap: state.switchToSimple,
                  semanticLabel: l10n.simpleModeLabel,
                  buttonKey: const Key('preset_editor__button-3'),
                ),
                const SizedBox(width: 8),

                // Bouton ADVANCED
                ModeToggleButton(
                  text: l10n.advancedModeButton,
                  isSelected: state.viewMode == ViewMode.advanced,
                  onTap: state.switchToAdvanced,
                  semanticLabel: l10n.advancedModeLabel,
                  buttonKey: const Key('preset_editor__button-4'),
                ),
              ],
            ),

            // Bouton sauvegarder
            Semantics(
              label: l10n.saveButtonLabel,
              button: true,
              child: IconButton(
                key: const Key('preset_editor__iconbutton-5'),
                icon: const Icon(Icons.save, color: AppColors.onPrimary),
                iconSize: 24,
                onPressed: onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

