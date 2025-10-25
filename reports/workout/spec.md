---
# Deterministic Functional Spec — Workout

# YAML front matter for machine-readability
screenName: Workout
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
specVersion: 2
generatedAt: 2025-10-24T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : Workout
- **Code technique / ID** : `workout`
- **Type d'écran** : Timer
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Exécuter une session d'entraînement par intervalles
  - Afficher un chronomètre dégressif pour chaque étape
  - Gérer les transitions automatiques entre les étapes (Préparation, Travail, Repos, Refroidissement)
  - Permettre la navigation manuelle entre les étapes
  - Contrôler le volume des notifications sonores
  - Mettre en pause et reprendre la session

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId | type | variant | key (stable) | texte (après transform) |
|-----|--------|------|---------|--------------|-------------------------|
| 1 | container-1 | Container | — | workout__container-1 | — |
| 2 | iconbutton-1 | IconButton | ghost | workout__iconbutton-1 | — |
| 3 | slider-1 | Slider | — | workout__slider-1 | — |
| 4 | icon-1 | Icon | — | workout__icon-1 | — |
| 5 | container-2 | Container | — | workout__container-2 | — |
| 6 | iconbutton-2 | IconButton | ghost | workout__iconbutton-2 | — |
| 7 | button-1 | Button | secondary | workout__button-1 | Maintenir pour sortir |
| 8 | iconbutton-3 | IconButton | ghost | workout__iconbutton-3 | — |
| 9 | text-1 | Text | — | workout__text-1 | 2 |
| 10 | text-2 | Text | — | workout__text-2 | 01:20 |
| 11 | text-3 | Text | — | workout__text-3 | TRAVAIL |
| 12 | iconbutton-4 | IconButton | ghost | workout__iconbutton-4 | — |

