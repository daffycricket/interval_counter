---
# Deterministic Functional Spec — Workout (Refactored)

# YAML front matter for machine-readability
screenName: Workout
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
specVersion: 2
generatedAt: 2025-11-10T00:00:00Z
generator: snapshot2app-specgen
language: fr
refactoringNote: "Refactor VolumeHeader from Home to generic widget, maintain existing workout layout/widgets"

---

# 1. Vue d'ensemble
- **Nom de l'écran** : Workout (Chronomètre Travail)
- **Code technique / ID** : `workout`
- **Type d'écran** : Timer/Execution
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Exécuter la session d'entraînement sélectionnée avec enchainement automatique des étapes
  - Afficher un chronomètre dégressif pour chaque étape (Préparation, Travail, Repos, Refroidissement)
  - Permettre la navigation entre les étapes (précédent, suivant)
  - Contrôler la lecture/pause de la session
  - Ajuster le volume sonore des bips
  - Sortir de la session (long-press)

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId | type        | variant   | key (stable)              | texte (après transform) |
|-----|--------|-------------|-----------|---------------------------|-------------------------|
| 1   | container-1 | Container | — | workout__container-1 | — |
| 2   | iconbutton-1 | IconButton | ghost | workout__iconbutton-1 | — |
| 3   | slider-1 | Slider | — | workout__slider-1 | — |
| 4   | icon-1 | Icon | — | workout__icon-1 | — |
| 5   | container-2 | Container | — | workout__container-2 | — |
| 6   | iconbutton-2 | IconButton | ghost | workout__iconbutton-2 | — |
| 7   | button-1 | Button | secondary | workout__button-1 | Maintenir pour sortir |
| 8   | iconbutton-3 | IconButton | ghost | workout__iconbutton-3 | — |
| 9   | text-1 | Text | — | workout__text-1 | 2 |
| 10  | text-2 | Text | — | workout__text-2 | 01:20 |
| 11  | text-3 | Text | — | workout__text-3 | TRAVAIL |
| 12  | iconbutton-4 | IconButton | ghost | workout__iconbutton-4 | — |

