# Plan de construction - IntervalTimerHome

## Widget Inventory

### Composants principaux par ID

#### Barre supérieure (Container-1)
- **Container-1** → `Container` avec layout flex row, backgroundColor headerBackgroundDark
- **IconButton-2** → `IconButton` volume (material.volume_up), variant ghost
- **Slider-3** → `Slider` avec style personnalisé (activeTrack, inactiveTrack, thumbColor)
- **Icon-4** → `Icon` material.circle (indicateur de position)
- **IconButton-5** → `IconButton` menu (material.more_vert), variant ghost

#### Section Démarrage rapide (Card-6)
- **Card-6** → `Card` avec elevation et padding
- **Container-7** → `Container` header avec layout flex row
- **Text-8** → `Text` "Démarrage rapide" (titleLarge, bold)
- **IconButton-9** → `IconButton` expand/collapse (material.expand_less)

#### Contrôles de valeurs
- **Text-10** → `Text` "RÉPÉTITIONS" (label, uppercase)
- **IconButton-11** → `IconButton` decrease (material.remove)
- **Text-12** → `Text` valeur "16" (value, bold, 24px)
- **IconButton-13** → `IconButton` increase (material.add)
- **Text-14** → `Text` "TRAVAIL" (label, uppercase)
- **IconButton-15** → `IconButton` decrease (material.remove)
- **Text-16** → `Text` valeur "00:44" (value, bold, 24px)
- **IconButton-17** → `IconButton` increase (material.add)
- **Text-18** → `Text` "REPOS" (label, uppercase)
- **IconButton-19** → `IconButton` decrease (material.remove)
- **Text-20** → `Text` valeur "00:15" (value, bold, 24px)
- **IconButton-21** → `IconButton` increase (material.add)

#### Actions principales
- **Button-22** → `ElevatedButton` "SAUVEGARDER" avec leadingIcon (material.save), variant ghost
- **Button-23** → `ElevatedButton` "COMMENCER" avec leadingIcon (material.bolt), variant cta

#### Section Préréglages (Container-24)
- **Container-24** → `Container` header section avec layout flex row
- **Text-25** → `Text` "VOS PRÉRÉGLAGES" (title, uppercase, bold)
- **IconButton-26** → `IconButton` edit (material.edit), variant ghost
- **Button-27** → `OutlinedButton` "+ AJOUTER" avec leadingIcon (material.add), variant secondary

#### Carte préréglage (Card-28)
- **Card-28** → `Card` avec backgroundColor presetCardBg
- **Container-29** → `Container` header préréglage
- **Text-30** → `Text` nom "gainage" (title, bold)
- **Text-31** → `Text` durée "14:22" (value, medium)
- **Text-32** → `Text` "RÉPÉTITIONS 20x" (body, regular)
- **Text-33** → `Text` "TRAVAIL 00:40" (body, regular)
- **Text-34** → `Text` "REPOS 00:03" (body, regular)

### Groupement des widgets

#### ValueControl (widget réutilisable)
Composant pour les contrôles -/valeur/+ :
- `IconButton` decrease
- `Text` valeur centrée
- `IconButton` increase
- Layout : Row avec MainAxisAlignment.spaceBetween

#### PresetCard (widget réutilisable)
Composant pour afficher un préréglage :
- Header avec nom et durée totale
- Détails des paramètres (répétitions, travail, repos)
- Actions contextuelles

## State & Actions

### Modèle de données

#### TimerConfiguration
```dart
class TimerConfiguration {
  final int repetitions;
  final Duration workDuration;
  final Duration restDuration;
  
  Duration get totalDuration => (workDuration + restDuration) * repetitions;
}
```

#### TimerPreset
```dart
class TimerPreset {
  final String id;
  final String name;
  final TimerConfiguration configuration;
  final DateTime createdAt;
}
```

### État de l'écran

#### IntervalTimerHomeState
- `double volumeLevel` (0.0 - 1.0, défaut: 0.62)
- `TimerConfiguration currentConfig` (défaut: 16 reps, 44s work, 15s rest)
- `List<TimerPreset> presets` (chargés depuis le stockage local)
- `bool isQuickStartExpanded` (défaut: true)

### Actions/Mutations

#### Actions de configuration
- `updateRepetitions(int value)` : Met à jour le nombre de répétitions
- `updateWorkDuration(Duration value)` : Met à jour le temps de travail
- `updateRestDuration(Duration value)` : Met à jour le temps de repos
- `updateVolume(double value)` : Met à jour le niveau de volume

#### Actions de préréglages
- `saveCurrentAsPreset(String name)` : Sauvegarde la config actuelle
- `loadPreset(TimerPreset preset)` : Charge un préréglage
- `deletePreset(String id)` : Supprime un préréglage
- `addNewPreset()` : Navigue vers l'écran de création

#### Actions de navigation
- `startTimer()` : Lance l'entraînement avec la config actuelle
- `openSettings()` : Ouvre les paramètres généraux
- `toggleQuickStart()` : Expand/collapse la section démarrage rapide

