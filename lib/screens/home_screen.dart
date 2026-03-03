import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/home_state.dart';
import '../widgets/home/volume_header.dart';
import '../widgets/home/quick_start_card.dart';
import '../widgets/home/presets_header.dart';
import '../widgets/home/preset_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../routes/app_routes.dart';
import 'package:interval_counter/l10n/app_localizations.dart';

/// Écran principal de l'application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeState>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VolumeHeader(
        volume: homeState.volume,
        onVolumeChange: homeState.onVolumeChange,
        onMenuPressed: () {
          // TODO: Navigation vers menu/settings
          debugPrint('Menu pressed');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Carte démarrage rapide
            QuickStartCard(
              expanded: homeState.quickStartExpanded,
              reps: homeState.reps,
              workTime: homeState.formattedWorkTime,
              restTime: homeState.formattedRestTime,
              onToggleExpanded: homeState.toggleQuickStart,
              onDecrementReps: homeState.decrementReps,
              onIncrementReps: homeState.incrementReps,
              onDecrementWork: homeState.decrementWork,
              onIncrementWork: homeState.incrementWork,
              onDecrementRest: homeState.decrementRest,
              onIncrementRest: homeState.incrementRest,
              onSave: () => _showSavePresetDialog(context, homeState),
              decreaseRepsEnabled: homeState.reps > HomeState.minReps,
              decreaseWorkEnabled: homeState.workSeconds > HomeState.maxWorkSeconds,
              decreaseRestEnabled: homeState.restSeconds > HomeState.minSeconds,
            ),

            // Bouton COMMENCER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                width: double.infinity,
                child: Semantics(
                  label: l10n.startIntervalLabel,
                  button: true,
                  child: ElevatedButton.icon(
                    key: const Key('home__Button-23'),
                    onPressed: () => _startInterval(context, homeState),
                    icon: const Icon(Icons.bolt, color: AppColors.accent),
                    label: Text(
                      l10n.startButton,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cta,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 1,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // En-tête préréglages
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: PresetsHeader(
                onEdit: homeState.editPresets,
                onAdd: () => _navigateToPresetEditor(context),
              ),
            ),

            const SizedBox(height: 8),

            // Liste des préréglages
            if (homeState.presets.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noPresetsMessage,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeState.presets.length,
                itemBuilder: (context, index) {
                  final preset = homeState.presets[index];
                  return PresetCard(
                    preset: preset,
                    onTap: () {
                      // TODO: Charger le préréglage dans Quick Start
                      debugPrint('Preset tapped: ${preset.name}');
                    },
                    onDelete: () => homeState.deletePreset(preset.id),
                  );
                },
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Navigation vers l'écran d'édition de préréglage (nouveau préréglage)
  void _navigateToPresetEditor(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.presetEditor,
      arguments: {
        'isEditMode': false,
      },
    );
  }

  /// Affiche le dialog de sauvegarde de préréglage
  void _showSavePresetDialog(BuildContext context, HomeState homeState) {
    _showPresetDialog(
      context: context,
      title: AppLocalizations.of(context)!.savePresetLabel,
      onSave: (name) => homeState.savePreset(name),
    );
  }

  /// Dialog générique pour saisie du nom de préréglage
  void _showPresetDialog({
    required BuildContext context,
    required String title,
    required Function(String) onSave,
  }) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.presetNamePrompt,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.presetNameError)),
                );
              } else {
                try {
                  onSave(name);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: Text(l10n.okButton),
          ),
        ],
      ),
    );
  }

  /// Lance l'intervalle avec les paramètres actuels
  void _startInterval(BuildContext context, HomeState homeState) {
    // TODO: Navigation vers écran Timer avec paramètres
    debugPrint('Starting interval: '
        'reps=${homeState.reps}, '
        'work=${homeState.workSeconds}s, '
        'rest=${homeState.restSeconds}s');

    // Pour le moment, on affiche juste un message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Interval: ${homeState.reps} reps, '
          '${homeState.formattedWorkTime} work, '
          '${homeState.formattedRestTime} rest',
        ),
      ),
    );
  }
}