> Règle de clé: `{screenName}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|--------------------|-------------------------------|
| s_volume_header | — | Contrôle de volume (sans menu) | iconbutton-1, slider-1, icon-1 |
| s_navigation | — | Contrôles de navigation | container-2, iconbutton-2, button-1, iconbutton-3 |
| s_display | — | Affichage principal (répétitions, chrono, libellé) | text-1, text-2, text-3 |
| s_fab | — | Bouton pause/lecture | iconbutton-4 |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Bouton sortie | Maintenir pour sortir |
| Libellé préparation | PRÉPARER |
| Libellé travail | TRAVAIL |
| Libellé repos | REPOS |
| Libellé refroidissement | REFROIDIR |
| Compteur répétitions | 2 (dynamique) |
| Chronomètre | 01:20 (format MM:SS) |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|
| — | — | — | — | — |

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| iconbutton-1 | IconButton | ghost → faible | Activer ou désactiver le son | `onVolumeIconTap()` | — | — |
| slider-1 | Slider | — | Curseur de volume | `onVolumeChange(value)` | volume | — |
| iconbutton-2 | IconButton | ghost → faible | Précédent | `previousStep()` | currentStep, remainingTime | — |
| button-1 | Button | secondary → supportive | Maintenir pour sortir | `exitWorkout()` (long-press) | — | Home |
| iconbutton-3 | IconButton | ghost → faible | Suivant | `nextStep()` | currentStep, remainingTime | — |
| iconbutton-4 | IconButton | ghost → faible | Mettre en pause / Reprendre | `togglePause()` | isPaused | — |
| container-1 | Container | — | — | `onScreenTap()` | controlsVisible | — |

- **Gestes & clavier** : 
  - Tap n'importe où sur l'écran : affiche les contrôles masqués
  - Long-press sur button-1 (1 seconde) : quitte la session
  - Tap sur iconbutton-4 : toggle pause/lecture
- **Feedback** : 
  - Bip sonore aux 3 dernières secondes (2, 1, 0)
  - Changement de couleur de fond selon l'étape
  - Changement d'icône FAB (pause ↔ play)
  - Assombrissement du fond en pause
  - Auto-masquage des contrôles après 1500ms
- **Règles de placement ayant un impact** : 
  - VolumeHeader : en haut, full width
  - NavigationControls : centrés horizontalement
  - WorkoutDisplay : centré verticalement et horizontalement
  - FAB : bas-droite, disparaît en bas quand controlsVisible=false

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| preset | doit être fourni en argument de navigation | — |
| volume | [0.0, 1.0] | — |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|------|-----------|-----------|-------|
| Affichage compteur répétitions | currentStep == work OR rest | Visible (text-1) | Préparation et refroidissement : invisible |
| Couleur de fond | currentStep | Jaune (prepare), Vert (work), Bleu (rest), Violet (cooldown) | spec_complement §Détails visuels |
| Assombrissement fond | isPaused == true | HSL lightness * 0.4 | — |
| Bip sonore | remainingTime <= 3 && remainingTime > 0 | Émettre bip | 3, 2, 1 secondes |
| Masquage contrôles | Timer 1500ms après affichage/tap | controlsVisible = false | — |
| Étape suivante | remainingTime == 0 | Transition automatique | — |
| Skip étape | stepDuration == 0 dans preset | Passer directement à l'étape suivante | — |
| Skip repos dernière répétition | remainingReps == 1 | Passer directement au cooldown | spec_complement §Règles de gestion |
| Fin de session | currentStep == cooldown && remainingTime == 0 | Navigation vers Home | spec_complement §5 |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Preset manquant | Erreur navigation | Retour Home |
| Session terminée | Navigation automatique vers Home | — |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Tap sur bouton COMMENCER | Home | Preset (Quick Start) | Préréglage temporaire |
| Tap sur PresetCard | Home | Preset (sauvegardé) | Préréglage persisté |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| Session terminée | Home | — | Retour automatique |
| Long-press button-1 | Home | — | Sortie manuelle |
| Back physique | Home | — | Sortie immédiate |

## 5.3 Événements système
- Back physique : ferme l'écran instantanément, retour à Home
- Timer : ticker 1 seconde pour décrémentation
- Audio : bip sonore aux 3 dernières secondes

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| currentStep | StepType (enum) | preparation | non | preparation, work, rest, cooldown |
| remainingTime | int | preset.prepareSeconds | non | Temps restant en secondes |
| remainingReps | int | preset.repetitions | non | Répétitions restantes |
| isPaused | bool | false | non | État pause/lecture |
| volume | double | 0.9 | oui (SharedPrefs) | Volume [0.0, 1.0] |
| controlsVisible | bool | true | non | Visibilité des contrôles UI |
| isExiting | bool | false | non | Flag sortie manuelle |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| tick | — | — | — | Décrémente remainingTime, joue bip si nécessaire, transition auto si time=0 |
| nextStep | — | — | — | Passe à l'étape suivante selon règles métier |
| previousStep | — | — | — | Revient à l'étape précédente |
| togglePause | — | — | — | Inverse isPaused, arrête/redémarre ticker |
| onVolumeChange | double value | — | — | Met à jour volume, persiste dans SharedPrefs |
| onScreenTap | — | — | — | Affiche contrôles, schedule auto-hide 1500ms |
| exitWorkout | — | — | — | Arrête ticker, navigation vers Home |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|
| iconbutton-1 | Activer ou désactiver le son | button | 1 | — | — |
| slider-1 | Curseur de volume | slider | 2 | — | — |
| iconbutton-2 | Précédent | button | 3 | — | — |
| button-1 | Maintenir pour sortir | button | 4 | — | Long-press |
| iconbutton-3 | Suivant | button | 5 | — | — |
| text-1 | — | text | — | — | Compteur répétitions |
| text-2 | — | text | — | — | Chronomètre |
| text-3 | — | text | — | — | Libellé étape |
| iconbutton-4 | Mettre en pause / Reprendre | button | 6 | — | Toggle pause |

---

# 8. Thème & tokens requis
- Couleurs sémantiques utilisées : 
  - `prepareColor` (#FFCC00) — Jaune pour Préparation
  - `workColor` (#4CD27E) — Vert pour Travail
  - `restColor` (#2196F3) — Bleu pour Repos
  - `cooldownColor` (RGB: 203, 128, 216) — Violet pour Refroidissement
  - `ghostButtonBg` (#555555) — Boutons secondaires
  - `sliderActive`, `sliderInactive`, `sliderThumb` — Slider
- Typographies référencées (`typographyRef`) : value (chrono, compteur), title (libellé), label (boutons)
- Exigences de contraste (WCAG AA) : oui

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran Workout est affiché avec preset 5/3x(40/20)/10 (Préparation 5s)  
   **When** le chrono atteint 00:00  
   **Then** l'écran passe en étape Travail (40s), fond vert, compteur 3.

2. **Given** l'étape Travail avec remainingTime=3  
   **When** le timer tick  
   **Then** un bip sonore est émis, remainingTime=2.

3. **Given** l'étape Travail répétition 3/3 (dernière) avec remainingTime=0  
   **When** nextStep() est appelé  
   **Then** l'écran passe directement au Refroidissement (pas de Repos).

4. **Given** l'écran Workout est affiché avec controlsVisible=true  
   **When** 1500ms se sont écoulés sans interaction  
   **Then** controlsVisible=false, les contrôles disparaissent.

5. **Given** controlsVisible=false  
   **When** l'utilisateur tap n'importe où sur l'écran  
   **Then** controlsVisible=true, les contrôles réapparaissent.

6. **Given** l'écran Workout en lecture  
   **When** l'utilisateur tap sur iconbutton-4 (Pause)  
   **Then** isPaused=true, ticker arrêté, fond assombri, icône change en play.

7. **Given** l'écran Workout en pause  
   **When** l'utilisateur tap sur iconbutton-4 (Play)  
   **Then** isPaused=false, ticker redémarre, fond normal, icône change en pause.

8. **Given** l'écran Workout est affiché  
   **When** l'utilisateur long-press sur button-1  
   **Then** exitWorkout() est appelé, navigation vers Home.

9. **Given** preset 0/3x(40/20)/0 (pas de préparation ni refroidissement)  
   **When** l'écran est affiché  
   **Then** l'étape initiale est Travail (40s), fond vert, compteur 3.

10. **Given** l'étape Refroidissement avec remainingTime=0  
    **When** tick() est appelé  
    **Then** navigation automatique vers Home.

## 9.2 Alternatives / Exceptions
- **Préparation à 0s** : Skip, démarrer directement au Travail  
- **Repos à 0s** : Skip, passer directement à la répétition suivante  
- **Refroidissement à 0s** : Skip, fin immédiate après dernière répétition  
- **Back physique** : Sortie immédiate vers Home sans confirmation  
- **Dernière répétition** : Pas d'étape Repos, passage direct au Refroidissement

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | unit | engine.remainingTime=3 | engine.shouldPlayBeep | true |
| T2 | unit | engine.remainingTime=4 | engine.shouldPlayBeep | false |
| T3 | unit | engine.currentStep=work | engine.shouldShowRepsCounter | true |
| T4 | unit | engine.currentStep=preparation | engine.shouldShowRepsCounter | false |
| T5 | unit | engine: work, reps=1, time=0 | engine.nextStep() | currentStep=cooldown |
| T6 | unit | engine: work, reps=2, time=0 | engine.nextStep() | currentStep=rest, reps=1 |
| T7 | widget | WorkoutScreen with preset | pump 1500ms | controlsVisible=false |
| T8 | widget | controlsVisible=false | tap screen | controlsVisible=true |
| T9 | widget | isPaused=false | tap FAB | isPaused=true, icon=play_arrow |
| T10 | widget | isPaused=true | tap FAB | isPaused=false, icon=pause |
| T11 | widget | screen displayed | long-press button-1 | Navigator.pop() called |
| T12 | unit | state.volume=0.5 | onVolumeChange(0.8) | state.volume=0.8, persisted |
| T13 | a11y | — | — | all interactive components have Semantics with label |
| T14 | golden | preparation step | — | matches golden file (yellow background) |
| T15 | golden | work step | — | matches golden file (green background) |
| T16 | golden | rest step | — | matches golden file (blue background) |
| T17 | golden | cooldown step | — | matches golden file (purple background) |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Les couleurs du design.json sont fidèles au rendu final | 0.94 |
| 2 | Le slider de volume partage les mêmes préférences avec Home | 0.90 |
| 3 | L'auto-hide des contrôles à 1500ms est le bon timing | 0.85 |
| 4 | Le bip sonore se joue à 3, 2, 1 (mais pas à 4 ni à 0 après le tick) | 0.95 |
| 5 | Le format du chrono est MM:SS avec padding | 0.95 |

## 11.2 Hors périmètre
- Écran de fin de session (not yet implemented, fall back to Home)
- Gestion de la persistance des sessions interrompues
- Statistiques de session (durée totale, étapes complétées)
- Vibration/haptics (seulement audio)

## 11.3 Incertitudes / questions ouvertes
- Le bouton iconbutton-1 (volume) doit-il avoir une action ou est-il purement informatif ?
- Faut-il une confirmation avant de sortir avec le bouton back physique ?
- Le volume doit-il être partagé entre Home et Workout ou indépendant ?

---

# 12. Contraintes
- **Authentification** : —
- **Sécurité** : —
- **Performance** : 
  - Ticker doit être précis (±50ms max de dérive par minute)
  - Audio doit se jouer sans latence perceptible (<100ms)
- **Accessibilité** : 
  - Tous les éléments interactifs doivent avoir des labels sémantiques (WCAG AA)
  - Contraste des textes sur fonds colorés ≥ 4.5:1
- **Compatibilité** : iOS et Android
- **Architecture** : 
  - Respecter ARCHITECTURE_CONTRACT.md (DIP, domain layer, state as thin coordinator)
  - WorkoutEngine en domain pur (no Flutter imports except foundation)
  - Services injectés via interfaces (TickerService, AudioService, PreferencesRepository)

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, temps en secondes (int), booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Textes verbatim avec `style.transform` appliqué (PRÉPARER, TRAVAIL, REPOS, REFROIDIR en majuscules).
- StepType enum : preparation, work, rest, cooldown (lowercase, pas de synonymes).

---

# 14. Refactoring Notes (VolumeHeader)

## 14.1 Objectif du refactoring
Extraire le composant VolumeHeader de l'écran Home pour en faire un widget générique réutilisable par l'écran Workout, avec les contraintes suivantes :
- **Home** : VolumeHeader avec bouton volume + slider + bouton menu (3 éléments)
- **Workout** : VolumeHeader avec bouton volume + slider seulement (2 éléments, pas de menu)

## 14.2 Approche technique
Le VolumeHeader actuel est dans `lib/widgets/home/volume_header.dart` et implémente `PreferredSizeWidget` pour être utilisé comme AppBar dans Home.

**Nouvelle structure** :
1. **Déplacer** `volume_header.dart` de `lib/widgets/home/` vers `lib/widgets/volume_header.dart`
2. **Rendre le bouton menu optionnel** via paramètre nullable `VoidCallback? onMenuPressed`
3. **Adapter la clé** : le widget doit accepter une clé externe au lieu de hardcoder `home__Container-1`
4. **Partager les préférences volume** : même clé SharedPreferences entre Home et Workout

## 14.3 Signature du widget refactoré
```dart
class VolumeHeader extends StatelessWidget implements PreferredSizeWidget {
  final double volume;
  final ValueChanged<double> onVolumeChange;
  final VoidCallback? onMenuPressed; // Nullable: si null, le bouton menu n'apparaît pas
  
