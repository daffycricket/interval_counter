---
# Deterministic Functional Spec — Workout

# YAML front matter for machine-readability
screenName: ChronometreTravail
screenId: workout
designSnapshotRef: b039e6bc-74d9-4ca5-a4c6-93d67f2fb6b0.png
specVersion: 2
generatedAt: 2025-11-11T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : Chronomètre Travail (Workout)
- **Code technique / ID** : `workout`
- **Type d'écran** : Timer / Display
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Exécuter une session d'entraînement avec enchaînement automatique des étapes (Préparation, n répétitions de Travail/Repos, Refroidissement)
  - Afficher un chronomètre dégressif qui décroît d'une seconde à chaque seconde
  - Contrôler la session (pause/reprendre, naviguer entre étapes)
  - Ajuster le volume sonore des bips
  - Sortir de la session en cours

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
| s_header  | — | Contrôle de volume en haut de l'écran | container-1, iconbutton-1, slider-1, icon-1 |
| s_controls | — | Ligne de contrôles de navigation | container-2, iconbutton-2, button-1, iconbutton-3 |
| s_display | — | Affichage principal du chronomètre et de l'état | text-1, text-2, text-3 |
| s_fab | — | Bouton d'action flottant pour pause/reprendre | iconbutton-4 |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Étape Préparation | PRÉPARER |
| Étape Travail | TRAVAIL |
| Étape Repos | REPOS |
| Étape Refroidissement | REFROIDIR |
| Bouton sortie | Maintenir pour sortir |
| Compteur répétitions (exemple) | 2 |
| Chronomètre (exemple) | 01:20 |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|
| — | — | — | — | — |

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| iconbutton-1 | IconButton | ghost → faible | Activer ou désactiver le son | `toggleMute()` | volume | — |
| slider-1 | Slider | — | Curseur de volume | `onVolumeChange(value)` | volume | — |
| iconbutton-2 | IconButton | ghost → faible | Précédent | `previousStep()` | currentStep, remainingTime | — |
| button-1 | Button | secondary → supportive | Maintenir pour sortir | `onLongPress()` | — | Home (ferme écran) |
| iconbutton-3 | IconButton | ghost → faible | Suivant | `nextStep()` | currentStep, remainingTime | — |
| iconbutton-4 | IconButton | ghost → faible | Mettre en pause / Démarrer | `togglePause()` | isPaused | — |
| container-1 | Container | — | — | `onScreenTap()` | controlsVisible | — |

- **Gestes & clavier** : 
  - Tap n'importe où sur l'écran : affiche/masque les contrôles
  - Long press (1 seconde) sur button-1 : ferme l'écran et retour à Home
  - Back physique : ferme l'écran instantanément et retour à Home
- **Feedback** : 
  - Bip sonore aux 3 dernières secondes de chaque étape (à 00:02, 00:01, 00:00)
  - Les contrôles disparaissent automatiquement après 1500ms
  - Les contrôles restent visibles pendant la pause
  - Couleur de fond change selon l'étape en cours
