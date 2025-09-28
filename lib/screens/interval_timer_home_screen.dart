import 'package:flutter/material.dart';
import '../models/timer_configuration.dart';
import '../models/timer_preset.dart';
import '../services/preset_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/duration_formatter.dart';
import '../widgets/value_control.dart';
import '../widgets/section_header.dart';
import '../widgets/preset_card.dart';

/// Écran principal de l'application Interval Timer
class IntervalTimerHomeScreen extends StatefulWidget {
  const IntervalTimerHomeScreen({super.key});

  @override
  State<IntervalTimerHomeScreen> createState() => _IntervalTimerHomeScreenState();
}

class _IntervalTimerHomeScreenState extends State<IntervalTimerHomeScreen> {
  // Configuration actuelle
  int _repetitions = 16;
  Duration _workDuration = const Duration(seconds: 44);
  Duration _restDuration = const Duration(seconds: 15);
  
  // État UI
  double _volumeLevel = 0.62;
  bool _quickStartExpanded = true;
  
  // Données
  List<TimerPreset> _presets = [];
  bool _presetsLoading = true;
  
  final PresetStorageService _presetService = PresetStorageService.instance;

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    setState(() => _presetsLoading = true);
    final presets = await _presetService.loadPresets();
    setState(() {
      _presets = presets;
      _presetsLoading = false;
    });
  }

  TimerConfiguration get _currentConfiguration => TimerConfiguration(
    repetitions: _repetitions,
    workDuration: _workDuration,
    restDuration: _restDuration,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              child: Column(
                children: [
                  _buildQuickStartCard(),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildPresetsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 88,
      color: AppColors.headerBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: SafeArea(
        child: Row(
          children: [
            // Icône volume
            IconButton(
              onPressed: _onVolumeToggle,
              icon: const Icon(Icons.volume_up),
              color: AppColors.onPrimary,
              tooltip: 'Régler le volume',
            ),
            
            // Slider volume
            Expanded(
              child: Slider(
                value: _volumeLevel,
                onChanged: _onVolumeChanged,
                activeColor: AppColors.sliderActive,
                inactiveColor: AppColors.sliderInactive,
              ),
            ),
            
            // Indicateur volume
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.onPrimary,
                shape: BoxShape.circle,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingMd),
            
            // Menu
            IconButton(
              onPressed: _onMenuPressed,
              icon: const Icon(Icons.more_vert),
              color: AppColors.onPrimary,
              tooltip: 'Plus d\'options',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          children: [
            // En-tête
            CollapsibleSectionHeader(
              title: 'Démarrage rapide',
              isExpanded: _quickStartExpanded,
              onToggle: _onToggleQuickStart,
              toggleAriaLabel: _quickStartExpanded 
                ? 'Replier la section Démarrage rapide'
                : 'Déplier la section Démarrage rapide',
            ),
            
            if (_quickStartExpanded) ...[
              const SizedBox(height: AppTheme.spacingMd),
              
              // Contrôles de valeurs
              ValueControl(
                label: 'Répétitions',
                value: _repetitions.toString(),
                onDecrement: _onDecrementRepetitions,
                onIncrement: _onIncrementRepetitions,
                decrementAriaLabel: 'Diminuer les répétitions',
                incrementAriaLabel: 'Augmenter les répétitions',
              ),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              ValueControl(
                label: 'Travail',
                value: DurationFormatter.formatDuration(_workDuration),
                onDecrement: _onDecrementWork,
                onIncrement: _onIncrementWork,
                decrementAriaLabel: 'Diminuer le temps de travail',
                incrementAriaLabel: 'Augmenter le temps de travail',
              ),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              ValueControl(
                label: 'Repos',
                value: DurationFormatter.formatDuration(_restDuration),
                onDecrement: _onDecrementRest,
                onIncrement: _onIncrementRest,
                decrementAriaLabel: 'Diminuer le temps de repos',
                incrementAriaLabel: 'Augmenter le temps de repos',
              ),
              
              const SizedBox(height: AppTheme.spacingLg),
              
              // Actions
              Row(
                children: [
                  const Spacer(),
                  
                  // Bouton sauvegarder
                  TextButton.icon(
                    onPressed: _onSavePreset,
                    icon: const Icon(Icons.save),
                    label: const Text('SAUVEGARDER'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingMd),
              
              // Bouton commencer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onStartTimer,
                  icon: const Icon(Icons.bolt, color: AppColors.accent),
                  label: const Text('COMMENCER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cta,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsSection() {
    return Column(
      children: [
        // En-tête section préréglages
        SectionHeader(
          title: 'Vos préréglages',
          uppercase: true,
          leadingAction: IconButton(
            onPressed: _onEditPresets,
            icon: const Icon(Icons.edit),
            color: AppColors.textSecondary,
            tooltip: 'Éditer les préréglages',
            splashRadius: 12,
          ),
          trailingAction: OutlinedButton.icon(
            onPressed: _onAddPreset,
            icon: const Icon(Icons.add),
            label: const Text('AJOUTER'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingMd),
        
        // Liste des préréglages
        _buildPresetsList(),
      ],
    );
  }

  Widget _buildPresetsList() {
    if (_presetsLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_presets.isEmpty) {
      return EmptyPresetCard(
        onAddPreset: _onAddPreset,
      );
    }
    
    return Column(
      children: _presets.map((preset) => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        child: PresetCard(
          preset: preset,
          onTap: () => _onSelectPreset(preset),
        ),
      )).toList(),
    );
  }

  // Actions volume
  void _onVolumeChanged(double value) {
    setState(() => _volumeLevel = value);
  }

  void _onVolumeToggle() {
    setState(() => _volumeLevel = _volumeLevel > 0 ? 0 : 0.62);
  }

  void _onMenuPressed() {
    // TODO: Implémenter navigation vers paramètres
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu - À implémenter')),
    );
  }

  // Actions démarrage rapide
  void _onToggleQuickStart() {
    setState(() => _quickStartExpanded = !_quickStartExpanded);
  }

  void _onDecrementRepetitions() {
    if (_repetitions > 1) {
      setState(() => _repetitions--);
    }
  }

  void _onIncrementRepetitions() {
    setState(() => _repetitions++);
  }

  void _onDecrementWork() {
    setState(() {
      _workDuration = DurationFormatter.smartDecrement(_workDuration);
    });
  }

  void _onIncrementWork() {
    setState(() {
      _workDuration = DurationFormatter.smartIncrement(_workDuration);
    });
  }

  void _onDecrementRest() {
    setState(() {
      _restDuration = DurationFormatter.smartDecrement(_restDuration);
    });
  }

  void _onIncrementRest() {
    setState(() {
      _restDuration = DurationFormatter.smartIncrement(_restDuration);
    });
  }

  Future<void> _onSavePreset() async {
    if (!_currentConfiguration.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration invalide')),
      );
      return;
    }

    // Générer un nom unique
    final baseName = 'Configuration ${DateTime.now().day}/${DateTime.now().month}';
    final uniqueName = await _presetService.generateUniqueName(baseName);
    
    final preset = _presetService.createPreset(
      name: uniqueName,
      configuration: _currentConfiguration,
    );
    
    final success = await _presetService.addPreset(preset);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préréglage sauvegardé')),
      );
      _loadPresets();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la sauvegarde')),
      );
    }
  }

  void _onStartTimer() {
    if (!_currentConfiguration.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration invalide')),
      );
      return;
    }

    // TODO: Implémenter navigation vers écran timer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Démarrage timer: ${_repetitions}x ${DurationFormatter.formatDuration(_workDuration)}/${DurationFormatter.formatDuration(_restDuration)}',
        ),
      ),
    );
  }

  // Actions préréglages
  void _onEditPresets() {
    // TODO: Implémenter mode édition
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Édition préréglages - À implémenter')),
    );
  }

  void _onAddPreset() {
    // TODO: Implémenter navigation vers éditeur préréglage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ajout préréglage - À implémenter')),
    );
  }

  void _onSelectPreset(TimerPreset preset) {
    setState(() {
      _repetitions = preset.configuration.repetitions;
      _workDuration = preset.configuration.workDuration;
      _restDuration = preset.configuration.restDuration;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Préréglage "${preset.name}" chargé')),
    );
  }
}
