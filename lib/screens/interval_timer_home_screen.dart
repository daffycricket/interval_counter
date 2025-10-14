import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import '../state/interval_timer_home_state.dart';
import '../widgets/interval_timer_home/volume_header.dart';
import '../widgets/interval_timer_home/quick_start_section.dart';
import '../widgets/interval_timer_home/presets_section.dart';
import '../widgets/interval_timer_home/preset_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Main screen for IntervalTimerHome
/// Root composition of all widgets per plan.md § 5
class IntervalTimerHomeScreen extends StatefulWidget {
  const IntervalTimerHomeScreen({super.key});

  @override
  State<IntervalTimerHomeScreen> createState() => _IntervalTimerHomeScreenState();
}

class _IntervalTimerHomeScreenState extends State<IntervalTimerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<IntervalTimerHomeState>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Volume Header
                VolumeHeader(
                  volume: state.volume,
                  onVolumeToggle: state.toggleVolumePanel,
                  onVolumeChange: state.onVolumeChange,
                  onMoreOptions: _showMoreOptions,
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        // Quick Start Section
                        QuickStartSection(
                          expanded: state.quickStartExpanded,
                          reps: state.reps,
                          workSeconds: state.workSeconds,
                          restSeconds: state.restSeconds,
                          onToggleExpand: state.toggleQuickStartSection,
                          onIncrementReps: state.incrementReps,
                          onDecrementReps: state.decrementReps,
                          onIncrementWork: state.incrementWorkTime,
                          onDecrementWork: state.decrementWorkTime,
                          onIncrementRest: state.incrementRestTime,
                          onDecrementRest: state.decrementRestTime,
                          onSave: () => _showSavePresetDialog(context, state),
                          onStart: () => _startInterval(context, state),
                        ),

                        const SizedBox(height: 16),

                        // Presets Section Header
                        PresetsSection(
                          onEdit: state.enterEditMode,
                          onAdd: () => _createNewPreset(context),
                        ),

                        const SizedBox(height: 12),

                        // Presets List
                        if (state.presets.isEmpty)
                          _buildEmptyState(l10n)
                        else
                          ...state.presets.map(
                            (preset) => PresetCard(
                              preset: preset,
                              onTap: () => _loadPreset(state, preset.id),
                              onDelete: () => _deletePreset(state, preset.id),
                              editMode: state.presetsEditMode,
                            ),
                          ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          l10n.emptyPresetsMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    // Show context menu (placeholder for future implementation)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('More options coming soon')),
    );
  }

  void _showSavePresetDialog(BuildContext context, IntervalTimerHomeState state) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.savePresetLabel),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Nom du préréglage',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.presetNameEmptyError)),
                );
                return;
              }

              try {
                await state.saveCurrentAsPreset(name);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.presetSavedSnackbar)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.saveFailed)),
                  );
                }
              }
            },
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
  }

  void _startInterval(BuildContext context, IntervalTimerHomeState state) {
    // Navigate to TimerRunning screen (placeholder)
    // TODO: Implement navigation when TimerRunning screen is ready
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting interval: ${state.reps} reps, '
          '${state.workSeconds}s work, ${state.restSeconds}s rest',
        ),
      ),
    );
  }

  void _createNewPreset(BuildContext context) {
    // Navigate to PresetEditor screen (placeholder)
    // TODO: Implement navigation when PresetEditor screen is ready
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new preset (PresetEditor coming soon)')),
    );
  }

  void _loadPreset(IntervalTimerHomeState state, String presetId) {
    try {
      state.loadPreset(presetId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preset loaded')),
      );

      // Scroll to top to show loaded values
      // Note: In production, implement scrolling to QuickStartSection
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loadPresetsError)),
      );
    }
  }

  void _deletePreset(IntervalTimerHomeState state, String presetId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le préréglage'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce préréglage ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await state.deletePreset(presetId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Préréglage supprimé')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