- **Règles de placement ayant un impact** : 
  - button-1 : centré entre iconbutton-2 et iconbutton-3
  - iconbutton-4 : FAB en bas à droite
  - Contrôles : disparaissent/apparaissent avec animation de 300ms

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| preset | non null | — |
| preset.reps | > 0 | — |
| preset.workSeconds | > 0 | — |
| preset.restSeconds | ≥ 0 | — |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|------|-----------|-----------|-------|
| Affichage compteur répétitions | currentStep == work OR currentStep == rest | text-1 visible | Invisible pour preparation et cooldown |
| Couleur fond Préparation | currentStep == preparation | backgroundColor = #FFCC00 (jaune) | — |
| Couleur fond Travail | currentStep == work | backgroundColor = #4CD27E (vert) | — |
| Couleur fond Repos | currentStep == rest | backgroundColor = #2196F3 (bleu) | — |
| Couleur fond Refroidissement | currentStep == cooldown | backgroundColor = rgb(203, 128, 216) (violet) | — |
| Assombrissement fond pause | isPaused == true | backgroundColor luminosité * 0.4 | — |
| Libellé étape | currentStep | text-3 = "PRÉPARER" / "TRAVAIL" / "REPOS" / "REFROIDIR" | Majuscules |
| Format chronomètre | remainingTime | "MM:SS" format | Exemple: 01:20 pour 80 secondes |
| Compteur répétitions | remainingReps | Affiche nombre restant | Même valeur pour work et rest du même cycle |
| Bip sonore | remainingTime ∈ {2, 1, 0} && volume > 0 | Joue bip sonore | Aux 3 dernières secondes |
| Pas de bip | remainingTime == 3 | Pas de bip | Règle spéciale: bip uniquement à 2, 1, 0 |
| Visibilité contrôles au lancement | Toujours | Tous visibles | — |
| Disparition contrôles | Après 1500ms du lancement ou du dernier tap écran | Contrôles invisibles | slider-1, container-2, iconbutton-4 |
| Réapparition contrôles | onScreenTap() | Contrôles visibles pendant 1500ms | — |
| Contrôles pendant pause | isPaused == true | Contrôles restent visibles | Pas de disparition auto |
| Icône FAB | isPaused == false | Icons.pause | — |
| Icône FAB | isPaused == true | Icons.play_arrow | — |
| Étape ignorée si 0 secondes | preset.preparationSeconds == 0 OR preset.cooldownSeconds == 0 | Passe directement à l'étape suivante | — |
| Pas de repos dernière répétition | remainingReps == 1 && currentStep == work | Passe directement à cooldown après work | — |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Session terminée | — | Navigation automatique vers Home |
| Preset invalide | — | N/A (validation en amont) |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Tap sur COMMENCER | Home | Preset (reps, workSeconds, restSeconds, preparationSeconds, cooldownSeconds) | Lance une session d'entraînement |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| Long press button-1 | Home | — | Sortie manuelle de la session |
| Back physique | Home | — | Sortie manuelle instantanée |
| Fin de session (cooldown terminé) | Home | — | Retour automatique après dernière étape |

