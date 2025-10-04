import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/interval_timer_home_state.dart';
import '../widgets/interval_timer/volume_control_header.dart';
import '../widgets/interval_timer/quick_start_card.dart';
import '../widgets/interval_timer/preset_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Écran principal de l'application Interval Timer
class IntervalTimerHomeScreen extends StatefulWidget {
  const IntervalTimerHomeScreen({super.key});

  @override
  State<IntervalTimerHomeScreen> createState() => _IntervalTimerHomeScreenState();
}

class _IntervalTimerHomeScreenState extends State<IntervalTimerHomeScreen> {
  late IntervalTimerHomeState _state;

  @override
  void initState() {
    super.initState();
    _state = IntervalTimerHomeState();
    _state.initialize();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _showSavePresetDialog() {
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
            counterText: '30 caractères max',
          ),
          maxLength: 30,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ANNULER'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Le nom ne peut pas être vide'),
                  ),
                );
                return;
              }
              
              try {
                await _state.saveQuickStartAsPreset(name);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Préréglage "$name" sauvegardé'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: $e'),
                    ),
                  );
                }
              }
            },
            child: const Text('SAUVEGARDER'),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu() {
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
                // TODO: Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show about dialog
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startInterval() {
    if (!_state.validateConfig()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuration invalide'),
        ),
      );
      return;
    }

    // TODO: Navigate to /timer with params
    // Navigator.of(context).pushNamed(
    //   '/timer',
    //   arguments: {
    //     'repetitions': _state.repetitions,
    //     'workSeconds': _state.workSeconds,
    //     'restSeconds': _state.restSeconds,
    //   },
    // );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Démarrage: ${_state.repetitions} rép, '
          '${_state.workSeconds}s travail, ${_state.restSeconds}s repos',
        ),
      ),
    );
  }

  void _startIntervalFromPreset(String presetId) {
    final preset = _state.presetsList.firstWhere((p) => p.id == presetId);
    
    // TODO: Navigate to /timer with preset config
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Démarrage du préréglage: ${preset.name}'),
      ),
    );
  }

  void _addNewPreset() {
    // TODO: Navigate to /preset/new
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation vers création de préréglage'),
      ),
    );
  }

  void _deletePreset(String presetId) {
    final preset = _state.presetsList.firstWhere((p) => p.id == presetId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le préréglage'),
        content: Text('Voulez-vous vraiment supprimer "${preset.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ANNULER'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _state.deletePreset(presetId);
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Préréglage supprimé'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('SUPPRIMER'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IntervalTimerHomeState>.value(
      value: _state,
      child: Scaffold(
        body: SafeArea(
          child: Consumer<IntervalTimerHomeState>(
            builder: (context, state, child) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header avec contrôle de volume
                    VolumeControlHeader(
                      volumeLevel: state.volumeLevel,
                      onVolumeChanged: state.setVolume,
                      onVolumeButtonTap: () {
                        // TODO: Toggle volume popup (simplification IT1)
                      },
                      onMoreOptionsTap: _showOptionsMenu,
                    ),

                    const SizedBox(height: 8),

                    // Carte Quick Start
                    QuickStartCard(
                      isExpanded: state.quickStartExpanded,
                      onToggleExpanded: state.toggleQuickStartExpanded,
                      repetitions: state.repetitions,
                      workSeconds: state.workSeconds,
                      restSeconds: state.restSeconds,
                      onDecrementRepetitions: state.decrementRepetitions,
                      onIncrementRepetitions: state.incrementRepetitions,
                      onDecrementWorkTime: state.decrementWorkTime,
                      onIncrementWorkTime: state.incrementWorkTime,
                      onDecrementRestTime: state.decrementRestTime,
                      onIncrementRestTime: state.incrementRestTime,
                      canDecrementRepetitions: state.canDecrementRepetitions,
                      canIncrementRepetitions: state.canIncrementRepetitions,
                      canDecrementWorkTime: state.canDecrementWorkTime,
                      canIncrementWorkTime: state.canIncrementWorkTime,
                      canDecrementRestTime: state.canDecrementRestTime,
                      canIncrementRestTime: state.canIncrementRestTime,
                      onSave: _showSavePresetDialog,
                      onStart: _startInterval,
                    ),

                    const SizedBox(height: 10),

                    // Section préréglages
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        key: const Key('interval_timer_home__Container-24'),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'VOS PRÉRÉGLAGES',
                              key: const Key('interval_timer_home__Text-25'),
                              style: AppTextStyles.title.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Semantics(
                              label: 'Éditer les préréglages',
                              button: true,
                              child: IconButton(
                                key: const Key('interval_timer_home__IconButton-26'),
                                icon: const Icon(Icons.edit),
                                color: AppColors.textSecondary,
                                iconSize: 20,
                                onPressed: state.toggleEditMode,
                              ),
                            ),
                            const Spacer(),
                            Semantics(
                              label: 'Ajouter un préréglage',
                              button: true,
                              child: OutlinedButton.icon(
                                key: const Key('interval_timer_home__Button-27'),
                                onPressed: _addNewPreset,
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text('+ AJOUTER'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  textStyle: AppTextStyles.label.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Liste des préréglages
                    if (state.presetsList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 64,
                                color: AppColors.textSecondary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun préréglage sauvegardé',
                                style: AppTextStyles.body,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Créez votre premier préréglage en configurant un intervalle et en cliquant sur "SAUVEGARDER"',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...state.presetsList.map(
                        (preset) => PresetCard(
                          preset: preset,
                          onTap: () => _startIntervalFromPreset(preset.id),
                          showDeleteButton: state.editModeActive,
                          onDelete: () => _deletePreset(preset.id),
                        ),
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
