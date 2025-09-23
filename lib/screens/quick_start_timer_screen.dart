import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/timer_configuration.dart';
import '../models/timer_preset.dart';
import '../services/preset_storage_service.dart';
import '../widgets/time_control.dart';
import '../widgets/value_control.dart';
import '../widgets/preset_card.dart';
import '../widgets/section_header.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';

/// Écran principal de configuration et lancement des timers d'intervalles
class QuickStartTimerScreen extends StatefulWidget {
  const QuickStartTimerScreen({super.key});

  @override
  State<QuickStartTimerScreen> createState() => _QuickStartTimerScreenState();
}

class _QuickStartTimerScreenState extends State<QuickStartTimerScreen> {
  // Configuration courante
  int _repetitions = 16;
  Duration _workTime = const Duration(seconds: 44);
  Duration _restTime = const Duration(seconds: 15);
  double _volume = 0.7;

  // Préréglages
  List<TimerPreset> _presets = [];
  final PresetStorageService _storageService = PresetStorageService();

  // État UI
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  /// Charge les préréglages depuis le stockage
  Future<void> _loadPresets() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Charger les données d'exemple si nécessaire
      await _storageService.loadSampleData();
      
      final presets = await _storageService.getPresets();
      
      if (mounted) {
        setState(() {
          _presets = presets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur lors du chargement des préréglages: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Configuration courante
  TimerConfiguration get _currentConfiguration => TimerConfiguration(
    repetitions: _repetitions,
    workTime: _workTime,
    restTime: _restTime,
  );

  /// Incrémente les répétitions
  void _incrementRepetitions() {
    if (_repetitions < 999) {
      setState(() {
        _repetitions++;
      });
      HapticFeedback.lightImpact();
    }
  }

  /// Décrémente les répétitions
  void _decrementRepetitions() {
    if (_repetitions > 1) {
      setState(() {
        _repetitions--;
      });
      HapticFeedback.lightImpact();
    }
  }

  /// Incrémente le temps de travail
  void _incrementWorkTime() {
    setState(() {
      _workTime = Duration(seconds: _workTime.inSeconds + 1);
    });
    HapticFeedback.lightImpact();
  }

  /// Décrémente le temps de travail
  void _decrementWorkTime() {
    if (_workTime.inSeconds > 1) {
      setState(() {
        _workTime = Duration(seconds: _workTime.inSeconds - 1);
      });
      HapticFeedback.lightImpact();
    }
  }

  /// Incrémente le temps de repos
  void _incrementRestTime() {
    setState(() {
      _restTime = Duration(seconds: _restTime.inSeconds + 1);
    });
    HapticFeedback.lightImpact();
  }

  /// Décrémente le temps de repos
  void _decrementRestTime() {
    if (_restTime.inSeconds > 1) {
      setState(() {
        _restTime = Duration(seconds: _restTime.inSeconds - 1);
      });
      HapticFeedback.lightImpact();
    }
  }

  /// Ajuste le volume
  void _setVolume(double value) {
    setState(() {
      _volume = value;
    });
  }

  /// Sauvegarde la configuration courante comme préréglage
  Future<void> _savePreset() async {
    final nameController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sauvegarder le préréglage'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nom du préréglage',
            hintText: 'Ex: Cardio intense',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context, name);
              }
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        // Vérifier si le nom existe déjà
        final nameExists = await _storageService.presetNameExists(result);
        if (nameExists) {
          _showErrorMessage('Un préréglage avec ce nom existe déjà');
          return;
        }

        final preset = TimerPreset(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result,
          configuration: _currentConfiguration,
          createdAt: DateTime.now(),
        );

        await _storageService.savePreset(preset);
        await _loadPresets();
        
        _showSuccessMessage('Préréglage sauvegardé avec succès');
      } catch (e) {
        _showErrorMessage('Erreur lors de la sauvegarde: $e');
      }
    }
  }

  /// Lance le timer avec la configuration courante
  Future<void> _startTimer() async {
    if (!_currentConfiguration.isValid) {
      _showErrorMessage('Configuration invalide');
      return;
    }

    // TODO: Navigation vers l'écran de timer actif
    // Pour la démonstration, on affiche juste un message
    _showSuccessMessage(
      'Timer démarré: ${_repetitions}x ${_formatDuration(_workTime)}/${_formatDuration(_restTime)}'
    );
  }

  /// Sélectionne un préréglage
  void _selectPreset(TimerPreset preset) {
    setState(() {
      _repetitions = preset.repetitions;
      _workTime = preset.workTime;
      _restTime = preset.restTime;
    });
    
    _showSuccessMessage('Préréglage "${preset.name}" sélectionné');
  }

  /// Ajoute un nouveau préréglage
  Future<void> _addPreset() async {
    // Pour la démonstration, utilise la configuration courante
    await _savePreset();
  }

  /// Supprime un préréglage
  Future<void> _deletePreset(TimerPreset preset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le préréglage'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${preset.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _storageService.deletePreset(preset.id);
        await _loadPresets();
        _showSuccessMessage('Préréglage supprimé');
      } catch (e) {
        _showErrorMessage('Erreur lors de la suppression: $e');
      }
    }
  }

  /// Affiche un message d'erreur
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Affiche un message de succès
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Formate une durée au format mm:ss
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('quick_start_timer__screen'),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec contrôles volume et menu
            _buildHeader(),
            
            // Contenu principal scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                child: Column(
                  children: [
                    // Section démarrage rapide
                    _buildQuickStartCard(),
                    
                    const SizedBox(height: AppTheme.spacingLg),
                    
                    // Bouton commencer
                    _buildStartButton(),
                    
                    const SizedBox(height: AppTheme.spacingLg),
                    
                    // Section préréglages
                    _buildPresetsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le header avec volume et menu
  Widget _buildHeader() {
    return Container(
      key: const Key('quick_start_timer__header'),
      color: AppColors.headerBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          // Icône volume
          IconButton(
            key: const Key('quick_start_timer__volume-btn'),
            onPressed: () {
              // TODO: Implémenter contrôle volume global
            },
            icon: const Icon(
              Icons.volume_up,
              color: AppColors.onPrimary,
            ),
            tooltip: 'volume',
          ),
          
          // Slider volume
          Expanded(
            child: Slider(
              key: const Key('quick_start_timer__volume-slider'),
              value: _volume,
              onChanged: _setVolume,
              activeColor: AppColors.sliderActive,
              inactiveColor: AppColors.sliderInactive,
            ),
          ),
          
          // Icône indicateur slider (décoratif)
          const Icon(
            Icons.circle,
            color: AppColors.onPrimary,
            size: 16,
          ),
          
          const SizedBox(width: AppTheme.spacingLg),
          
          // Menu
          IconButton(
            key: const Key('quick_start_timer__menu-btn'),
            onPressed: () {
              // TODO: Ouvrir menu paramètres
            },
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.onPrimary,
            ),
            tooltip: 'menu',
          ),
        ],
      ),
    );
  }

  /// Construit la carte de démarrage rapide
  Widget _buildQuickStartCard() {
    return Card(
      key: const Key('quick_start_timer__main-card'),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              'Démarrage rapide',
              key: const Key('quick_start_timer__title'),
              style: AppTextStyles.title,
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            // Contrôle répétitions
            ValueControl(
              label: 'RÉPÉTITIONS',
              value: _repetitions,
              onIncrement: _incrementRepetitions,
              onDecrement: _decrementRepetitions,
              decrementSemanticLabel: 'diminuer répétitions',
              incrementSemanticLabel: 'augmenter répétitions',
              valueSemanticLabel: 'répétitions',
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            // Contrôle temps de travail
            TimeControl(
              label: 'TRAVAIL',
              value: _workTime,
              onIncrement: _incrementWorkTime,
              onDecrement: _decrementWorkTime,
              decrementSemanticLabel: 'diminuer travail',
              incrementSemanticLabel: 'augmenter travail',
              valueSemanticLabel: 'de travail',
            ),
            
            const SizedBox(height: AppTheme.spacingMd),
            
            // Contrôle temps de repos
            TimeControl(
              label: 'REPOS',
              value: _restTime,
              onIncrement: _incrementRestTime,
              onDecrement: _decrementRestTime,
              decrementSemanticLabel: 'diminuer repos',
              incrementSemanticLabel: 'augmenter repos',
              valueSemanticLabel: 'de repos',
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Bouton sauvegarder
            OutlinedButton(
              key: const Key('quick_start_timer__save-btn'),
              onPressed: _savePreset,
              child: const Text('SAUVEGARDER'),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le bouton de démarrage
  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        key: const Key('quick_start_timer__start-btn'),
        onPressed: _startTimer,
        icon: const Icon(Icons.bolt),
        label: const Text('COMMENCER'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 56),
        ),
      ),
    );
  }

  /// Construit la section des préréglages
  Widget _buildPresetsSection() {
    return Column(
      children: [
        // Header des préréglages
        SectionHeader(
          title: 'VOS PRÉRÉGLAGES',
          actionButton: IconButton(
            key: const Key('quick_start_timer__add-preset-btn'),
            onPressed: _addPreset,
            icon: const Icon(Icons.add),
            tooltip: 'ajouter préréglage',
          ),
        ),
        
        // Liste des préréglages ou message si vide
        if (_isLoading)
          const CircularProgressIndicator()
        else if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          )
        else if (_presets.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Text(
              'Vous n\'avez pas encore créé de préréglage.\nUtilisez + Ajouter pour en créer un.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          )
        else
          ..._presets.map((preset) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
            child: PresetCard(
              preset: preset,
              onTap: () => _selectPreset(preset),
              onDelete: () => _deletePreset(preset),
            ),
          )),
      ],
    );
  }
}
