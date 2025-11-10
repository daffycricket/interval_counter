---
# Deterministic Functional Spec — Workout

# YAML front matter for machine-readability
screenName: Workout
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
specVersion: 2
generatedAt: 2025-10-25T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : Workout
- **Code technique / ID** : `workout`
- **Type d'écran** : Timer/Chronomètre
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Exécuter une session d'entraînement par intervalles
  - Afficher un chronomètre dégressif pour chaque étape
  - Gérer les transitions entre étapes (Préparation → Travail → Repos → Refroidissement)
  - Contrôler la lecture/pause de la session
  - Ajuster le volume sonore des bips
  - Naviguer entre les étapes (précédent/suivant)

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
| s_header  | — | Barre de contrôle volume | iconbutton-1, slider-1, icon-1 |
| s_navigation | — | Contrôles de navigation | container-2, iconbutton-2, button-1, iconbutton-3 |
| s_display | — | Affichage principal (compteur, chrono, libellé) | text-1, text-2, text-3 |
| s_controls | — | Bouton pause/play | iconbutton-4 |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Bouton sortie | Maintenir pour sortir |
| Compteur répétitions | 2 |
| Chronomètre | 01:20 |
| Libellé étape travail | TRAVAIL |
| Libellé étape repos | REPOS |
| Libellé étape préparation | PRÉPARER |
| Libellé étape refroidissement | REFROIDIR |

## 2.4 Listes & tableaux (si applicable)
— (Aucune liste dans cet écran)

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| iconbutton-1 | IconButton | ghost → faible | Activer ou désactiver le son | `toggleSound()` | soundEnabled | — |
| slider-1 | Slider | — | Contrôle du volume | `onVolumeChange(value)` | volume | — |
| iconbutton-2 | IconButton | ghost → faible | Précédent | `previousStep()` | currentStep, remainingTime, remainingReps | — |
| button-1 | Button | secondary → supportive | Maintenir pour sortir | `exitWorkout()` (long press) | — | Home |
| iconbutton-3 | IconButton | ghost → faible | Suivant | `nextStep()` | currentStep, remainingTime, remainingReps | — |
| iconbutton-4 | IconButton | ghost → faible | Mettre en pause | `togglePause()` | isPaused | — |
| container-1 | Container | — | — | `onScreenTap()` | controlsVisible | — |

- **Gestes & clavier** : 
  - Tap sur l'écran : affiche/masque les contrôles (avec auto-hide après 1500ms)
  - Long press (1s) sur button-1 : sortie de la session
  - Back physique : sortie instantanée vers Home
- **Feedback** : 
  - Bip sonore aux secondes 3, 2, 1 de chaque étape
  - Changement de couleur de fond selon l'étape
  - Masquage progressif des contrôles (opacity animation 300ms)
- **Règles de placement ayant un impact** : 
  - iconbutton-4 (pause) : positioned bottom-right (FAB)
  - container-2 : flex row avec justify=between

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| preset | non null | — |
| preset.workSeconds | > 0 | — |
| preset.repetitions | > 0 | — |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|-------|-----------|-----------|-------|
| Affichage compteur répétitions | currentStep == work OU rest | Visible | Spec complément §Détails visuels |
| Format temps | toujours | "MM:SS" | 01:20, 00:03, etc. |
| Couleur fond | currentStep | Préparation=#FFCC00, Travail=#4CD27E, Repos=#2196F3, Refroidissement=#CB80D8 | Spec complément §Détails visuels |
| Bip sonore | remainingTime ∈ {3,2,1} ET soundEnabled=true | SystemSound.play() | Spec complément §Règles de gestion |
| Skip étape zéro | preset.{prepare/cooldown}Seconds == 0 | Étape non affichée | Spec complément §Règles de gestion |
| Skip repos dernière rep | remainingReps == 1 | Travail → Refroidissement directement | Spec complément §Règles de gestion |
| Auto-hide contrôles | 1500ms après affichage ou tap | opacity 0 | Spec complément §Règles visuelles |
| Icon FAB | isPaused | pause ↔ play_arrow | Interaction dynamique |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Preset invalide | Ne devrait pas arriver (validation en amont) | — |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Tap COMMENCER | Home | Preset | Démarre session avec préréglage |
| Tap sur carte préréglage | Home | Preset | Démarre session avec préréglage sauvegardé |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| button-1 (long press) | Home | — | Sortie manuelle |
| Back physique | Home | — | Sortie instantanée |
| Fin session (après cooldown) | Home | — | Retour automatique via onWorkoutComplete |

