import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/preset_editor_state.dart';
import '../widgets/preset_editor/preset_editor_header.dart';
import '../widgets/preset_editor/preset_name_input.dart';
import '../widgets/preset_editor/preset_params_panel.dart';
import '../widgets/preset_editor/preset_total_display.dart';
import '../domain/view_mode.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Écran d'édition et de création de préréglages
class PresetEditorScreen extends StatelessWidget {
  const PresetEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PresetEditorState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PresetEditorHeader(
        onClose: () => _close(context, state),
        onSave: () => _save(context, state),
      ),
      body: Column(
        children: [
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Champ nom
                  PresetNameInput(
                    name: state.name,
                    onNameChange: state.onNameChange,
                  ),

                  const SizedBox(height: 24),

                  // Panneau paramètres (mode SIMPLE)
                  if (state.viewMode == ViewMode.simple)
                    PresetParamsPanel(
                      prepareSeconds: state.prepareSeconds,
                      repetitions: state.repetitions,
                      workSeconds: state.workSeconds,
                      restSeconds: state.restSeconds,
                      cooldownSeconds: state.cooldownSeconds,
                      formattedPrepareTime: state.formattedPrepareTime,
                      formattedWorkTime: state.formattedWorkTime,
                      formattedRestTime: state.formattedRestTime,
                      formattedCooldownTime: state.formattedCooldownTime,
                      onDecrementPrepare: state.decrementPrepare,
                      onIncrementPrepare: state.incrementPrepare,
                      onDecrementReps: state.decrementReps,
                      onIncrementReps: state.incrementReps,
                      onDecrementWork: state.decrementWork,
                      onIncrementWork: state.incrementWork,
                      onDecrementRest: state.decrementRest,
                      onIncrementRest: state.incrementRest,
                      onDecrementCooldown: state.decrementCooldown,
                      onIncrementCooldown: state.incrementCooldown,
                    ),

                  // Panneau ADVANCED (placeholder vide pour l'instant)
                  if (state.viewMode == ViewMode.advanced)
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Mode avancé - À venir',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Affichage total fixé en bas
          PresetTotalDisplay(
            formattedTotal: state.formattedTotal,
          ),
        ],
      ),
    );
  }

  /// Ferme l'écran sans sauvegarder
  void _close(BuildContext context, PresetEditorState state) {
    state.close();
    Navigator.of(context).pop();
  }

  /// Sauvegarde le préréglage et ferme l'écran
  void _save(BuildContext context, PresetEditorState state) {
    try {
      state.save();
      Navigator.of(context).pop();
    } catch (e) {
      // Afficher un message d'erreur si la sauvegarde échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}

