---
screenName: Workout
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
specVersion: 2
generatedAt: 2026-03-03T00:00:00Z
generator: snapshot2app-specgen
language: fr
---

# 1. Vue d'ensemble
- **Nom de l'écran** : Workout
- **Code technique / ID** : `workout`
- **Type d'écran** : Other (session execution)
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Exécuter une session d'entraînement en enchaînant les étapes (Préparation, n répétitions Travail/Repos, Refroidissement)
  - Afficher un chronomètre décomptant chaque seconde
  - Jouer des bips sonores dans les 3 dernières secondes de chaque étape
  - Permettre pause/reprise, navigation entre étapes, et sortie manuelle

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId       | type       | variant   | key (stable)              | texte (après transform) |
|-----|-------------|------------|-----------|---------------------------|-------------------------|
| 1   | iconbutton-1 | IconButton | ghost     | workout__iconbutton-1     | —                       |
| 2   | slider-1     | Slider     | —         | workout__slider-1         | —                       |
| 3   | iconbutton-2 | IconButton | ghost     | workout__iconbutton-2     | —                       |
| 4   | button-1     | Button     | secondary | workout__button-1         | Maintenir pour sortir   |
| 5   | iconbutton-3 | IconButton | ghost     | workout__iconbutton-3     | —                       |
| 6   | text-1       | Text       | —         | workout__text-1           | 2                       |
| 7   | text-2       | Text       | —         | workout__text-2           | 01:20                   |
| 8   | text-3       | Text       | —         | workout__text-3           | TRAVAIL                 |
| 9   | iconbutton-4 | IconButton | ghost     | workout__iconbutton-4     | —                       |

## 2.2 Sections / blocs (structure visuelle)
| sectionId       | intitulé (verbatim) | description courte              | composants inclus (ordonnés)                  |
|-----------------|---------------------|---------------------------------|-----------------------------------------------|
| s_volume        | —                   | Slider de volume (en haut)      | iconbutton-1, slider-1                        |
| s_navigation    | —                   | Contrôles précédent/sortir/suivant | iconbutton-2, button-1, iconbutton-3       |
| s_display       | —                   | Affichage principal             | text-1, text-2, text-3                        |
| s_pause         | —                   | FAB pause/start                 | iconbutton-4                                  |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Bouton     | Maintenir pour sortir         |
| Étape      | PRÉPARER, TRAVAIL, REPOS, REFROIDIR |
| Compteur   | (dynamique, nombre entier)    |
| Chrono     | (dynamique, format MM:SS)     |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|
| —       | —                 | —              | —       | —                  |

---

# 3. Interactions (par composant interactif)
| compId       | type       | variant → rôle     | a11y.ariaLabel               | action                 | état(s) impactés            | navigation |
|-------------|------------|---------------------|------------------------------|------------------------|-----------------------------|------------|
| iconbutton-1 | IconButton | ghost → faible     | Activer ou désactiver le son | (informatif)           | —                           | —          |
| slider-1     | Slider     | — → contrôle       | Volume slider                | onVolumeChange(double) | volume                      | —          |
| iconbutton-2 | IconButton | ghost → faible     | Précédent                    | previousStep()         | currentStep, remainingTime  | —          |
| button-1     | Button     | secondary → action | Maintenir pour sortir        | onLongPress()          | isExiting                   | pop → Home |
| iconbutton-3 | IconButton | ghost → faible     | Suivant                      | nextStep()             | currentStep, remainingTime  | —          |
| iconbutton-4 | IconButton | ghost → faible     | Mettre en pause              | togglePause()          | isPaused                    | —          |