## 5.3 Événements système
- Back physique : retour immédiat vers Home
- Timer : décrémentation chaque seconde, transitions automatiques
- Audio : bips aux secondes 3, 2, 1 de chaque étape

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| currentStep | StepType | preparation ou work | non | Étape actuelle (preparation, work, rest, cooldown) |
| remainingTime | int | preset.prepareSeconds ou workSeconds | non | Temps restant en secondes |
| remainingReps | int | preset.repetitions | non | Répétitions restantes |
| isPaused | bool | false | non | État pause/lecture |
| volume | double | 0.9 | oui | Volume normalisé [0.0, 1.0] |
| soundEnabled | bool | true | oui | Son activé/désactivé |
| controlsVisible | bool | true | non | Visibilité des contrôles |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| tick | — | — | — | Décrémente remainingTime, joue bip si nécessaire, appelle nextStep si temps écoulé |
| nextStep | — | — | — | Passe à l'étape suivante selon la logique métier |
| previousStep | — | — | — | Revient à l'étape précédente |
| togglePause | — | — | — | Bascule isPaused, démarre/arrête le timer |
| onVolumeChange | double value | — | — | Met à jour volume, sauvegarde dans prefs |
| toggleSound | — | — | — | Bascule soundEnabled, sauvegarde dans prefs |
| onScreenTap | — | — | — | Affiche contrôles, lance auto-hide après 1500ms |
| exitWorkout | — | — | — | Arrête le timer, callback onWorkoutComplete |
| playBeep | — | — | — | Joue SystemSound.play() si soundEnabled et volume > 0 |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|
| iconbutton-1 | Activer ou désactiver le son | button | 1 | — | — |
| slider-1 | Contrôle du volume | slider | 2 | — | — |
| iconbutton-2 | Précédent | button | 3 | — | — |
| button-1 | Maintenir pour sortir | button | 4 | — | Long press requis |
| iconbutton-3 | Suivant | button | 5 | — | — |
| text-1 | — | text | — | — | Compteur répétitions |
| text-2 | — | text | — | — | Chronomètre |
| text-3 | — | text | — | — | Libellé étape |
| iconbutton-4 | Mettre en pause | button | 6 | Space | FAB pause/play |

---

# 8. Thème & tokens requis
- Couleurs sémantiques utilisées : `primary`, `onPrimary`, `background`, `textPrimary`, `textSecondary`, `workColor`, `restColor`, `prepareColor`, `cooldownColor`, `sliderActive`, `sliderInactive`, `sliderThumb`, `ghostButtonBg`
- Typographies référencées (`typographyRef`) : value, title, label
- Exigences de contraste (WCAG AA) : oui

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran Workout est affiché avec preset (5/3x(40/20)/10)  
   **When** le temps passe  
   **Then** l'écran affiche : Préparation (5s) → Travail (40s, 3 reps) → Repos (20s, 3 reps) → Travail (40s, 2 reps) → Repos (20s, 2 reps) → Travail (40s, 1 rep) → Refroidissement (10s) → retour Home.

2. **Given** l'écran Workout affiche Travail avec remainingTime=3  
   **When** le temps décrémente à 3, 2, 1  
   **Then** un bip sonore est émis à chaque seconde.

3. **Given** l'écran Workout est en cours avec isPaused=false  
   **When** l'utilisateur appuie sur iconbutton-4 (pause)  
   **Then** isPaused=true, le timer s'arrête, l'icône change en play_arrow.

4. **Given** l'écran Workout est en pause avec isPaused=true  
   **When** l'utilisateur appuie sur iconbutton-4 (play)  
   **Then** isPaused=false, le timer redémarre, l'icône change en pause.

