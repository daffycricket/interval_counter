import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/interval_timer_home_state.dart';
import '../state/presets_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/home/volume_header.dart';
import '../widgets/home/quick_start_card.dart';
import '../widgets/home/preset_card.dart';

/// Écran principal de configuration du minuteur d'intervalles
class IntervalTimerHomeScreen extends StatelessWidget {
  const IntervalTimerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IntervalTimerHomeState()),
        ChangeNotifierProvider(create: (_) => PresetsState()),
      ],
      child: const _IntervalTimerHomeScreenContent(),
    );
  }
}

class _IntervalTimerHomeScreenContent extends StatelessWidget {
  const _IntervalTimerHomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<IntervalTimerHomeState>();
    final presetsState = context.watch<PresetsState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // En-tête avec volume
          VolumeHeader(
            volumeLevel: homeState.volumeLevel,
            onVolumeChanged: homeState.setVolume,
            onVolumeButtonPressed: () {
              // TODO: Implémenter le comportement du bouton volume
              debugPrint('Volume button pressed');
            },
            onMenuPressed: () {
              // TODO: Implémenter le menu d'options
              _showOptionsMenu(context);
            },
          ),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Carte de démarrage rapide
                  QuickStartCard(
                    isExpanded: homeState.quickStartExpanded,
                    onToggleExpanded: homeState.toggleQuickStartSection,
                    repetitions: homeState.repetitions,
                    workTime: homeState.formattedWorkTime,
                    restTime: homeState.formattedRestTime,
                    onIncrementReps: homeState.incrementReps,
                    onDecrementReps: homeState.decrementReps,
                    onIncrementWork: homeState.incrementWork,
                    onDecrementWork: homeState.decrementWork,
                    onIncrementRest: homeState.incrementRest,
                    onDecrementRest: homeState.decrementRest,
                    canIncrementReps: homeState.canIncrementReps,
                    canDecrementReps: homeState.canDecrementReps,
                    canIncrementWork: homeState.canIncrementWork,
                    canDecrementWork: homeState.canDecrementWork,
                    canIncrementRest: homeState.canIncrementRest,
                    canDecrementRest: homeState.canDecrementRest,
                    onSavePreset: () => _onSavePreset(context),
                    onStartInterval: () => _onStartInterval(context),
                    isStartEnabled: homeState.isConfigValid,
                  ),

                  const SizedBox(height: 16),

                  // En-tête de la section préréglages
                  Container(
                    key: const Key('interval_timer_home__Container-24'),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'VOS PRÉRÉGLAGES',
                          style: AppTextStyles.title,
                        ),
                        Row(
                          children: [
                            // Bouton éditer
                            Semantics(
                              label: 'Éditer les préréglages',
                              button: true,
                              child: IconButton(
                                key: const Key('interval_timer_home__IconButton-26'),
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  homeState.enterEditMode();
                                  // TODO: Implémenter le mode édition
                                  debugPrint('Edit mode entered');
                                },
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                                iconSize: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Bouton ajouter
                            Semantics(
                              label: 'Ajouter un préréglage',
                              button: true,
                              child: OutlinedButton.icon(
                                key: const Key('interval_timer_home__Button-27'),
                                onPressed: () => _onAddPreset(context),
                                icon: const Icon(
                                  Icons.add,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                label: Text(
                                  '+ AJOUTER',
                                  style: AppTextStyles.buttonLabel.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Liste des préréglages
                  if (presetsState.presets.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'Aucun préréglage enregistré',
                          style: AppTextStyles.body,
                        ),
                      ),
                    )
                  else
                    ...presetsState.presets.map((preset) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PresetCard(
                          preset: preset,
                          onTap: () => _onSelectPreset(context, preset),
                        ),
                      );
                    }),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sauvegarde la configuration rapide comme préréglage
  void _onSavePreset(BuildContext context) {
    final homeState = context.read<IntervalTimerHomeState>();
    final presetsState = context.read<PresetsState>();

    // Dialogue pour saisir le nom du préréglage
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sauvegarder le préréglage'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nom du préréglage',
            hintText: 'Ex: Gainage, HIIT, etc.',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ANNULER'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                try {
                  await presetsState.createPreset(
                    name: name,
                    repetitions: homeState.repetitions,
                    workSeconds: homeState.workSeconds,
                    restSeconds: homeState.restSeconds,
                  );
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Préréglage "$name" sauvegardé'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de la sauvegarde'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('SAUVEGARDER'),
          ),
        ],
      ),
    );
  }

  /// Démarre un intervalle avec la configuration actuelle
  void _onStartInterval(BuildContext context) {
    final homeState = context.read<IntervalTimerHomeState>();
    
    // TODO: Navigation vers l'écran Timer
    debugPrint('Démarrage intervalle: reps=${homeState.repetitions}, '
        'work=${homeState.workSeconds}s, rest=${homeState.restSeconds}s');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Démarrage de l\'intervalle...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigation vers TimerScreen (à implémenter)
    // Navigator.of(context).pushNamed(
    //   '/timer',
    //   arguments: {
    //     'reps': homeState.repetitions,
    //     'work': homeState.workSeconds,
    //     'rest': homeState.restSeconds,
    //   },
    // );
  }

  /// Charge un préréglage dans la configuration rapide
  void _onSelectPreset(BuildContext context, preset) {
    final homeState = context.read<IntervalTimerHomeState>();
    
    homeState.loadPresetValues(
      repetitions: preset.repetitions,
      workSeconds: preset.workSeconds,
      restSeconds: preset.restSeconds,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Préréglage "${preset.name}" chargé'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Ouvre l'écran d'ajout de préréglage
  void _onAddPreset(BuildContext context) {
    // TODO: Navigation vers PresetEditor
    debugPrint('Ajouter un nouveau préréglage');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Éditeur de préréglage (à implémenter)'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigator.of(context).pushNamed('/preset-editor', arguments: {'mode': 'create'});
  }

  /// Affiche le menu d'options
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigation vers les paramètres
                debugPrint('Ouvrir les paramètres');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Afficher la page À propos
                debugPrint('À propos');
              },
            ),
          ],
        ),
      ),
    );
  }
}