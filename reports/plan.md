# Plan de construction - Interval Timer Home

## Widget Inventory

### Widgets Flutter nécessaires
1. **Scaffold** - Structure principale de l'écran
2. **AppBar** - Barre supérieure avec contrôles volume et menu
3. **Column** - Layout vertical principal
4. **Card** - Conteneurs pour sections (démarrage rapide, préréglages)
5. **Row** - Layouts horizontaux (en-têtes, contrôles de valeurs)
6. **IconButton** - Boutons d'icônes (volume, menu, +/-, édition)
7. **ElevatedButton** - Bouton principal COMMENCER (variant cta)
8. **OutlinedButton** - Bouton + AJOUTER (variant secondary)
9. **TextButton** - Bouton SAUVEGARDER (variant ghost)
10. **Text** - Tous les libellés et valeurs
11. **Slider** - Contrôle de volume
12. **Container** - Groupes et espacements
13. **Expanded/Flexible** - Gestion des largeurs
14. **Align** - Placement des éléments
15. **ConstrainedBox** - Contraintes de largeur maximale

### Composants custom nécessaires
1. **ValueControl** - Widget réutilisable pour répétitions/travail/repos
2. **PresetCard** - Widget pour afficher un préréglage
3. **SectionHeader** - Widget pour les en-têtes de sections

## State & Actions

### État de l'écran (StatefulWidget)
```dart
class IntervalTimerHomeState extends State<IntervalTimerHome> {
  // Configuration actuelle
  int repetitions = 16;
  Duration workDuration = Duration(seconds: 44);
  Duration restDuration = Duration(seconds: 15);
  
  // État UI
  double volumeLevel = 0.62;
  bool quickStartExpanded = true;
  
  // Données
  List<TimerPreset> presets = [];
}
```

### Actions utilisateur
1. **Volume**
   - `onVolumeChanged(double value)` - Mise à jour du volume
   - `onVolumeToggle()` - Basculer muet/son

2. **Menu**
   - `onMenuPressed()` - Ouvrir menu contextuel

3. **Démarrage rapide**
   - `onToggleQuickStart()` - Replier/déplier section
   - `onRepetitionsChanged(int delta)` - Modifier répétitions (+/-)
   - `onWorkDurationChanged(Duration delta)` - Modifier temps travail
   - `onRestDurationChanged(Duration delta)` - Modifier temps repos
   - `onSavePreset()` - Sauvegarder configuration actuelle
   - `onStartTimer()` - Démarrer le timer

4. **Préréglages**
   - `onEditPresets()` - Mode édition des préréglages
   - `onAddPreset()` - Créer nouveau préréglage
   - `onSelectPreset(TimerPreset preset)` - Charger préréglage
   - `onDeletePreset(TimerPreset preset)` - Supprimer préréglage

### Navigation
- `Navigator.pushNamed(context, '/timer')` - Vers écran timer
- `Navigator.pushNamed(context, '/preset-editor')` - Vers éditeur préréglage
- `Navigator.pushNamed(context, '/settings')` - Vers paramètres

## Keys

### Keys pour tests
```dart
// Écran principal
static const Key homeScreenKey = Key('interval_timer_home');

// Contrôles volume
static const Key volumeIconKey = Key('volume_icon_button');
static const Key volumeSliderKey = Key('volume_slider');
static const Key menuButtonKey = Key('menu_button');

// Section démarrage rapide
static const Key quickStartCardKey = Key('quick_start_card');
static const Key quickStartToggleKey = Key('quick_start_toggle');
static const Key repetitionsControlKey = Key('repetitions_control');
static const Key workControlKey = Key('work_control');
static const Key restControlKey = Key('rest_control');
static const Key savePresetButtonKey = Key('save_preset_button');
static const Key startTimerButtonKey = Key('start_timer_button');

// Section préréglages
static const Key presetsHeaderKey = Key('presets_header');
static const Key editPresetsButtonKey = Key('edit_presets_button');
static const Key addPresetButtonKey = Key('add_preset_button');

// Préréglages individuels
static Key presetCardKey(String presetId) => Key('preset_card_$presetId');
```

## Tests

### Tests unitaires
1. **State management**
   ```dart
   test('should update repetitions correctly', () {
     // Test incrémentation/décrémentation répétitions
   });
   
   test('should format duration correctly', () {
     // Test formatage mm:ss
   });
   
   test('should calculate total duration', () {
     // Test calcul durée totale
   });
   ```

2. **Validation**
   ```dart
   test('should validate minimum values', () {
     // Test valeurs minimales (répétitions ≥ 1, durées ≥ 00:01)
   });
   ```

### Tests de widgets
1. **Composants individuels**
   ```dart
   testWidgets('ValueControl should increment/decrement', (tester) async {
     // Test widget ValueControl
   });
   
   testWidgets('PresetCard should display correctly', (tester) async {
     // Test affichage carte préréglage
   });
   ```

2. **Intégration écran**
   ```dart
   testWidgets('should start timer with correct values', (tester) async {
     // Test lancement timer avec valeurs configurées
   });
   
   testWidgets('should save preset correctly', (tester) async {
     // Test sauvegarde préréglage
   });
   ```

### Tests d'accessibilité
```dart
testWidgets('should have correct semantics', (tester) async {
  // Vérifier ariaLabel sur tous les boutons
  // Vérifier contraste des couleurs
  // Vérifier taille minimale des cibles (44px)
});
```

## Files to Generate

### Structure des fichiers
```
lib/
├── main.dart (mise à jour)
├── screens/
│   └── interval_timer_home_screen.dart
├── widgets/
│   ├── value_control.dart
│   ├── preset_card.dart
│   └── section_header.dart
├── models/
│   ├── timer_configuration.dart
│   └── timer_preset.dart
├── services/
│   └── preset_storage_service.dart
├── theme/
│   ├── app_theme.dart
│   ├── app_colors.dart
│   └── app_text_styles.dart
└── utils/
    └── duration_formatter.dart

test/
├── unit/
│   ├── timer_configuration_test.dart
│   └── timer_preset_test.dart
└── widget/
    ├── interval_timer_home_screen_test.dart
    ├── value_control_test.dart
    └── preset_card_test.dart
```

### Ordre de génération
1. **Models** - Structures de données de base
2. **Theme** - Système de thème basé sur design tokens
3. **Utils** - Utilitaires de formatage
4. **Services** - Persistance des préréglages
5. **Widgets** - Composants réutilisables
6. **Screen** - Écran principal
7. **Tests** - Tests unitaires et widgets
8. **Main** - Mise à jour point d'entrée

### Dépendances externes
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2  # Stockage préréglages
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### Configuration pubspec.yaml
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/icons/  # Si icônes custom nécessaires
```

## Considérations techniques

### Performance
- Utiliser `const` constructors où possible
- Éviter rebuilds inutiles avec `ValueListenableBuilder`
- Lazy loading pour liste préréglages si nombreux

### Accessibilité
- Implémenter `Semantics` widgets pour screen readers
- Respecter tailles minimales des cibles tactiles
- Contraste couleurs conforme WCAG 2.1 AA

### Responsive
- Utiliser `MediaQuery` pour adaptations écran
- Contraintes `maxWidth` pour grands écrans
- Gestion orientation portrait/paysage

### Localisation
- Préparer structure pour i18n future
- Externaliser tous les textes utilisateur
- Format durée selon locale système
