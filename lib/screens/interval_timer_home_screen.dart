import 'package:flutter/material.dart';
import '../models/timer_configuration.dart';
import '../models/timer_preset.dart';
import '../services/preset_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/duration_formatter.dart';
import '../widgets/value_control.dart';
import '../widgets/preset_card.dart';
import '../widgets/section_header.dart';

class IntervalTimerHomeScreen extends StatefulWidget {
  const IntervalTimerHomeScreen({super.key});

  @override
  State<IntervalTimerHomeScreen> createState() => _IntervalTimerHomeScreenState();
}

class _IntervalTimerHomeScreenState extends State<IntervalTimerHomeScreen> {
  double _volumeLevel = 0.62;
  TimerConfiguration _currentConfig = TimerConfiguration.defaultConfig;
  List<TimerPreset> _presets = [];
  bool _isQuickStartExpanded = true;
  final PresetStorageService _storageService = PresetStorageService();

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    final presets = await _storageService.loadPresets();
    setState(() {
      _presets = presets;
    });
  }

  void _updateRepetitions(int delta) {
    final newValue = _currentConfig.repetitions + delta;
    if (newValue >= 1) {
      setState(() {
        _currentConfig = _currentConfig.copyWith(repetitions: newValue);
      });
    }
  }

  void _updateWorkDuration(int deltaSeconds) {
    final newDuration = deltaSeconds > 0
        ? DurationFormatter.incrementDuration(_currentConfig.workDuration, deltaSeconds)
        : DurationFormatter.decrementDuration(_currentConfig.workDuration, -deltaSeconds);
    
    setState(() {
      _currentConfig = _currentConfig.copyWith(workDuration: newDuration);
    });
  }

  void _updateRestDuration(int deltaSeconds) {
    final newDuration = deltaSeconds > 0
        ? DurationFormatter.incrementDuration(_currentConfig.restDuration, deltaSeconds)
        : DurationFormatter.decrementDuration(_currentConfig.restDuration, -deltaSeconds);
    
    setState(() {
      _currentConfig = _currentConfig.copyWith(restDuration: newDuration);
    });
  }

  void _updateVolume(double value) {
    setState(() {
      _volumeLevel = value;
    });
  }

  Future<void> _saveCurrentAsPreset() async {
    if (!_currentConfig.isValid) return;

    final preset = TimerPreset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Préréglage ${_presets.length + 1}',
      configuration: _currentConfig,
      createdAt: DateTime.now(),
    );

    await _storageService.addPreset(preset);
    await _loadPresets();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préréglage sauvegardé')),
      );
    }
  }

  void _startTimer() {
    if (!_currentConfig.isValid) return;
    
    // TODO: Navigate to timer screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Démarrage de l\'entraînement: ${_currentConfig.repetitions} répétitions, '
          '${DurationFormatter.formatDuration(_currentConfig.workDuration)} travail, '
          '${DurationFormatter.formatDuration(_currentConfig.restDuration)} repos',
        ),
      ),
    );
  }

  void _loadPreset(TimerPreset preset) {
    setState(() {
      _currentConfig = preset.configuration;
    });
  }

  void _addNewPreset() {
    // TODO: Navigate to preset creation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Création de nouveau préréglage')),
    );
  }

  void _editPresets() {
    // TODO: Navigate to presets management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Édition des préréglages')),
    );
  }

  void _openSettings() {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ouverture des paramètres')),
    );
  }

  void _toggleQuickStart() {
    setState(() {
      _isQuickStartExpanded = !_isQuickStartExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: AppTheme.getSpacing('xs')),
              _buildQuickStartSection(),
              SizedBox(height: AppTheme.getSpacing('sm')),
              _buildPresetsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      key: const Key('interval_timer_home__Container-1'),
      color: AppColors.headerBackgroundDark,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getSpacing('md'),
        vertical: AppTheme.getSpacing('sm'),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            key: const Key('interval_timer_home__IconButton-2'),
            onPressed: () {}, // Volume control
            icon: const Icon(Icons.volume_up),
            color: AppColors.onPrimary,
            padding: EdgeInsets.all(AppTheme.getSpacing('xs')),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.getSpacing('md')),
              child: SliderTheme(
                data: Theme.of(context).sliderTheme,
                child: Slider(
                  key: const Key('interval_timer_home__Slider-3'),
                  value: _volumeLevel,
                  onChanged: _updateVolume,
                ),
              ),
            ),
          ),
          const Icon(
            key: Key('interval_timer_home__Icon-4'),
            Icons.circle,
            color: AppColors.onPrimary,
            size: 16,
          ),
          SizedBox(width: AppTheme.getSpacing('md')),
          IconButton(
            key: const Key('interval_timer_home__IconButton-5'),
            onPressed: _openSettings,
            icon: const Icon(Icons.more_vert),
            color: AppColors.onPrimary,
            padding: EdgeInsets.all(AppTheme.getSpacing('xs')),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.getSpacing('sm')),
      child: Card(
        key: const Key('interval_timer_home__Card-6'),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.getSpacing('md')),
          child: Column(
            children: [
              SectionHeader(
                title: 'Démarrage rapide',
                isExpanded: _isQuickStartExpanded,
                onToggle: _toggleQuickStart,
                toggleKey: 'interval_timer_home__IconButton-9',
              ),
              if (_isQuickStartExpanded) ...[
                SizedBox(height: AppTheme.getSpacing('md')),
                _buildValueControls(),
                SizedBox(height: AppTheme.getSpacing('lg')),
                _buildQuickStartActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueControls() {
    return Column(
      children: [
        ValueControl(
          label: 'Répétitions',
          value: _currentConfig.repetitions.toString(),
          onDecrease: () => _updateRepetitions(-1),
          onIncrease: () => _updateRepetitions(1),
          decreaseKey: 'interval_timer_home__repetitions_decrease',
          valueKey: 'interval_timer_home__repetitions_value',
          increaseKey: 'interval_timer_home__repetitions_increase',
        ),
        SizedBox(height: AppTheme.getSpacing('lg')),
        ValueControl(
          label: 'Travail',
          value: DurationFormatter.formatDuration(_currentConfig.workDuration),
          onDecrease: () => _updateWorkDuration(-1),
          onIncrease: () => _updateWorkDuration(1),
          decreaseKey: 'interval_timer_home__work_decrease',
          valueKey: 'interval_timer_home__work_value',
          increaseKey: 'interval_timer_home__work_increase',
        ),
        SizedBox(height: AppTheme.getSpacing('lg')),
        ValueControl(
          label: 'Repos',
          value: DurationFormatter.formatDuration(_currentConfig.restDuration),
          onDecrease: () => _updateRestDuration(-1),
          onIncrease: () => _updateRestDuration(1),
          decreaseKey: 'interval_timer_home__rest_decrease',
          valueKey: 'interval_timer_home__rest_value',
          increaseKey: 'interval_timer_home__rest_increase',
        ),
      ],
    );
  }

  Widget _buildQuickStartActions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              key: const Key('interval_timer_home__save_button'),
              onPressed: _currentConfig.isValid ? _saveCurrentAsPreset : null,
              icon: const Icon(Icons.save),
              label: const Text('SAUVEGARDER'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.getSpacing('sm')),
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton.icon(
            key: const Key('interval_timer_home__start_button'),
            onPressed: _currentConfig.isValid ? _startTimer : null,
            icon: const Icon(Icons.bolt, color: AppColors.accent),
            label: const Text('COMMENCER'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cta,
              foregroundColor: AppColors.onPrimary,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.getRadius('md')),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.getSpacing('sm')),
      child: Column(
        children: [
          PresetsSectionHeader(
            onAdd: _addNewPreset,
            onEdit: _editPresets,
          ),
          SizedBox(height: AppTheme.getSpacing('sm')),
          if (_presets.isEmpty)
            _buildEmptyPresets()
          else
            _buildPresetsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyPresets() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.getSpacing('xl')),
        child: Column(
          children: [
            Icon(
              Icons.timer,
              size: 48,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppTheme.getSpacing('md')),
            Text(
              'Aucun préréglage',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.getSpacing('xs')),
            Text(
              'Créez votre premier préréglage en sauvegardant une configuration',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsList() {
    return Column(
      children: _presets.map((preset) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppTheme.getSpacing('sm')),
          child: PresetCard(
            preset: preset,
            onTap: () => _loadPreset(preset),
          ),
        );
      }).toList(),
    );
  }
}