  const VolumeHeader({
    super.key,
    required this.volume,
    required this.onVolumeChange,
    this.onMenuPressed,
  });
}
```

## 14.4 Adaptations nécessaires
- **HomeScreen** : passer `onMenuPressed: () { ... }`
- **WorkoutScreen** : passer `onMenuPressed: null` (pas de bouton menu)
- **Clés de test** : 
  - Home conserve `home__Container-1`, `home__IconButton-2`, etc.
  - Workout utilise des clés externes ou accepte un préfixe

## 14.5 Tests à adapter
- Tests widgets de Home : vérifier présence du bouton menu
- Tests widgets de Workout : vérifier absence du bouton menu
- Tests d'intégration : vérifier partage des préférences volume

---

# 15. Architecture & Layers (Clean Architecture)

## 15.1 Domain Layer
**Fichier** : `lib/domain/workout_engine.dart` (déjà existant, conforme)
- Pure Dart (immutable)
- Pas de dépendances Flutter
- Logique métier : transitions d'étapes, règles de skip, calculs

## 15.2 Application Layer (State)
**Fichier** : `lib/state/workout_state.dart` (déjà existant, conforme)
- Thin coordinator
- Injection de dépendances via interfaces
- Délégation au WorkoutEngine
- Gestion du ticker, audio, persistance via services

## 15.3 Infrastructure Layer (Services)
**Interfaces** :
- `lib/services/ticker_service.dart` (existant)
- `lib/services/audio_service.dart` (existant)
- `lib/services/preferences_repository.dart` (existant)

**Implémentations** :
- `lib/services/impl/system_ticker_service.dart` (existant)
- `lib/services/impl/beep_audio_service.dart` (existant)
- `lib/services/impl/shared_prefs_repository.dart` (existant)

## 15.4 Presentation Layer (UI)
**Fichiers** :
- `lib/screens/workout_screen.dart` (existant, à adapter)
- `lib/widgets/volume_header.dart` (à créer/déplacer)
- `lib/widgets/workout/navigation_controls.dart` (existant, conforme)
- `lib/widgets/workout/workout_display.dart` (existant, conforme)
- `lib/widgets/workout/pause_button.dart` (existant, conforme)

---

# 16. Acceptance Criteria

## 16.1 Fonctionnel
- [ ] La session s'exécute avec enchainement automatique des étapes
- [ ] Le chrono décompte de 1 seconde par seconde
- [ ] Les bips sonores se jouent à 3, 2, 1 (pas à 4, pas après 0)
- [ ] Le compteur de répétitions est visible pour work/rest, invisible pour prepare/cooldown
- [ ] La couleur de fond change selon l'étape (jaune, vert, bleu, violet)
- [ ] Les contrôles se masquent après 1500ms
- [ ] Un tap sur l'écran affiche les contrôles
- [ ] Le bouton pause/play fonctionne
- [ ] Le bouton précédent/suivant fonctionne
- [ ] Le long-press sur "Maintenir pour sortir" quitte la session
- [ ] Le slider de volume contrôle le volume du bip
- [ ] La dernière répétition skip le repos
- [ ] Les étapes à 0s sont skippées
- [ ] La fin de session retourne à Home

## 16.2 Architecture
- [ ] WorkoutEngine est pur (no Flutter imports except foundation)
- [ ] WorkoutState injecte les services via interfaces
- [ ] Aucun appel direct à Timer, SystemSound, SharedPreferences dans State
- [ ] Tests domain : 100% coverage
- [ ] Tests state : 100% coverage avec mocks

## 16.3 VolumeHeader Refactoring
- [ ] VolumeHeader déplacé dans `lib/widgets/volume_header.dart`
- [ ] Le paramètre `onMenuPressed` est nullable
- [ ] HomeScreen affiche le bouton menu
- [ ] WorkoutScreen n'affiche pas le bouton menu
- [ ] Les préférences volume sont partagées entre Home et Workout
- [ ] Les tests de Home et Workout passent

## 16.4 Tests
- [ ] Tous les tests unitaires passent
- [ ] Tous les tests widgets passent
- [ ] Coverage ≥ 100% pour domain
- [ ] Coverage ≥ 100% pour state
- [ ] Aucun linter error

---

