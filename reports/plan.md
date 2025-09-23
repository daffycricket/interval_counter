# Plan de construction - Écran Interval Timer

**Généré le** : 23 septembre 2025  
**Basé sur** : `home_design.json` + `spec.md`  
**Cible** : Flutter (Dart)

---

## 1. Inventaire des widgets par composant

### 1.1 Mapping design → Flutter widgets

| Component ID | Type Design | Widget Flutter | Key | Remarques |
|--------------|-------------|----------------|-----|-----------|
| container-1 | Container | Container + Row | `Key('quick_start_timer__header')` | Header avec layout flex |
| iconbutton-1 | IconButton | IconButton | `Key('quick_start_timer__volume-btn')` | Volume control |
| slider-1 | Slider | Slider | `Key('quick_start_timer__volume-slider')` | Custom track styling |
| icon-2 | Icon | Icon | `Key('quick_start_timer__slider-thumb')` | Thumb indicator |
| iconbutton-2 | IconButton | IconButton | `Key('quick_start_timer__menu-btn')` | Menu trigger |
| card-1 | Card | Card + Column | `Key('quick_start_timer__main-card')` | Section démarrage rapide |
| text-1 | Text | Text | `Key('quick_start_timer__title')` | "Démarrage rapide" |
| text-2 | Text | Text | `Key('quick_start_timer__reps-label')` | "RÉPÉTITIONS" |
| iconbutton-3 | IconButton | IconButton | `Key('quick_start_timer__reps-minus')` | Décrémenter répétitions |
| text-3 | Text | Text | `Key('quick_start_timer__reps-value')` | Valeur répétitions |
| iconbutton-4 | IconButton | IconButton | `Key('quick_start_timer__reps-plus')` | Incrémenter répétitions |
| text-4 | Text | Text | `Key('quick_start_timer__work-label')` | "TRAVAIL" |
| iconbutton-5 | IconButton | IconButton | `Key('quick_start_timer__work-minus')` | Décrémenter travail |
| text-5 | Text | Text | `Key('quick_start_timer__work-value')` | Valeur temps travail |
| iconbutton-6 | IconButton | IconButton | `Key('quick_start_timer__work-plus')` | Incrémenter travail |
| text-6 | Text | Text | `Key('quick_start_timer__rest-label')` | "REPOS" |
| iconbutton-7 | IconButton | IconButton | `Key('quick_start_timer__rest-minus')` | Décrémenter repos |
| text-7 | Text | Text | `Key('quick_start_timer__rest-value')` | Valeur temps repos |
| iconbutton-8 | IconButton | IconButton | `Key('quick_start_timer__rest-plus')` | Incrémenter repos |
| button-1 | Button | ElevatedButton | `Key('quick_start_timer__save-btn')` | Bouton sauvegarder |
| button-2 | Button | ElevatedButton | `Key('quick_start_timer__start-btn')` | Bouton commencer |
| container-2 | Container | Container + Row | `Key('quick_start_timer__presets-header')` | Header préréglages |
| text-8 | Text | Text | `Key('quick_start_timer__presets-title')` | "VOS PRÉRÉGLAGES" |
| iconbutton-9 | IconButton | IconButton | `Key('quick_start_timer__add-preset-btn')` | Ajouter préréglage |
| card-2 | Card | Card + Column | `Key('quick_start_timer__preset-card')` | Carte préréglage |
| text-9 | Text | Text | `Key('quick_start_timer__preset-name')` | Nom préréglage |
| text-10 | Text | Text | `Key('quick_start_timer__preset-time')` | Heure préréglage |
| text-11 | Text | Text | `Key('quick_start_timer__preset-reps')` | Répétitions préréglage |
| text-12 | Text | Text | `Key('quick_start_timer__preset-work')` | Travail préréglage |
| text-13 | Text | Text | `Key('quick_start_timer__preset-rest')` | Repos préréglage |

---

## 2. Architecture et groupement des widgets

### 2.1 Hiérarchie proposée
```
QuickStartTimerScreen (StatefulWidget)
├── Scaffold
    ├── AppBar (implicit from design)
    └── body: SingleChildScrollView
        └── Column
            ├── _HeaderSection (Container + Row)
            │   ├── _VolumeControl (IconButton + Slider + Icon)
            │   └── _MenuButton (IconButton)
            ├── SizedBox (spacing)
            ├── _QuickStartCard (Card)
            │   ├── _SectionTitle
            │   ├── _RepetitionsControl (Row)
            │   ├── _WorkTimeControl (Row)
            │   ├── _RestTimeControl (Row)
            │   └── _ActionButtons (Row)
            ├── SizedBox (spacing)
            ├── _PresetsHeader (Row)
            └── _PresetsList (ListView or Column)
                └── _PresetCard (Card) [répété]
```

### 2.2 Widgets composés réutilisables
- `_TimeControl` : Row avec minus/plus buttons + time display
- `_ValueControl` : Row avec minus/plus buttons + value display  
- `_PresetCard` : Card pour afficher un préréglage
- `_SectionHeader` : Row avec titre + bouton d'action optionnel

---

## 3. Gestion d'état

### 3.1 State endpoints (variables d'état)
```dart
class _QuickStartTimerScreenState extends State<QuickStartTimerScreen> {
  // Configuration courante
  int repetitions = 16;
  Duration workTime = Duration(seconds: 44);
  Duration restTime = Duration(seconds: 15);
  double volume = 0.7;
  
  // Préréglages
  List<TimerPreset> presets = [];
  
  // État UI
  bool isLoading = false;
  String? errorMessage;
}
```

