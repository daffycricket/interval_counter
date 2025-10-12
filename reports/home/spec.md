---
# Deterministic Functional Spec — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
specVersion: 2
generatedAt: 2025-10-12T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : IntervalTimerHome
- **Code technique / ID** : `interval_timer_home`
- **Type d'écran** : Form + List (configuration rapide + préréglages)
- **Orientation supportée** : Portrait (scrollable)
- **Objectifs et fonctions principales** :
  - Configurer rapidement un minuteur d'intervalle (répétitions, travail, repos)
  - Démarrer une session d'intervalle
  - Gérer les préréglages sauvegardés
  - Ajuster le volume des notifications sonores

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId | type | variant | key (stable) | texte (après transform) |
|-----|--------|------|---------|--------------|------------------------|
| 1 | Container-1 | Container | — | interval_timer_home__container_1 | — |
| 2 | IconButton-2 | IconButton | ghost | interval_timer_home__icon_button_2 | — |
| 3 | Slider-3 | Slider | — | interval_timer_home__slider_3 | — |
| 4 | Icon-4 | Icon | — | interval_timer_home__icon_4 | — |
| 5 | IconButton-5 | IconButton | ghost | interval_timer_home__icon_button_5 | — |
| 6 | Card-6 | Card | — | interval_timer_home__card_6 | — |
| 7 | Container-7 | Container | — | interval_timer_home__container_7 | — |
| 8 | Text-8 | Text | — | interval_timer_home__text_8 | "Démarrage rapide" |
| 9 | IconButton-9 | IconButton | ghost | interval_timer_home__icon_button_9 | — |
| 10 | Text-10 | Text | — | interval_timer_home__text_10 | "RÉPÉTITIONS" |
| 11 | IconButton-11 | IconButton | ghost | interval_timer_home__icon_button_11 | — |
| 12 | Text-12 | Text | — | interval_timer_home__text_12 | "16" |
| 13 | IconButton-13 | IconButton | ghost | interval_timer_home__icon_button_13 | — |
| 14 | Text-14 | Text | — | interval_timer_home__text_14 | "TRAVAIL" |
| 15 | IconButton-15 | IconButton | ghost | interval_timer_home__icon_button_15 | — |
| 16 | Text-16 | Text | — | interval_timer_home__text_16 | "00 : 44" |
| 17 | IconButton-17 | IconButton | ghost | interval_timer_home__icon_button_17 | — |
| 18 | Text-18 | Text | — | interval_timer_home__text_18 | "REPOS" |
| 19 | IconButton-19 | IconButton | ghost | interval_timer_home__icon_button_19 | — |
| 20 | Text-20 | Text | — | interval_timer_home__text_20 | "00 : 15" |
| 21 | IconButton-21 | IconButton | ghost | interval_timer_home__icon_button_21 | — |
| 22 | Button-22 | Button | ghost | interval_timer_home__button_22 | "SAUVEGARDER" |
| 23 | Button-23 | Button | cta | interval_timer_home__button_23 | "COMMENCER" |
| 24 | Container-24 | Container | — | interval_timer_home__container_24 | — |
| 25 | Text-25 | Text | — | interval_timer_home__text_25 | "VOS PRÉRÉGLAGES" |
| 26 | IconButton-26 | IconButton | ghost | interval_timer_home__icon_button_26 | — |
| 27 | Button-27 | Button | secondary | interval_timer_home__button_27 | "+ AJOUTER" |
| 28 | Card-28 | Card | — | interval_timer_home__card_28 | — |
| 29 | Container-29 | Container | — | interval_timer_home__container_29 | — |
| 30 | Text-30 | Text | — | interval_timer_home__text_30 | "gainage" |
| 31 | Text-31 | Text | — | interval_timer_home__text_31 | "14:22" |
| 32 | Text-32 | Text | — | interval_timer_home__text_32 | "RÉPÉTITIONS 20x" |
| 33 | Text-33 | Text | — | interval_timer_home__text_33 | "TRAVAIL 00:40" |
| 34 | Text-34 | Text | — | interval_timer_home__text_34 | "REPOS 00:03" |

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|-------------------|------------------------------|
| s_header | — | En-tête avec contrôles volume et menu | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5 |
| s_quick_start | "Démarrage rapide" | Configuration rapide du minuteur | Card-6, Container-7, Text-8, IconButton-9, Text-10/12/14/16/18/20, IconButton-11/13/15/17/19/21, Button-22, Button-23 |
| s_presets_header | "VOS PRÉRÉGLAGES" | En-tête de la section préréglages | Container-24, Text-25, IconButton-26, Button-27 |
| s_preset_card | "gainage" | Carte de préréglage exemple | Card-28, Container-29, Text-30/31/32/33/34 |