- **Gestes** : long-press sur button-1 (1 seconde) pour sortir ; tap sur écran pour afficher/masquer contrôles
- **Feedback** : bips sonores à 00:02, 00:01, 00:00 ; couleur de fond change selon étape ; fond assombri en pause
- **Contrôles auto-hide** : disparaissent après 1500ms, réapparaissent au tap écran, restent visibles en pause

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| —            | —     | —                           |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|-------|-----------|-----------|-------|
| R1 - Séquence étapes | Preset → [preparation, n×(work, rest), cooldown] | Étapes enchaînées automatiquement | Dernière répétition : pas de repos |
| R2 - Étape à 0s | Durée étape = 0 | Étape sautée, passe directement à la suivante | — |
| R3 - Bips sonores | remainingTime ∈ {2, 1, 0} | Bip joué après décrémentation quand chrono affiche la valeur | Bip au moment de l'affichage |
| R4 - Compteur reps | Transition rest→work | Décrémentation du compteur | Work et rest d'une même répétition = même valeur |
| R5 - Visibilité reps | StepType ∈ {work, rest} | Compteur visible | Invisible pendant preparation et cooldown |
| R6 - Controls auto-hide | 1500ms après affichage | Volume, navigation, FAB disparaissent | Réapparaissent au tap, restent en pause |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Fin de session | — | Retour à Home (pas d'écran de fin pour le moment) |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Tap START          | Home         | Preset     | Via route /workout avec Preset en argument |

## 5.2 Cibles (sorties de l'écran)
| déclencheur          | écran cible | paramètres | remarques |
|----------------------|-------------|------------|-----------|
| Fin de session       | Home        | —          | Pop automatique |
| Long-press sortir    | Home        | —          | Pop via isExiting |
| Back physique        | Home        | —          | Pop standard |

## 5.3 Événements système
- Back physique : retour Home
- Timer périodique : tick chaque seconde via TickerService

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé              | type     | défaut       | persistance | notes |
|------------------|----------|-------------|-------------|-------|
| currentStep      | StepType | preparation | non         | preparation\|work\|rest\|cooldown |
| remainingTime    | int      | preset.prepareSeconds | non | Décrémente chaque seconde |
| remainingReps    | int      | preset.repetitions    | non | Décrémente sur transition rest→work |
| isPaused         | bool     | false        | non         | — |
| isExiting        | bool     | false        | non         | Passé à true sur long-press sortir |
| controlsVisible  | bool     | true         | non         | Auto-hide après 1500ms |
| volume           | double   | (from prefs) | oui         | Clé partagée avec Home |
| isComplete       | bool     | false        | non         | true quand session terminée |

## 6.2 Actions / effets
| nom              | entrée        | sortie | erreurs | description |
|------------------|---------------|--------|---------|-------------|
| tick             | —             | —      | —       | Décrémente remainingTime, gère transition auto, déclenche bips |
| togglePause      | —             | —      | —       | Bascule isPaused, gère ticker |
| nextStep         | —             | —      | —       | Passe à l'étape suivante manuellement |
| previousStep     | —             | —      | —       | Revient à l'étape précédente manuellement |
| onScreenTap      | —             | —      | —       | Affiche contrôles, relance timer auto-hide |
| onVolumeChange   | double value  | —      | —       | Met à jour volume + AudioService + prefs |
| onLongPress      | —             | —      | —       | Passe isExiting à true |

---

# 7. Accessibilité
| compId       | ariaLabel (design)           | rôle sémantique | focus order | raccourcis | notes |
|-------------|------------------------------|-----------------|-------------|------------|-------|
| iconbutton-1 | Activer ou désactiver le son | button          | 1           | —          | — |
| slider-1     | Volume slider                | slider          | 2           | —          | — |
| iconbutton-2 | Précédent                    | button          | 3           | —          | — |
| button-1     | Maintenir pour sortir        | button          | 4           | —          | Long-press |
| iconbutton-3 | Suivant                      | button          | 5           | —          | — |
| iconbutton-4 | Mettre en pause              | button          | 6           | —          | Toggle pause/resume |

---

# 8. Thème & tokens requis
- Couleurs sémantiques : workColor (#4CD27E), restColor (#2196F3), prepareColor (#FFCC00), cooldownColor (rgba 203,128,216), ghostButtonBg (#555555), textPrimary (#000000), textSecondary (#FFFFFF)
- Typographies référencées : value (chrono, compteur), title (libellé étape), label (bouton sortir)
- Contraste WCAG AA : non vérifié (couleurs du design)

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal — Preset 5/3x(40/20)/10
1. **Given** écran affiché avec preset 5/3×(40/20)/10
   **When** session démarre
   **Then** étape = preparation, chrono = 00:05, pas de compteur

2. **Given** étape preparation, chrono = 00:01
   **When** chrono décrémente → 00:00 → bip
   **Then** transition vers work, chrono = 00:40, compteur = 3

3. **Given** étape work rep 1, chrono = 00:00
   **When** transition
   **Then** étape = rest, chrono = 00:20, compteur = 3 (même valeur)

4. **Given** étape rest rep 1, chrono = 00:00
   **When** transition rest→work
   **Then** compteur décrémenté (3→2), étape = work, chrono = 00:40

5. **Given** étape work rep 3 (dernière), chrono = 00:00
   **When** transition
   **Then** pas de rest, étape = cooldown, chrono = 00:10, compteur reste à 1

6. **Given** étape cooldown, chrono = 00:00
   **When** session terminée
   **Then** retour à Home

## 9.2 Nominal — Preset 0/3x(40/20)/0 (pas de prep ni cooldown)
1. **Given** preset avec prepare=0, cooldown=0
   **When** session démarre
   **Then** étape preparation sautée, commence directement en work, chrono = 00:40, compteur = 3

## 9.3 Pause/Reprise
1. **Given** session en cours
   **When** tap FAB pause
   **Then** chrono figé, fond assombri, FAB = play_arrow, contrôles restent visibles

2. **Given** session en pause
   **When** tap FAB start
   **Then** chrono reprend, fond normal, FAB = pause, contrôles disparaissent après 1500ms

## 9.4 Controls visibility
1. **Given** session en cours, contrôles masqués
   **When** tap sur l'écran
   **Then** contrôles apparaissent, disparaissent après 1500ms

## 9.5 Navigation manuelle
1. **Given** étape work
   **When** tap suivant
   **Then** passe à l'étape suivante, chrono réinitialisé

## 9.6 Sortie manuelle
1. **Given** session en cours
   **When** long-press bouton sortir (1s)
   **Then** isExiting = true, retour Home

---

# 10. Traçabilité vers des tests
| id  | type   | préconditions          | étapes                        | oracle attendu |
|-----|--------|------------------------|-------------------------------|----------------|
| T1  | unit   | WorkoutEngine(preset)  | Check step list generation    | Correct flat list with skipped 0s steps and last rest |
| T2  | unit   | Engine at step, time=3 | tick() ×4                     | Beeps at 2,1,0; transition at next tick |
| T3  | unit   | Engine work rep 1      | Advance to rest then work     | Reps decremented on rest→work only |
| T4  | unit   | WorkoutState created   | togglePause()                 | isPaused toggled, notifyListeners called |
| T5  | unit   | WorkoutState created   | onVolumeChange(0.5)           | volume=0.5, audio.setVolume called, prefs saved |
| T6  | unit   | WorkoutState created   | onScreenTap()                 | controlsVisible=true |
| T7  | unit   | WorkoutState created   | onLongPress()                 | isExiting=true |
| T8  | widget | WorkoutDisplay         | currentStep=work, reps=3      | text-1 visible with "3", text-3 = "TRAVAIL" |
| T9  | widget | PauseButton            | isPaused=false                | Icon = pause |
| T10 | widget | NavigationControls     | tap previous                  | previousStep() called |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance)
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Écran de fin de session non développé, retour Home | 0.9 |
| 2 | Volume partagé avec Home via même clé SharedPreferences | 0.9 |

## 11.2 Hors périmètre
- Écran de fin de session (future iteration)
- Animations avancées de transition entre étapes

## 11.3 Incertitudes / questions ouvertes
- —

---

# 12. Contraintes
- Authentification : —
- Sécurité : —
- Performance : Timer tick <1ms overhead
- Accessibilité : ariaLabels sur tous les composants interactifs
- Compatibilité : Flutter 3.38.3

---

# 13. Déterminisme & conventions
- Vocabulaire contrôlé : variants (cta|primary|secondary|ghost), placement (start|center|end|stretch), widthMode (fixed|hug|fill)
- Clés stables : `workout__{compId}`
- Textes verbatim du design.json avec transform uppercase appliqué
