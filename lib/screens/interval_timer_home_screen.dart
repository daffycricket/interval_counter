import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/interval_timer_home_state.dart';
import '../theme/app_colors.dart';
import '../widgets/home/volume_header.dart';
import '../widgets/home/quick_start_card.dart';
import '../widgets/home/presets_header.dart';
import '../widgets/home/preset_card.dart';

/// Écran principal de l'application Interval Timer
class IntervalTimerHomeScreen extends StatelessWidget {
  const IntervalTimerHomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<IntervalTimerHomeState>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec contrôle de volume
              const VolumeHeader(),
              
              const SizedBox(height: 8),
              
              // Carte de configuration rapide
              QuickStartCard(
                onStart: () => _startInterval(context),
                onSave: () => _savePreset(context),
              ),
              
              const SizedBox(height: 16),
              
              // En-tête de la section préréglages
              PresetsHeader(
                onAdd: () => _createNewPreset(context),
              ),
              
              const SizedBox(height: 8),
              
              // Liste des préréglages
              if (state.presets.isEmpty)
                _buildEmptyState()
              else
                ...state.presets.map((preset) => PresetCard(
                  preset: preset,
                  onTap: () => _loadPreset(context, preset.id),
                  onDelete: state.presetsEditMode
                      ? () => _deletePreset(context, preset.id)
                      : null,
                )),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(
          'Aucun préréglage sauvegardé.\nAppuyez sur + AJOUTER pour créer.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  void _startInterval(BuildContext context) {
    final state = context.read<IntervalTimerHomeState>();
    
    // TODO: Navigation vers /timer_running
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Démarrage: ${state.reps} reps, ${state.workSeconds}s travail, ${state.restSeconds}s repos',
        ),
      ),
    );
  }
  
  Future<void> _savePreset(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _SavePresetDialog(),
    );
    
    if (result != null && result.isNotEmpty && context.mounted) {
      try {
        await context.read<IntervalTimerHomeState>().saveCurrentAsPreset(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Préréglage sauvegardé')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }
  
  void _loadPreset(BuildContext context, String presetId) {
    try {
      context.read<IntervalTimerHomeState>().loadPreset(presetId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préréglage chargé')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }
  
  Future<void> _deletePreset(BuildContext context, String presetId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le préréglage'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce préréglage ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ANNULER'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('SUPPRIMER'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && context.mounted) {
      try {
        await context.read<IntervalTimerHomeState>().deletePreset(presetId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Préréglage supprimé')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }
  
  void _createNewPreset(BuildContext context) {
    // TODO: Navigation vers /preset_editor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Création de préréglage (à implémenter)')),
    );
  }
}

/// Dialogue pour sauvegarder un préréglage
class _SavePresetDialog extends StatefulWidget {
  @override
  State<_SavePresetDialog> createState() => _SavePresetDialogState();
}

class _SavePresetDialogState extends State<_SavePresetDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sauvegarder le préréglage'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nom du préréglage',
            hintText: 'Ex: Gainage, Cardio...',
          ),
          maxLength: 50,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le nom ne peut pas être vide';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ANNULER'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _controller.text.trim());
            }
          },
          child: const Text('SAUVEGARDER'),
        ),
      ],
    );
  }
}