### 3.2 State mutations (méthodes)
```dart
// Contrôles de valeurs
void _incrementRepetitions()
void _decrementRepetitions()
void _incrementWorkTime()
void _decrementWorkTime()  
void _incrementRestTime()
void _decrementRestTime()
void _setVolume(double value)

// Actions principales
Future<void> _savePreset()
Future<void> _startTimer()
Future<void> _loadPresets()
void _selectPreset(TimerPreset preset)

// Gestion des préréglages
Future<void> _addPreset()
Future<void> _deletePreset(String id)
```

---

## 4. Modèles de données

### 4.1 Classes requises
```dart
// TimerPreset model
class TimerPreset {
  final String id;
  final String name;
  final int repetitions;
  final Duration workTime;
  final Duration restTime;
  final DateTime createdAt;
  
  // constructors, fromJson, toJson, etc.
}

// TimerConfiguration model  
class TimerConfiguration {
  final int repetitions;
  final Duration workTime;
  final Duration restTime;
  
  Duration get totalDuration => (workTime + restTime) * repetitions;
}
```

---

## 5. Validation et hooks

### 5.1 Validation rules
```dart
// Validation des entrées
bool _isValidRepetitions(int value) => value >= 1;
bool _isValidDuration(Duration duration) => duration.inSeconds >= 1;

// Formatage
String _formatDuration(Duration duration) => 
    '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
```

### 5.2 Hooks de validation
- `onRepetitionsChanged`: Valide range [1, 999]
- `onTimeChanged`: Valide format mm:ss et minimum 00:01
- `onSave`: Valide configuration complète avant sauvegarde
- `onStart`: Valide configuration avant lancement timer

---

## 6. Accessibility et testabilité

### 6.1 Semantic labels mapping
```dart
static const semanticLabels = {
  'volume': 'volume',
  'menu': 'menu', 
  'diminuer répétitions': 'diminuer répétitions',
  'augmenter répétitions': 'augmenter répétitions',
  'diminuer travail': 'diminuer travail',
  'augmenter travail': 'augmenter travail',
  'diminuer repos': 'diminuer repos',
  'augmenter repos': 'augmenter repos',
  'sauvegarder': 'sauvegarder',
  'commencer': 'commencer',
  'ajouter préréglage': 'ajouter préréglage',
};
```

### 6.2 Keys pour tests
- Chaque widget interactif a une `Key` unique
- Pattern: `Key('quick_start_timer__<component-function>')`
- Keys permettent les tests widget et d'intégration

---

## 7. Plan de tests

### 7.1 Tests unitaires (`test/unit/`)
```
timer_configuration_test.dart
├── TimerConfiguration.totalDuration calculation
├── Duration formatting helpers
└── Validation rules

timer_preset_test.dart  
├── TimerPreset model serialization
├── Preset list management
└── Preset validation
```

### 7.2 Tests de widgets (`test/widget/`)
```
quick_start_timer_screen_test.dart
├── Widget rendering with default values
├── Increment/decrement button interactions  
├── Save/Start button states
├── Volume slider functionality
├── Preset selection behavior
└── Error state display

time_control_widget_test.dart
├── Time display formatting
├── Button tap interactions
└── Accessibility labels
```

### 7.3 Tests golden (`test/golden/`)
```
quick_start_timer_golden_test.dart
├── Initial state appearance
├── With error message
├── With presets loaded
└── Different screen sizes (small, medium, large)
```

---

## 8. Structure de fichiers à générer

### 8.1 Arborescence cible
```
lib/
├── screens/
│   └── quick_start_timer_screen.dart
├── widgets/
│   ├── time_control.dart
│   ├── value_control.dart
│   ├── preset_card.dart
│   └── section_header.dart
├── models/
│   ├── timer_preset.dart
│   └── timer_configuration.dart
├── services/
│   └── preset_storage_service.dart
└── theme/
    ├── app_colors.dart
    ├── app_text_styles.dart
    └── app_theme.dart

test/
├── unit/
│   ├── timer_configuration_test.dart
│   └── timer_preset_test.dart
├── widget/
│   ├── quick_start_timer_screen_test.dart
│   └── time_control_widget_test.dart
└── golden/
    └── quick_start_timer_golden_test.dart
```

### 8.2 Fichiers de configuration
```
pubspec.yaml (mise à jour dépendances si nécessaire)
analysis_options.yaml (linting rules)
```

---

## 9. Dépendances et imports

### 9.1 Packages Flutter requis
```yaml
# Dans pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  # Aucune dépendance externe requise pour cette implémentation

dev_dependencies:
  flutter_test:
    sdk: flutter
  golden_toolkit: ^0.15.0  # Pour les tests golden
```

### 9.2 Imports standards
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour feedback haptique
```

---

## 10. Tokens et theming

### 10.1 Mapping des tokens design
```dart
// app_colors.dart - Reprendre les tokens du design.json
static const primary = Color(0xFF2E7D32);
static const onPrimary = Color(0xFFFFFFFF);
static const background = Color(0xFFF5F5F5);
// ... etc pour tous les tokens colors

// app_text_styles.dart - Typography mapping  
static const title = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
static const label = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
```

---

## Résumé des livrables

✅ **Fichiers principaux à générer** :
- `lib/screens/quick_start_timer_screen.dart` (écran principal)
- `lib/widgets/*.dart` (4 widgets composés)  
- `lib/models/*.dart` (2 modèles de données)
- `lib/services/preset_storage_service.dart` (persistance)
- `lib/theme/*.dart` (3 fichiers de thème)

✅ **Tests à générer** :
- 2 tests unitaires
- 2 tests de widgets  
- 1 test golden

✅ **Conformité** :
- Design fidelity via tokens mapping
- Spec compliance via validation rules
- Testability via keys systématiques  
- Maintainability via composition widgets