## Keys

### Keys pour testability

#### Identifiants de composants
- `Key('interval_timer_home__volume_slider')`
- `Key('interval_timer_home__repetitions_decrease')`
- `Key('interval_timer_home__repetitions_value')`
- `Key('interval_timer_home__repetitions_increase')`
- `Key('interval_timer_home__work_decrease')`
- `Key('interval_timer_home__work_value')`
- `Key('interval_timer_home__work_increase')`
- `Key('interval_timer_home__rest_decrease')`
- `Key('interval_timer_home__rest_value')`
- `Key('interval_timer_home__rest_increase')`
- `Key('interval_timer_home__save_button')`
- `Key('interval_timer_home__start_button')`
- `Key('interval_timer_home__add_preset_button')`

#### Keys dynamiques pour préréglages
- `Key('preset_card_${preset.id}')`
- `Key('preset_start_${preset.id}')`
- `Key('preset_edit_${preset.id}')`

## Validation Hooks

### Validation des valeurs
- **Répétitions** : `>= 1`, entier uniquement
- **Durées** : `>= Duration(seconds: 1)`, format mm:ss
- **Volume** : `>= 0.0 && <= 1.0`

### Validation de l'état
- **Configuration complète** : Tous les champs requis renseignés
- **Nom de préréglage** : Non vide, longueur max 50 caractères
- **Unicité des noms** : Pas de doublons dans les préréglages

### Hooks de validation
```dart
bool get isConfigurationValid => 
  currentConfig.repetitions >= 1 &&
  currentConfig.workDuration >= Duration(seconds: 1) &&
  currentConfig.restDuration >= Duration(seconds: 1);

bool get canStartTimer => isConfigurationValid;
bool get canSavePreset => isConfigurationValid;
```

## Tests

### Tests unitaires
#### Modèles
- `test/unit/timer_configuration_test.dart`
  - Calcul de durée totale
  - Validation des valeurs
  - Sérialisation/désérialisation

- `test/unit/timer_preset_test.dart`
  - Création de préréglage
  - Comparaison et égalité
  - Tri par date

#### Services
- `test/unit/preset_storage_service_test.dart`
  - Sauvegarde/chargement des préréglages
  - Gestion des erreurs de stockage
  - Migration de données

### Tests de widgets
#### Composants réutilisables
- `test/widget/value_control_test.dart`
  - Affichage des valeurs
  - Interactions +/-
  - Validation des limites

- `test/widget/preset_card_test.dart`
  - Affichage des informations
  - Actions contextuelles
  - États de sélection

#### Écran principal
- `test/widget/interval_timer_home_screen_test.dart`
  - Rendu initial
  - Interactions avec les contrôles
  - Navigation vers d'autres écrans
  - Gestion des états d'erreur

### Tests d'intégration
- `integration_test/interval_timer_flow_test.dart`
  - Flux complet : configuration → sauvegarde → lancement
  - Gestion des préréglages
  - Persistance des données

### Tests golden
- `test/golden/interval_timer_home_test.dart`
  - État initial
  - État avec préréglages
  - État d'erreur
  - Différentes tailles d'écran

## Files to Generate

### Structure des dossiers
```
lib/
├── main.dart (mise à jour)
├── models/
│   ├── timer_configuration.dart
│   └── timer_preset.dart
├── screens/
│   └── interval_timer_home_screen.dart
├── widgets/
│   ├── value_control.dart
│   ├── preset_card.dart
│   └── section_header.dart
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
├── widget/
│   ├── value_control_test.dart
│   ├── preset_card_test.dart
│   └── interval_timer_home_screen_test.dart
└── golden/
    └── interval_timer_home_test.dart

integration_test/
└── interval_timer_flow_test.dart
```

### Dépendances à ajouter
```yaml
dependencies:
  shared_preferences: ^2.2.2  # Stockage local des préréglages
  
dev_dependencies:
  golden_toolkit: ^0.15.0     # Tests golden
  mockito: ^5.4.2             # Mocking pour les tests
```

### Ordre de génération
1. **Modèles** : TimerConfiguration, TimerPreset
2. **Services** : PresetStorageService
3. **Thème** : AppTheme, AppColors, AppTextStyles
4. **Utils** : DurationFormatter
5. **Widgets réutilisables** : ValueControl, PresetCard, SectionHeader
6. **Écran principal** : IntervalTimerHomeScreen
7. **Tests unitaires** : Modèles et services
8. **Tests de widgets** : Composants et écran
9. **Tests d'intégration** : Flux complets
10. **Mise à jour** : main.dart pour intégrer le nouvel écran

### Points d'attention
- **Responsive design** : Adaptation aux différentes tailles d'écran
- **Accessibilité** : Implémentation complète des ariaLabel
- **Performance** : Optimisation du rendu des listes de préréglages
- **Persistance** : Gestion robuste du stockage local
- **Validation** : Feedback utilisateur en temps réel