5. **Given** l'écran Workout affiche Travail avec remainingReps=2  
   **When** l'utilisateur appuie sur iconbutton-3 (suivant)  
   **Then** l'écran passe à l'étape Repos.

6. **Given** l'écran Workout affiche les contrôles  
   **When** 1500ms s'écoulent sans interaction  
   **Then** les contrôles disparaissent (opacity 0).

7. **Given** l'écran Workout avec contrôles masqués  
   **When** l'utilisateur tap n'importe où sur l'écran  
   **Then** les contrôles réapparaissent, puis se masquent après 1500ms.

8. **Given** l'écran Workout avec preset (0/3x(40/20)/0)  
   **When** le temps passe  
   **Then** l'écran affiche : Travail (40s, 3 reps) → Repos (20s, 3 reps) → Travail (40s, 2 reps) → Repos (20s, 2 reps) → Travail (40s, 1 rep) → retour Home.

## 9.2 Alternatives / Exceptions
- **Dernière répétition** : Skip l'étape Repos, passe directement à Refroidissement  
- **Étapes à 0 secondes** : Skip l'étape (Préparation ou Refroidissement)  
- **Long press < 1s** : Ne déclenche pas exitWorkout  
- **Volume = 0** : Pas de bip sonore même aux dernières secondes  
- **soundEnabled = false** : Pas de bip sonore même si volume > 0

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | unit | preset=5/3x(40/20)/10 | initialize | currentStep=preparation, remainingTime=5, remainingReps=3 |
| T2 | unit | currentStep=preparation, remainingTime=1 | tick() | currentStep=work, remainingTime=40 |
| T3 | unit | currentStep=work, remainingTime=1, remainingReps=3 | tick() | currentStep=rest, remainingTime=20, remainingReps=2 |
| T4 | unit | currentStep=work, remainingTime=1, remainingReps=1 | tick() | currentStep=cooldown OU end |
| T5 | unit | remainingTime=3 | tick() | playBeep() called |
| T6 | unit | isPaused=false | togglePause() | isPaused=true |
| T7 | unit | currentStep=work | previousStep() | currentStep=preparation OU start |
| T8 | unit | currentStep=rest | nextStep() | currentStep=work (si reps > 0) |
| T9 | widget | — | tap iconbutton-4 | icon changes pause ↔ play_arrow |
| T10 | widget | — | tap screen | controlsVisible=true, then false after 1500ms |
| T11 | widget | currentStep=work | — | background color = #4CD27E |
| T12 | widget | currentStep=rest | — | background color = #2196F3 |
| T13 | a11y | — | — | all interactive components have Semantics with label |
| T14 | golden | default state | — | matches golden file |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Les couleurs du design.json sont fidèles au rendu final | 0.90 |
| 2 | SystemSound.play(SystemSoundType.click) est acceptable pour le bip | 0.70 |
| 3 | Le délai de 1500ms pour auto-hide est correct | 0.85 |
| 4 | La position du slider (0.9) correspond au volume par défaut | 0.75 |
| 5 | L'icône material.pause et material.play_arrow sont appropriées | 0.90 |

## 11.2 Hors périmètre
- Écran Home (origine de navigation)
- Persistance détaillée des préréglages
- Gestion audio avancée (fichiers sons personnalisés)
- Statistiques de session
- Historique des entraînements

## 11.3 Incertitudes / questions ouvertes
- Comportement si l'app passe en arrière-plan pendant une session ?
- Notification pour continuer la session en arrière-plan ?
- Vibration en plus du son aux dernières secondes ?

---

# 12. Contraintes
- **Authentification** : —
- **Sécurité** : —
- **Performance** : Timer précis (1 seconde), réactivité immédiate des contrôles
- **Accessibilité** : Tous les éléments interactifs doivent avoir des labels sémantiques (WCAG AA)
- **Compatibilité** : iOS et Android

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en secondes, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Textes verbatim avec `style.transform` appliqué (TRAVAIL, REPOS, PRÉPARER, REFROIDIR).