## 2.3 Libellés & textes
| usage | valeur (verbatim + transform) |
|-------|------------------------------|
| Titre section | "Démarrage rapide" |
| Labels champs | "RÉPÉTITIONS", "TRAVAIL", "REPOS" |
| Valeurs | "16", "00 : 44", "00 : 15" |
| Boutons actions | "SAUVEGARDER", "COMMENCER", "+ AJOUTER" |
| Titre section | "VOS PRÉRÉGLAGES" |
| Nom préréglage | "gainage" |
| Durée totale | "14:22" |
| Détails préréglage | "RÉPÉTITIONS 20x", "TRAVAIL 00:40", "REPOS 00:03" |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|------------------|----------------|---------|-------------------|
| preset_list | nom, durée, détails (répétitions/travail/repos) | chronologique inverse (plus récent d'abord) | — | Afficher message "Aucun préréglage. Créez-en un avec + AJOUTER" |

---

# 3. Interactions (par composant interactif)
| compId | type | variant → rôle | a11y.ariaLabel | action (onTap/submit/…) | état(s) impactés | navigation |
|--------|------|----------------|----------------|------------------------|------------------|------------|
| IconButton-2 | IconButton | ghost → faible | "Régler le volume" | `toggleVolumeControl()` | volumeControlVisible | — |
| Slider-3 | Slider | — | "Curseur de volume" | `updateVolume(value)` | volume | — |
| IconButton-5 | IconButton | ghost → faible | "Plus d'options" | `showOptionsMenu()` | — | Menu contextuel |
| IconButton-9 | IconButton | ghost → faible | "Replier la section Démarrage rapide" | `toggleQuickStartSection()` | quickStartExpanded | — |
| IconButton-11 | IconButton | ghost → faible | "Diminuer les répétitions" | `decrementReps()` | reps | — |
| IconButton-13 | IconButton | ghost → faible | "Augmenter les répétitions" | `incrementReps()` | reps | — |
| IconButton-15 | IconButton | ghost → faible | "Diminuer le temps de travail" | `decrementWorkTime()` | workSeconds | — |
| IconButton-17 | IconButton | ghost → faible | "Augmenter le temps de travail" | `incrementWorkTime()` | workSeconds | — |
| IconButton-19 | IconButton | ghost → faible | "Diminuer le temps de repos" | `decrementRestTime()` | restSeconds | — |
| IconButton-21 | IconButton | ghost → faible | "Augmenter le temps de repos" | `incrementRestTime()` | restSeconds | — |
| Button-22 | Button | ghost → faible | "Sauvegarder le préréglage rapide" | `saveQuickStartAsPreset()` | presets (ajout) | — |
| Button-23 | Button | cta → primaire | "Démarrer l'intervalle" | `startInterval()` | — | TimerRunningScreen |
| IconButton-26 | IconButton | ghost → faible | "Éditer les préréglages" | `enterEditMode()` | presetsEditMode | — |
| Button-27 | Button | secondary → support | "Ajouter un préréglage" | `createNewPreset()` | — | PresetEditorScreen |
| Card-28 | Card | — (tapable) | "Charger préréglage gainage" | `loadPreset(presetId)` | reps, workSeconds, restSeconds | — |

- **Gestes & clavier** : tap (boutons, cartes), drag (slider), long-press (carte préréglage → menu contextuel)
- **Feedback** : 
  - Bouton "COMMENCER" désactivé si valeurs invalides
  - Animation de transition vers écran de minuteur
  - Snackbar "Préréglage sauvegardé" après sauvegarde
  - Ripple effect sur tous les éléments tapable
- **Règles de placement ayant un impact** : 
  - Bouton "COMMENCER" : placement=start, widthMode=fill → pleine largeur, icône à gauche
  - Bouton "SAUVEGARDER" : placement=end, widthMode=intrinsic → à droite, largeur contenu
  - Bouton "+ AJOUTER" : placement=end, widthMode=intrinsic → à droite, largeur contenu

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| reps (Text-12) | >= 1, <= 99 | "Les répétitions doivent être entre 1 et 99" |
| workSeconds (Text-16) | >= 1, <= 3599 (59:59) | "Le temps de travail doit être entre 00:01 et 59:59" |
| restSeconds (Text-20) | >= 0, <= 3599 (59:59) | "Le temps de repos doit être entre 00:00 et 59:59" |
| volume (Slider-3) | 0.0 - 1.0 | — |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|-------|-----------|-----------|-------|
| Bouton COMMENCER enabled | reps >= 1 AND workSeconds >= 1 | Bouton activé/grisé | — |
| Durée totale préréglage | totalDuration = reps × (workSeconds + restSeconds) | Affichée sur carte préréglage (Text-31) | Format MM:SS |
| Section "Démarrage rapide" pliable | quickStartExpanded = true/false | Affichage/masquage des contrôles | IconButton-9 change d'icône (expand_less/expand_more) |
| Liste préréglages vide | presets.length == 0 | Affichage empty state | "Aucun préréglage. Créez-en un avec + AJOUTER" |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Aucun préréglage | Message "Aucun préréglage. Créez-en un avec + AJOUTER" dans zone préréglages | Tap "+ AJOUTER" |
| Échec sauvegarde préréglage | Snackbar "Erreur lors de la sauvegarde" | Réessayer |
| Échec chargement préréglages | Snackbar "Impossible de charger les préréglages" | Actualiser |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Lancement app | — | — | Écran d'accueil par défaut |
| Retour depuis minuteur | TimerRunningScreen | — | Back navigation |
| Retour depuis éditeur préréglage | PresetEditorScreen | newPreset (optionnel) | Si créé, ajouter à la liste |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| Tap Button-23 "COMMENCER" | TimerRunningScreen | { reps, workSeconds, restSeconds, volume } | — |
| Tap Button-27 "+ AJOUTER" | PresetEditorScreen | — | Mode création |
| Tap IconButton-26 "Éditer" | PresetEditorScreen | { mode: 'edit', presetIds: selectedPresets } | Mode édition/suppression |
| Tap Card-28 (préréglage) | — | — | Charge le préréglage dans section "Démarrage rapide" |
| Tap IconButton-5 "Plus d'options" | Menu contextuel | — | Overlay modal |

## 5.3 Événements système
- **Back physique** : Quitte l'application (écran racine)
- **Timer / notifications** : —
- **Permissions** : Volume system (Android) si nécessaire

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé | type | défaut | persistance | notes |
|-----|------|--------|-------------|-------|
| reps | int | 16 | SharedPreferences | Répétitions |
| workSeconds | int | 44 | SharedPreferences | Temps de travail en secondes |
| restSeconds | int | 15 | SharedPreferences | Temps de repos en secondes |
| volume | double | 0.62 | SharedPreferences | Volume normalisé [0.0-1.0] |
| quickStartExpanded | bool | true | non | Section "Démarrage rapide" dépliée |
| presets | List<Preset> | [] | SharedPreferences (JSON) | Liste des préréglages |
| presetsEditMode | bool | false | non | Mode édition préréglages |

## 6.2 Actions / effets
| nom | entrée | sortie | erreurs | description |
|-----|--------|--------|---------|-------------|
| incrementReps | — | void | — | reps++ (max 99) |
| decrementReps | — | void | — | reps-- (min 1) |
| incrementWorkTime | — | void | — | workSeconds += step (ex: 5s) |
| decrementWorkTime | — | void | — | workSeconds -= step (min 1) |
| incrementRestTime | — | void | — | restSeconds += step (ex: 5s) |
| decrementRestTime | — | void | — | restSeconds -= step (min 0) |
| updateVolume | double value | void | — | volume = value |
| saveQuickStartAsPreset | — | void | StorageError | Crée Preset(name, reps, workSeconds, restSeconds), ajoute à presets, persiste |
| loadPreset | String presetId | void | — | Charge reps, workSeconds, restSeconds depuis preset |
| startInterval | — | void | ValidationError | Valide les valeurs, navigue vers TimerRunningScreen |
| toggleQuickStartSection | — | void | — | quickStartExpanded = !quickStartExpanded |
| enterEditMode | — | void | — | presetsEditMode = true |
| createNewPreset | — | void | — | Navigue vers PresetEditorScreen |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|-------------------|-----------------|-------------|------------|-------|
| IconButton-2 | "Régler le volume" | button | 1 | — | — |
| Slider-3 | "Curseur de volume" | slider | 2 | — | — |
| IconButton-5 | "Plus d'options" | button | 3 | — | Menu contextuel |
| IconButton-9 | "Replier la section Démarrage rapide" | button | 4 | — | Toggle expand/collapse |
| IconButton-11 | "Diminuer les répétitions" | button | 5 | — | — |
| Text-12 | — | text | — | — | Valeur éditable (tap pour input direct) |
| IconButton-13 | "Augmenter les répétitions" | button | 6 | — | — |
| IconButton-15 | "Diminuer le temps de travail" | button | 7 | — | — |
| Text-16 | — | text | — | — | Valeur éditable (tap pour input direct) |
| IconButton-17 | "Augmenter le temps de travail" | button | 8 | — | — |
| IconButton-19 | "Diminuer le temps de repos" | button | 9 | — | — |
| Text-20 | — | text | — | — | Valeur éditable (tap pour input direct) |
| IconButton-21 | "Augmenter le temps de repos" | button | 10 | — | — |
| Button-22 | "Sauvegarder le préréglage rapide" | button | 11 | — | — |
| Button-23 | "Démarrer l'intervalle" | button | 12 | Enter | Action primaire |
| IconButton-26 | "Éditer les préréglages" | button | 13 | — | — |
| Button-27 | "Ajouter un préréglage" | button | 14 | — | — |
| Card-28 | "Charger préréglage gainage" | button | 15+ | — | Sémantique implicite (tap sur carte) |

---

# 8. Thème & tokens requis
- **Couleurs sémantiques utilisées** : 
  - `primary` (#607D8B) : boutons, icônes interactives
  - `cta` (#607D8B) : bouton "COMMENCER"
  - `accent` (#FFC107) : icône éclair dans bouton "COMMENCER"
  - `background` (#F2F2F2) : fond d'écran
  - `surface` (#FFFFFF) : cartes, boutons
  - `textPrimary` (#212121) : titres, valeurs
  - `textSecondary` (#616161) : labels, métadonnées
  - `divider` (#E0E0E0) : bordures cartes
  - `border` (#DDDDDD) : bordures boutons
  - `headerBackgroundDark` (#455A64) : en-tête volume
  - `presetCardBg` (#FAFAFA) : fond carte préréglage
  - `sliderActive` (#FFFFFF) : track actif slider
  - `sliderInactive` (#90A4AE) : track inactif slider
  - `sliderThumb` (#FFFFFF) : thumb slider

- **Typographies référencées (`typographyRef`)** : 
  - `titleLarge` : "Démarrage rapide" (20px, bold)
  - `title` : "VOS PRÉRÉGLAGES" (16px, bold), "gainage" (20px, bold)
  - `label` : "RÉPÉTITIONS", "TRAVAIL", "REPOS" (12px, medium, uppercase), boutons (14px, medium)
  - `value` : valeurs numériques/temps (24px, bold)
  - `body` : détails préréglages (14px, regular)

- **Exigences de contraste (WCAG AA)** : oui
  - Ratio minimum 4.5:1 pour textes normaux
  - Ratio minimum 3:1 pour textes larges (≥18px) et éléments UI

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran est affiché avec reps=16, workSeconds=44, restSeconds=15  
   **When** l'utilisateur appuie sur **COMMENCER**  
   **Then** navigation vers `TimerRunningScreen` avec paramètres { reps: 16, workSeconds: 44, restSeconds: 15, volume: 0.62 }.

2. **Given** l'écran est affiché  
   **When** l'utilisateur appuie sur IconButton-13 ("Augmenter les répétitions") 3 fois  
   **Then** `reps` passe de 16 à 19, Text-12 affiche "19".

3. **Given** l'écran est affiché avec reps=16, workSeconds=44, restSeconds=15  
   **When** l'utilisateur appuie sur **SAUVEGARDER**  
   **Then** un dialog demande le nom du préréglage, puis le préréglage est ajouté à la liste et une snackbar "Préréglage sauvegardé" apparaît.

4. **Given** l'écran est affiché avec au moins un préréglage "gainage"  
   **When** l'utilisateur appuie sur Card-28 (préréglage "gainage")  
   **Then** les valeurs reps=20, workSeconds=40, restSeconds=3 sont chargées dans la section "Démarrage rapide".

5. **Given** l'écran est affiché  
   **When** l'utilisateur drag le Slider-3 à 80%  
   **Then** `volume` passe à 0.8 et le volume système est mis à jour.

## 9.2 Alternatives / Exceptions
1. **Given** reps=1  
   **When** l'utilisateur appuie sur IconButton-11 ("Diminuer les répétitions")  
   **Then** `reps` reste à 1 (minimum atteint), feedback haptique optionnel.

2. **Given** workSeconds=1  
   **When** l'utilisateur appuie sur IconButton-15 ("Diminuer le temps de travail")  
   **Then** `workSeconds` reste à 1 (minimum atteint).

3. **Given** restSeconds=3599 (59:59)  
   **When** l'utilisateur appuie sur IconButton-21 ("Augmenter le temps de repos")  
   **Then** `restSeconds` reste à 3599 (maximum atteint).

4. **Given** aucun préréglage n'existe (presets = [])  
   **When** l'écran s'affiche  
   **Then** la zone préréglages affiche "Aucun préréglage. Créez-en un avec + AJOUTER".

5. **Given** l'utilisateur a modifié les valeurs mais ne les a pas sauvegardées  
   **When** l'utilisateur charge un préréglage  
   **Then** les modifications non sauvegardées sont perdues (pas de confirmation).

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | widget | État initial (reps=16) | 1. Trouve IconButton-13 par key<br>2. Tap | Text-12 affiche "17" |
| T2 | widget | État initial | 1. Trouve IconButton-11 par key<br>2. Tap | Text-12 affiche "15" |
| T3 | widget | reps=1 | 1. Trouve IconButton-11 par key<br>2. Tap | Text-12 reste "1" |
| T4 | widget | État initial | 1. Trouve Button-23 par key<br>2. Tap | Navigation vers TimerRunningScreen |
| T5 | widget | État initial | 1. Trouve Button-22 par key<br>2. Tap | Dialog de saisie nom apparaît |
| T6 | widget | presets = [gainage] | 1. Trouve Card-28 par key<br>2. Tap | reps=20, workSeconds=40, restSeconds=3 chargés |
| T7 | widget | État initial | 1. Trouve Slider-3 par key<br>2. Drag à 0.8 | volume = 0.8 |
| T8 | golden | État initial | — | Capture snapshot écran |
| T9 | golden | presets = [] | — | Capture snapshot empty state préréglages |
| T10 | unit | reps=1, decrementReps() | — | reps reste 1 |
| T11 | unit | reps=99, incrementReps() | — | reps reste 99 |
| T12 | unit | workSeconds=1, decrementWorkTime() | — | workSeconds reste 1 |
| T13 | unit | calcul durée totale | reps=20, work=40, rest=3 | totalDuration = 860 secondes (14:20) |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Les couleurs sont estimées à partir du rendu (matériel design gris/bleu) | 0.75 |
| 2 | Le nom d'icône 'expand_less' est supposé pour le chevron de repli | 0.70 |
| 3 | Les positions/bbox sont approchées par inspection visuelle (sans mesure pixel-perfect) | 0.70 |
| 4 | La valeur du slider est normalisée à ~0.62 d'après la position du pouce | 0.70 |
| 5 | Les boutons 'Sauvegarder' et '+ Ajouter' sont modélisés en variant ghost/secondary selon le rendu non rempli | 0.80 |
| 6 | Le temps de travail affiché "00 : 44" correspond à 44 secondes (pas 44 minutes) | 0.85 |
| 7 | Tap sur les valeurs Text-12/16/20 ouvre un input numérique direct (pas implémenté dans design.json) | 0.60 |

## 11.2 Hors périmètre
- Édition avancée des préréglages (réordonnancement, suppression multiple)
- Synchronisation cloud des préréglages
- Partage de préréglages
- Statistiques d'utilisation
- Thèmes personnalisés
- Prévisualisation sonore du volume

## 11.3 Incertitudes / questions ouvertes
- Le bouton "Plus d'options" (IconButton-5) ouvre-t-il un menu ou une page de paramètres ?
- Les valeurs min/max exactes pour reps/workSeconds/restSeconds doivent-elles être configurables ?
- Le format de temps "00 : 44" avec espaces est-il volontaire ou une erreur de transcription ?
- Faut-il un dialogue de confirmation lors du chargement d'un préréglage qui écrase les valeurs modifiées ?
- Le bouton "Éditer les préréglages" active-t-il un mode d'édition in-place ou navigue vers un écran dédié ?

---

# 12. Contraintes
- **Authentification** : Non requis (application locale)
- **Sécurité** : 
  - Validation des entrées utilisateur (min/max reps, temps)
  - Persistance locale sécurisée (pas de données sensibles)
- **Performance** : 
  - Chargement initial < 300ms
  - Réactivité des boutons +/- < 50ms
  - Animations fluides 60fps
- **Accessibilité** : 
  - Support TalkBack/VoiceOver
  - Contraste WCAG AA
  - Taille minimale des cibles tactiles 48x48dp
  - Labels sémantiques sur tous les éléments interactifs
- **Compatibilité** : 
  - Android 6.0+ (API 23+)
  - iOS 12+
  - Orientation portrait uniquement
  - Écrans 5" à 7" (smartphones)

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : 
  - Dates : ISO‑8601 (YYYY-MM-DDTHH:MM:SSZ)
  - Temps : MM:SS ou HH:MM:SS
  - Nombres : entiers en px pour bbox, float 0.0-1.0 pour volume normalisé
  - Booléens : `true|false`
- Interdictions : 
  - Pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`)
  - Pas de texte « TBD » ou « TODO »
  - Pas d'ambiguïté dans les noms de clés
- Clés stables obligatoires : format `{screenId}__{compId}` (ex: `interval_timer_home__button_23`)
- Mapping design→code 1:1 pour les composants identifiés