## 5.3 Événements système
- Back physique : ferme l'écran, retour à Home
- Timer : chronomètre tick chaque seconde
- Lifecycle : en pause si app en background (à implémenter ultérieurement)

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| preset | Preset | — | non | Configuration de la session (paramètre d'entrée) |
| currentStep | StepType | preparation | non | Étape actuelle (preparation, work, rest, cooldown) |
| remainingTime | int | preset.preparationSeconds | non | Temps restant en secondes pour l'étape actuelle |
| remainingReps | int | preset.reps | non | Nombre de répétitions restantes |
| isPaused | bool | false | non | Chronomètre en pause ou actif |
| volume | double | — | oui | Volume normalisé [0.0, 1.0], partagé avec Home |
| controlsVisible | bool | true | non | Contrôles visibles ou masqués |
| isExiting | bool | false | non | Indique une demande de sortie manuelle |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| tick | — | — | — | Décrémente remainingTime de 1, joue bip si nécessaire, passe à l'étape suivante si temps écoulé |
| nextStep | — | — | — | Passe à l'étape suivante selon la logique de transition |
| previousStep | — | — | — | Revient à l'étape précédente et réinitialise le chronomètre |
| togglePause | — | — | — | Inverse isPaused, arrête/reprend le chronomètre |
| onVolumeChange | double value | — | — | Met à jour volume et persiste |
| onScreenTap | — | — | — | Affiche contrôles et lance timer de 1500ms pour les masquer |
| onLongPress | — | — | — | Met isExiting à true, déclenche navigation vers Home |
| toggleMute | — | — | — | Met volume à 0 ou restaure valeur précédente |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|
| iconbutton-1 | Activer ou désactiver le son | button | 1 | — | — |
| slider-1 | Curseur de volume | slider | 2 | — | — |
| iconbutton-2 | Précédent | button | 3 | — | — |
| button-1 | Maintenir pour sortir | button | 4 | — | Nécessite long press |
| iconbutton-3 | Suivant | button | 5 | — | — |
| text-1 | Répétitions restantes | text | — | — | Lecture compteur |
| text-2 | Temps restant | text | — | — | Lecture chronomètre |
| text-3 | Étape en cours | text | — | — | Lecture nom étape |
| iconbutton-4 | Mettre en pause / Démarrer | button | 6 | — | Label dynamique selon état |

---

# 8. Thème & tokens requis
- Couleurs sémantiques utilisées : `primary` (#4CD27E), `onPrimary` (#FFFFFF), `background` (#4CD27E), `textPrimary` (#000000), `textSecondary` (#FFFFFF), `sliderActive` (#000000), `sliderInactive` (#E0E0E0), `sliderThumb` (#000000), `ghostButtonBg` (#555555), `prepareColor` (#FFCC00), `workColor` (#4CD27E), `restColor` (#2196F3), `cooldownColor` (rgb(203, 128, 216))
- Typographies référencées (`typographyRef`) : label, value, title
- Exigences de contraste (WCAG AA) : oui

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal

1. **Given** l'écran Workout est lancé avec preset (5/3x(40/20)/10)  
   **When** l'écran s'affiche  
   **Then** currentStep=preparation, remainingTime=5, remainingReps=3, backgroundColor=jaune, text-3="PRÉPARER".

2. **Given** currentStep=preparation, remainingTime=5  
   **When** 5 secondes s'écoulent (5 ticks)  
   **Then** currentStep=work, remainingTime=40, remainingReps=3, backgroundColor=vert, text-3="TRAVAIL".

3. **Given** currentStep=work, remainingTime=40, remainingReps=3  
   **When** 40 secondes s'écoulent  
   **Then** currentStep=rest, remainingTime=20, remainingReps=3, backgroundColor=bleu, text-3="REPOS".

4. **Given** currentStep=rest, remainingTime=20, remainingReps=3  
   **When** 20 secondes s'écoulent  
   **Then** currentStep=work, remainingTime=40, remainingReps=2.

5. **Given** currentStep=work, remainingTime=40, remainingReps=1 (dernière répétition)  
   **When** 40 secondes s'écoulent  
   **Then** currentStep=cooldown (pas de rest), remainingTime=10, backgroundColor=violet, text-3="REFROIDIR".

6. **Given** currentStep=cooldown, remainingTime=10  
   **When** 10 secondes s'écoulent  
   **Then** navigation vers Home (session terminée).

7. **Given** currentStep=work, remainingTime=3  
   **When** 1 seconde s'écoule (remainingTime=2)  
   **Then** bip sonore joué.

8. **Given** currentStep=work, remainingTime=2  
   **When** 1 seconde s'écoule (remainingTime=1)  
   **Then** bip sonore joué.

9. **Given** currentStep=work, remainingTime=1  
   **When** 1 seconde s'écoule (remainingTime=0)  
   **Then** bip sonore joué, puis transition vers rest.

10. **Given** isPaused=false  
    **When** l'utilisateur tap sur iconbutton-4 (pause)  
    **Then** isPaused=true, chronomètre arrêté, icône change en play_arrow.

11. **Given** isPaused=true  
    **When** l'utilisateur tap sur iconbutton-4 (play)  
    **Then** isPaused=false, chronomètre reprend, icône change en pause.

12. **Given** currentStep=work, remainingTime=30  
    **When** l'utilisateur tap sur iconbutton-3 (suivant)  
    **Then** currentStep=rest, remainingTime=20 (passe à l'étape suivante).

13. **Given** currentStep=rest, remainingTime=10  
    **When** l'utilisateur tap sur iconbutton-2 (précédent)  
    **Then** currentStep=work, remainingTime=40 (revient à l'étape précédente).

14. **Given** controlsVisible=true, isPaused=false  
    **When** 1500ms s'écoulent sans interaction  
    **Then** controlsVisible=false (contrôles masqués).

15. **Given** controlsVisible=false  
    **When** l'utilisateur tap n'importe où sur l'écran  
    **Then** controlsVisible=true pendant 1500ms.

16. **Given** l'écran Workout est actif  
    **When** l'utilisateur effectue un long press sur button-1  
    **Then** navigation vers Home (sortie manuelle).

17. **Given** l'écran Workout avec preset (0/3x(40/20)/0) - pas de préparation ni refroidissement  
    **When** l'écran se lance  
    **Then** currentStep=work directement (préparation ignorée car 0 secondes).

18. **Given** currentStep=work, remainingReps=1, preset.cooldownSeconds=0  
    **When** work terminé  
    **Then** navigation vers Home (cooldown ignoré car 0 secondes).

## 9.2 Alternatives / Exceptions
- **Preset invalide** : N/A, validation en amont sur Home  
- **Volume partagé** : Volume chargé depuis SharedPreferences avec même clé que Home  
- **Contrôles pendant pause** : Les contrôles restent visibles, pas de disparition automatique  
- **Back physique** : Sortie instantanée, retour à Home  
- **Dernière répétition** : Pas d'étape rest après le dernier work

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | unit | preset=5/3x(40/20)/10 | initialize | currentStep=preparation, remainingTime=5, remainingReps=3 |
| T2 | unit | currentStep=preparation, remainingTime=1 | tick() | currentStep=work, remainingTime=40 |
| T3 | unit | currentStep=work, remainingTime=1, remainingReps=3 | tick() | currentStep=rest, remainingTime=20, remainingReps=3 |
| T4 | unit | currentStep=rest, remainingTime=1, remainingReps=3 | tick() | currentStep=work, remainingTime=40, remainingReps=2 |
| T5 | unit | currentStep=work, remainingTime=1, remainingReps=1 | tick() | currentStep=cooldown, remainingTime=10 (pas de rest) |
| T6 | unit | remainingTime=2 | tick() | bip sonore joué |
| T7 | unit | remainingTime=1 | tick() | bip sonore joué |
| T8 | unit | remainingTime=1, currentStep=work | tick() | bip sonore joué, puis transition |
| T9 | unit | isPaused=false | togglePause() | isPaused=true |
| T10 | unit | isPaused=true | togglePause() | isPaused=false |
| T11 | unit | currentStep=work | nextStep() | currentStep=rest, remainingTime reset |
| T12 | unit | currentStep=rest | previousStep() | currentStep=work, remainingTime reset |
| T13 | unit | volume=0.5 | onVolumeChange(0.8) | volume=0.8, persisted |
| T14 | unit | controlsVisible=true | onScreenTap() | controlsVisible=true, timer 1500ms lancé |
| T15 | unit | controlsVisible=false | onScreenTap() | controlsVisible=true |
| T16 | unit | preset.preparationSeconds=0 | initialize | currentStep=work (préparation ignorée) |
| T17 | unit | preset.cooldownSeconds=0, currentStep=work, remainingReps=1 | tick() until end | session terminée |
| T18 | widget | — | render | find.byKey('workout__text-2') exists |
| T19 | widget | currentStep=work | — | backgroundColor=#4CD27E |
| T20 | widget | isPaused=false | tap iconbutton-4 | isPaused=true |
| T21 | widget | — | long press button-1 | navigation pop |
| T22 | widget | controlsVisible=false | tap container-1 | contrôles visibles |
| T23 | a11y | — | — | all interactive components have Semantics with label |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Les couleurs du design.json sont fidèles au rendu final | 0.85 |
| 2 | Le slider de volume partage les mêmes clés SharedPreferences que Home | 0.95 |
| 3 | Les bbox sont suffisamment précises pour le layout | 0.75 |
| 4 | Le bip sonore se joue à 2, 1, 0 secondes (pas à 3) | 0.90 |
| 5 | La disparition des contrôles après 1500ms ne s'applique pas pendant la pause | 0.90 |

## 11.2 Hors périmètre
- Écran de fin de session (à développer ultérieurement)
- Gestion du lifecycle app (background/foreground)
- Personnalisation des sons de bip
- Historique des sessions
- Statistiques d'entraînement

## 11.3 Incertitudes / questions ouvertes
- Comportement si l'app passe en background pendant une session ? (actuellement non géré)
- Faut-il sauvegarder l'état de la session pour reprendre après fermeture ? (actuellement non)

---

# 12. Contraintes
- **Authentification** : —
- **Sécurité** : —
- **Performance** : Tick du chronomètre précis à la seconde, pas de drift
- **Accessibilité** : Tous les éléments interactifs doivent avoir des labels sémantiques (WCAG AA)
- **Compatibilité** : iOS et Android

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en secondes, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Textes verbatim avec `style.transform` appliqué (PRÉPARER, TRAVAIL, REPOS, REFROIDIR).
- Enum StepType : `preparation`, `work`, `rest`, `cooldown`
- Logique de transition : preparation → work → rest → work → rest → ... → work (dernière) → cooldown → fin
- Règle spéciale : dernière répétition n'a pas de rest
- Règle spéciale : étapes à 0 secondes sont ignorées