> Règle de clé: `{screenName}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|--------------------|-------------------------------|
| s_volume_controls | — | Contrôles de volume en haut | container-1, iconbutton-1, slider-1, icon-1 |
| s_navigation_controls | — | Contrôles de navigation | container-2, iconbutton-2, button-1, iconbutton-3 |
| s_workout_display | — | Affichage principal de l'entraînement | text-1, text-2, text-3 |
| s_pause_control | — | Bouton de pause/lecture | iconbutton-4 |

## 2.3 Libellés & textes
| usage | valeur (verbatim + transform) |
|-------|-------------------------------|
| Bouton sortie | Maintenir pour sortir |
| Compteur répétitions | 2 |
| Chronomètre | 01:20 |
| Libellé étape Travail | TRAVAIL |
| Libellé étape Repos | REPOS |
| Libellé étape Préparation | PRÉPARER |
| Libellé étape Refroidissement | REFROIDIR |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|-------------------|
| — | — | — | — | — |

---

# 3. Interactions (par composant interactif)
| compId | type | variant → rôle | a11y.ariaLabel | action (onTap/submit/…) | état(s) impactés | navigation |
|--------|------|----------------|-----------------|-------------------------|------------------|------------|
| iconbutton-1 | IconButton | ghost → faible | Activer ou désactiver le son | `toggleSound()` | soundEnabled | — |
| slider-1 | Slider | — | Curseur de volume | `onVolumeChange(value)` | volume | — |
| iconbutton-2 | IconButton | ghost → faible | Précédent | `previousStep()` | currentStep, remainingTime | — |
| button-1 | Button | secondary → supportive | Maintenir pour sortir | `onLongPress: exitWorkout()` | — | Home |
| iconbutton-3 | IconButton | ghost → faible | Suivant | `nextStep()` | currentStep, remainingTime | — |
| iconbutton-4 | IconButton | ghost → faible | Mettre en pause | `togglePause()` | isPaused | — |

- **Gestes & clavier** : 
  - Long-press sur button-1 (1 seconde) : retour à l'écran Home
  - Tap n'importe où sur l'écran : afficher/masquer les contrôles
  - Back physique : retour immédiat à l'écran Home
- **Feedback** : 
  - Bip sonore émis lors des 3 dernières secondes de chaque étape
  - Les contrôles (volume, navigation, pause) disparaissent après 1 seconde
  - Les contrôles réapparaissent lors d'un tap sur l'écran
  - Changement de couleur de fond selon l'étape
- **Règles de placement ayant un impact** : 
  - button-1 : centre, widthMode=intrinsic (bouton secondaire centré)
  - iconbutton-4 : placement=end (FAB en bas à droite)

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| preset | doit contenir au moins une étape avec durée > 0 | — |
| volume | [0.0, 1.0] | — |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|-------|-----------|-----------|-------|
| Affichage compteur répétitions (text-1) | currentStep == Travail ou Repos | Visible | Invisible pour Préparation et Refroidissement |
| Étape ignorée | duration == 0 | Étape sautée | Passe directement à l'étape suivante |
| Dernière répétition | remainingReps == 1 | Pas d'étape Repos | Passe de Travail à Refroidissement |
| Bip sonore | remainingTime <= 3 | Émet un bip à chaque seconde | Volume contrôlé par slider |
| Visibilité contrôles | lastTapTime > 1s | Masqués | Réapparaissent au tap |
| Couleur de fond | currentStep | Dynamique | Vert (Travail), Bleu (Repos), Jaune (Préparation/Refroidissement) |
| Icône FAB | isPaused | pause ou play_arrow | Toggle entre pause et lecture |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Preset invalide | Retour Home | Afficher erreur |
| Fin de session | Retour Home automatique | — |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Tap sur COMMENCER | Home | preset (Preset) | Démarre la session avec le preset sélectionné |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| Long-press button-1 | Home | — | Sortie manuelle |
| Back physique | Home | — | Sortie immédiate |
| Fin de session | Home | — | Sortie automatique après dernier step |

## 5.3 Événements système
- **Back physique** : Retour immédiat à Home (pas de confirmation)
- **Timer** : Décrémente remainingTime chaque seconde, émet bip si <= 3s
- **Permissions** : Aucune

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé | type | défaut | persistance | notes |
|-----|------|--------|-------------|-------|
| preset | Preset | (param) | non | Configuration de la session reçue depuis Home |
| currentStep | StepType | preparation | non | preparation, work, rest, cooldown |
| remainingTime | int | preset.preparationDuration | non | Temps restant en secondes |
| remainingReps | int | preset.repetitions | non | Répétitions restantes |
| isPaused | bool | false | non | État pause/lecture |
| volume | double | 0.9 | oui | Volume normalisé [0.0, 1.0] |
| soundEnabled | bool | true | oui | Son activé/désactivé |
| controlsVisible | bool | true | non | Visibilité des contrôles |
| lastTapTime | DateTime? | null | non | Timestamp du dernier tap |

## 6.2 Actions / effets
| nom | entrée | sortie | erreurs | description |
|-----|--------|--------|---------|-------------|
| startTimer | — | — | — | Démarre le timer, tick chaque seconde |
| stopTimer | — | — | — | Arrête le timer |
| tick | — | — | — | Décrémente remainingTime, émet bip si <= 3s, passe à step suivant si 0 |
| nextStep | — | — | — | Passe à l'étape suivante selon la logique métier |
| previousStep | — | — | — | Revient à l'étape précédente |
| togglePause | — | — | — | Toggle isPaused, stop/start timer |
| onVolumeChange | double value | — | — | Met à jour volume |
| toggleSound | — | — | — | Toggle soundEnabled |
| exitWorkout | — | — | — | Navigation vers Home |
| onScreenTap | — | — | — | Toggle controlsVisible, met à jour lastTapTime |
| hideControlsAfterDelay | — | — | — | Masque contrôles après 1s si pas d'interaction |
| playBeep | — | — | — | Émet un bip sonore au volume configuré |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|
| iconbutton-1 | Activer ou désactiver le son | button | 1 | — | Toggle audio |
| slider-1 | Curseur de volume | slider | 2 | — | Ajuste volume des bips |
| iconbutton-2 | Précédent | button | 3 | — | Step précédent |
| button-1 | Maintenir pour sortir | button | 4 | — | Long-press pour sortir |
| iconbutton-3 | Suivant | button | 5 | — | Step suivant |
| iconbutton-4 | Mettre en pause | button | 6 | Space | Toggle pause/play |
| text-1 | — | text | — | — | Compteur répétitions |
| text-2 | — | text | — | — | Chronomètre |
| text-3 | — | text | — | — | Libellé étape |

---

# 8. Thème & tokens requis
- Couleurs sémantiques utilisées : `primary (#4CD27E)`, `onPrimary (#FFFFFF)`, `background (#4CD27E)`, `surface (#4CD27E)`, `textPrimary (#000000)`, `textSecondary (#FFFFFF)`, `sliderActive (#000000)`, `sliderInactive (#E0E0E0)`, `sliderThumb (#000000)`, `ghostButtonBg (#555555)`
- Typographies référencées (`typographyRef`) : label, value, title
- Exigences de contraste (WCAG AA) : oui

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran Workout est affiché avec preset "5/3x(40/20)/10" et currentStep=preparation  
   **When** remainingTime atteint 0  
   **Then** currentStep passe à work, remainingTime = 40, remainingReps = 3.

2. **Given** currentStep=work, remainingReps=3, remainingTime=40  
   **When** remainingTime atteint 0  
   **Then** currentStep passe à rest, remainingTime = 20, remainingReps reste 3.

3. **Given** currentStep=rest, remainingReps=1, remainingTime=20  
   **When** remainingTime atteint 0  
   **Then** currentStep passe à cooldown (pas de rest pour la dernière rep).

4. **Given** currentStep=work, isPaused=false  
   **When** l'utilisateur appuie sur iconbutton-4  
   **Then** isPaused=true, timer s'arrête, icône change pour play_arrow.

5. **Given** currentStep=work, controlsVisible=true  
   **When** 1 seconde s'écoule sans interaction  
   **Then** controlsVisible=false.

6. **Given** controlsVisible=false  
   **When** l'utilisateur tap n'importe où sur l'écran  
   **Then** controlsVisible=true, puis masquage après 1s.

7. **Given** remainingTime=3  
   **When** chaque seconde s'écoule  
   **Then** playBeep() est appelé (3 fois: à 3s, 2s, 1s).

8. **Given** preset "0/3x(40/20)/0" (pas de préparation ni refroidissement)  
   **When** l'écran s'affiche  
   **Then** currentStep démarre directement à work.

## 9.2 Alternatives / Exceptions
- **Étape à 0 seconde** : L'étape est ignorée, passage direct à la suivante
- **Dernière répétition** : Pas d'étape Repos, passage direct à Refroidissement
- **Refroidissement à 0** : Retour Home immédiat après dernière étape Travail
- **Long-press court (< 1s)** : Aucune action, ne quitte pas l'écran
- **Volume à 0** : Aucun bip sonore émis

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | unit | preset "5/3x(40/20)/10", step=preparation, time=0 | tick() | currentStep=work, remainingTime=40, remainingReps=3 |
| T2 | unit | step=work, remainingReps=3, time=0 | tick() | currentStep=rest, remainingTime=20, remainingReps=3 |
| T3 | unit | step=rest, remainingReps=1, time=0 | tick() | currentStep=cooldown, remainingTime=10 |
| T4 | unit | step=work, isPaused=false | togglePause() | isPaused=true |
| T5 | unit | remainingTime=3 | tick() | playBeep() called |
| T6 | unit | remainingTime=4 | tick() | playBeep() not called |
| T7 | unit | preset "0/3x(40/20)/0" | initial state | currentStep=work |
| T8 | widget | default state | tap iconbutton-4 | find.byIcon(Icons.play_arrow) |
| T9 | widget | isPaused=true | tap iconbutton-4 | find.byIcon(Icons.pause) |
| T10 | widget | — | long-press button-1 | navigation to Home |
| T11 | widget | — | tap iconbutton-3 | nextStep() called |
| T12 | widget | — | tap iconbutton-2 | previousStep() called |
| T13 | a11y | — | — | all interactive components have Semantics with label |
| T14 | golden | step=work | — | matches golden file (green background) |
| T15 | golden | step=rest | — | matches golden file (blue background) |
| T16 | golden | step=preparation | — | matches golden file (yellow background) |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Couleur verte #4CD27E pour l'étape Travail | 0.9 |
| 2 | Font Roboto utilisée | 0.8 |
| 3 | Slider position initiale à 90% | 0.8 |
| 4 | Délai de 1 seconde pour masquer les contrôles | 0.9 |
| 5 | Bip sonore lors des 3 dernières secondes | 0.95 |

## 11.2 Hors périmètre
- Écran Home (source de navigation)
- Persistance de l'état de la session en cours
- Notifications système
- Mode plein écran / verrouillage d'écran
- Statistiques / historique des sessions
- Couleurs et sons personnalisés pour les étapes

## 11.3 Incertitudes / questions ouvertes
- Type exact de bip sonore (fréquence, durée) ?
- Comportement si l'app passe en arrière-plan pendant une session ?
- Animation de transition entre les étapes ?

---

# 12. Contraintes
- **Authentification** : —
- **Sécurité** : —
- **Performance** : Timer précis (tick chaque seconde), pas de lag visible
- **Accessibilité** : Tous les éléments interactifs ont des labels sémantiques (WCAG AA)
- **Compatibilité** : iOS et Android

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en secondes, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Textes verbatim avec `style.transform` appliqué (TRAVAIL, REPOS, PRÉPARER, REFROIDIR).

