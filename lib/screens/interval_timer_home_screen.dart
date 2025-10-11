import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/interval_timer_home_state.dart';
import '../state/presets_state.dart';
import '../models/preset.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/home/volume_header.dart';
import '../widgets/home/quick_start_card.dart';
import '../widgets/home/preset_card.dart';

/// Écran principal d'accueil du minuteur d'intervalles
class IntervalTimerHomeScreen extends StatelessWidget {
  const IntervalTimerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec contrôle de volume
              Consumer<IntervalTimerHomeState>(
                builder: (context, state, _) {
                  return VolumeHeader(
                    volume: state.volume,
                    onVolumeChanged: state.onVolumeChanged,
                    onOptionsPressed: () {
                      // TODO: Navigation vers menu d'options
                      debugPrint('Options pressed');
                    },
                  );
                },
              ),

              const SizedBox(height: 8),

              // Carte de démarrage rapide
              Consumer<IntervalTimerHomeState>(
                builder: (context, state, _) {
                  return QuickStartCard(
                    isExpanded: state.quickStartExpanded,
                    reps: state.reps,
                    workSeconds: state.workSeconds,
                    restSeconds: state.restSeconds,
                    onToggle: state.toggleQuickStartSection,
                    onIncrementReps: state.incrementReps,
                    onDecrementReps: state.decrementReps,
                    onIncrementWork: state.incrementWorkTime,
                    onDecrementWork: state.decrementWorkTime,
                    onIncrementRest: state.incrementRestTime,
                    onDecrementRest: state.decrementRestTime,
                    onSave: () => _showSavePresetDialog(context, state),
                    onStart: () => _startTimer(context, state),
                    formatSeconds: state.formatSeconds,
                    canDecrementReps: state.reps > IntervalTimerHomeState.minReps,
                    canIncrementReps: state.reps < IntervalTimerHomeState.maxReps,
                    canDecrementWork: state.workSeconds > IntervalTimerHomeState.minWorkSeconds,
                    canIncrementWork: state.workSeconds < IntervalTimerHomeState.maxSeconds,
                    canDecrementRest: state.restSeconds > IntervalTimerHomeState.minSeconds,
                    canIncrementRest: state.restSeconds < IntervalTimerHomeState.maxSeconds,
                  );
                },
              ),

              const SizedBox(height: 18),

              // Barre de titre des préréglages
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  key: const Key('interval_timer_home__Container-24'),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        'VOS PRÉRÉGLAGES',
                        key: Key('interval_timer_home__Text-25'),
                        style: AppTextStyles.title,
                      ),
                    ),
                    IconButton(
                      key: const Key('interval_timer_home__IconButton-26'),
                      icon: const Icon(Icons.edit),
                      color: AppColors.textSecondary,
                      iconSize: 24,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      onPressed: () {
                        // TODO: Entrer en mode édition
                        debugPrint('Edit mode');
                      },
                      tooltip: 'Éditer les préréglages',
                    ),
                    OutlinedButton.icon(
                      key: const Key('interval_timer_home__Button-27'),
                      onPressed: () => _createNewPreset(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.border,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: const Text(
                        '+ AJOUTER',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Liste des préréglages
              Consumer2<PresetsState, IntervalTimerHomeState>(
                builder: (context, presetsState, homeState, _) {
                  if (presetsState.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (presetsState.presets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Aucun préréglage. Créez-en un avec + AJOUTER',
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: presetsState.presets.map((preset) {
                      return PresetCard(
                        preset: preset,
                        onTap: () => _loadPreset(context, preset, homeState),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Affiche un dialogue pour sauvegarder un nouveau préréglage
  void _showSavePresetDialog(
    BuildContext context,
    IntervalTimerHomeState state,
  ) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sauvegarder le préréglage'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nom du préréglage',
              hintText: 'Ex: Gainage, Tabata, etc.',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final preset = Preset(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    repetitions: state.reps,
                    workSeconds: state.workSeconds,
                    restSeconds: state.restSeconds,
                    createdAt: DateTime.now(),
                  );

                  context.read<PresetsState>().savePreset(preset);
                  Navigator.of(dialogContext).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Préréglage sauvegardé'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  /// Démarre le minuteur avec la configuration actuelle
  void _startTimer(BuildContext context, IntervalTimerHomeState state) {
    if (!state.canStart) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuration invalide'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Navigation vers l'écran Timer
    debugPrint('Start timer: reps=${state.reps}, '
        'work=${state.workSeconds}, rest=${state.restSeconds}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Démarrage: ${state.reps} reps × '
          '(${state.formatSeconds(state.workSeconds)} + '
          '${state.formatSeconds(state.restSeconds)})',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Charge un préréglage
  void _loadPreset(
    BuildContext context,
    Preset preset,
    IntervalTimerHomeState homeState,
  ) {
    homeState.loadPresetConfig(
      preset.repetitions,
      preset.workSeconds,
      preset.restSeconds,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Préréglage "${preset.name}" chargé'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Crée un nouveau préréglage
  void _createNewPreset(BuildContext context) {
    // TODO: Navigation vers l'éditeur de préréglages
    debugPrint('Create new preset');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Éditeur de préréglages (à venir)'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

