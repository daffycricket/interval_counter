---
# Spécification Fonctionnelle Déterministe — Écran d'Accueil

# YAML front matter pour lisibilité machine
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
- **Type d'écran** : Form / Settings
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Permettre à l'utilisateur de configurer rapidement un intervalle de travail (répétitions, temps de travail, temps de repos)
  - Démarrer un intervalle avec la configuration actuelle
  - Gérer des préréglages sauvegardés
  - Contrôler le volume de notification

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId | type        | variant   | key (stable)                      | texte (après transform) |
|-----|--------|-------------|-----------|-----------------------------------|-------------------------|
| 1   | Container-1 | Container | — | interval_timer_home__Container-1 | — |
| 2   | IconButton-2 | IconButton | ghost | interval_timer_home__IconButton-2 | — |
| 3   | Slider-3 | Slider | — | interval_timer_home__Slider-3 | — |
| 4   | Icon-4 | Icon | — | interval_timer_home__Icon-4 | — |
| 5   | IconButton-5 | IconButton | ghost | interval_timer_home__IconButton-5 | — |
| 6   | Card-6 | Card | — | interval_timer_home__Card-6 | — |
| 7   | Container-7 | Container | — | interval_timer_home__Container-7 | — |
| 8   | Text-8 | Text | — | interval_timer_home__Text-8 | Démarrage rapide |
| 9   | IconButton-9 | IconButton | ghost | interval_timer_home__IconButton-9 | — |
| 10  | Text-10 | Text | — | interval_timer_home__Text-10 | RÉPÉTITIONS |
| 11  | IconButton-11 | IconButton | ghost | interval_timer_home__IconButton-11 | — |
| 12  | Text-12 | Text | — | interval_timer_home__Text-12 | 16 |
| 13  | IconButton-13 | IconButton | ghost | interval_timer_home__IconButton-13 | — |
| 14  | Text-14 | Text | — | interval_timer_home__Text-14 | TRAVAIL |
| 15  | IconButton-15 | IconButton | ghost | interval_timer_home__IconButton-15 | — |
| 16  | Text-16 | Text | — | interval_timer_home__Text-16 | 00 : 44 |
| 17  | IconButton-17 | IconButton | ghost | interval_timer_home__IconButton-17 | — |
| 18  | Text-18 | Text | — | interval_timer_home__Text-18 | REPOS |
| 19  | IconButton-19 | IconButton | ghost | interval_timer_home__IconButton-19 | — |
| 20  | Text-20 | Text | — | interval_timer_home__Text-20 | 00 : 15 |
| 21  | IconButton-21 | IconButton | ghost | interval_timer_home__IconButton-21 | — |
| 22  | Button-22 | Button | ghost | interval_timer_home__Button-22 | SAUVEGARDER |
| 23  | Button-23 | Button | cta | interval_timer_home__Button-23 | COMMENCER |
| 24  | Container-24 | Container | — | interval_timer_home__Container-24 | — |
| 25  | Text-25 | Text | — | interval_timer_home__Text-25 | VOS PRÉRÉGLAGES |
| 26  | IconButton-26 | IconButton | ghost | interval_timer_home__IconButton-26 | — |
| 27  | Button-27 | Button | secondary | interval_timer_home__Button-27 | + AJOUTER |
| 28  | Card-28 | Card | — | interval_timer_home__Card-28 | — |
| 29  | Container-29 | Container | — | interval_timer_home__Container-29 | — |
| 30  | Text-30 | Text | — | interval_timer_home__Text-30 | gainage |
| 31  | Text-31 | Text | — | interval_timer_home__Text-31 | 14:22 |
| 32  | Text-32 | Text | — | interval_timer_home__Text-32 | RÉPÉTITIONS 20x |
| 33  | Text-33 | Text | — | interval_timer_home__Text-33 | TRAVAIL 00:40 |
| 34  | Text-34 | Text | — | interval_timer_home__Text-34 | REPOS 00:03 |

> Règle de clé: `{screenName}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|--------------------|-------------------------------|
| s_header  | — | En-tête avec contrôle volume et menu | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5 |
| s_quick_start | Démarrage rapide | Configuration rapide d'intervalle | Card-6 avec Container-7, Text-8, IconButton-9, Text-10 à Text-21, Button-22, Button-23 |
| s_presets_header | VOS PRÉRÉGLAGES | Barre de titre pour la section préréglages | Container-24, Text-25, IconButton-26, Button-27 |
| s_presets_list | — | Liste de cartes de préréglages | Card-28, Container-29, Text-30 à Text-34 |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Titre section | Démarrage rapide |
| Labels | RÉPÉTITIONS, TRAVAIL, REPOS, VOS PRÉRÉGLAGES |
| Valeurs | 16, 00 : 44, 00 : 15 |
| Boutons | SAUVEGARDER, COMMENCER, + AJOUTER |
| Préréglage exemple | gainage, 14:22, RÉPÉTITIONS 20x, TRAVAIL 00:40, REPOS 00:03 |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|
| presets_list | nom, durée totale, détails (répétitions/travail/repos) | chronologique (ajout) | — | "Aucun préréglage sauvegardé. Appuyez sur + AJOUTER pour créer." |

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| IconButton-2 | IconButton | ghost → faible | Régler le volume | `toggleVolumePanel()` | volumePanelVisible | — |
| Slider-3 | Slider | — → contrôle | Curseur de volume | `onVolumeChange(value)` | volume (0.0-1.0) | — |
| IconButton-5 | IconButton | ghost → faible | Plus d'options | `showContextMenu()` | — | Menu contextuel |
| IconButton-9 | IconButton | ghost → faible | Replier la section Démarrage rapide | `toggleQuickStartSection()` | quickStartExpanded | — |
| IconButton-11 | IconButton | ghost → faible | Diminuer les répétitions | `decrementReps()` | reps (min: 1) | — |
| IconButton-13 | IconButton | ghost → faible | Augmenter les répétitions | `incrementReps()` | reps (max: 99) | — |
| IconButton-15 | IconButton | ghost → faible | Diminuer le temps de travail | `decrementWorkTime()` | workSeconds (min: 5) | — |
| IconButton-17 | IconButton | ghost → faible | Augmenter le temps de travail | `incrementWorkTime()` | workSeconds (max: 3600) | — |
| IconButton-19 | IconButton | ghost → faible | Diminuer le temps de repos | `decrementRestTime()` | restSeconds (min: 0) | — |
| IconButton-21 | IconButton | ghost → faible | Augmenter le temps de repos | `incrementRestTime()` | restSeconds (max: 3600) | — |
| Button-22 | Button | ghost → faible | Sauvegarder le préréglage rapide | `saveCurrentAsPreset()` | presets | Dialogue de saisie nom |
| Button-23 | Button | cta → primaire | Démarrer l'intervalle | `startInterval()` | — | → TimerRunning screen |
| IconButton-26 | IconButton | ghost → faible | Éditer les préréglages | `enterEditMode()` | presetsEditMode | — |
| Button-27 | Button | secondary → support | Ajouter un préréglage | `createNewPreset()` | — | → PresetEditor screen |
| Card-28 | Card (tap) | — → sélection | Sélectionner préréglage gainage | `loadPreset('gainage')` | reps, workSeconds, restSeconds | — |

- **Gestes & clavier** : 
  - Tap sur Card-28 : charge le préréglage dans la section "Démarrage rapide"
  - Long-press sur Card-28 : affiche menu contextuel (éditer/supprimer)
- **Feedback** : 
  - Incrémentation/décrémentation : haptic feedback léger
  - Sauvegarde réussie : SnackBar "Préréglage sauvegardé"
  - Démarrage intervalle : animation de transition
  - Boutons temporairement désactivés pendant les actions
- **Règles de placement ayant un impact** : 
  - Button-22 (SAUVEGARDER) : placement=end, widthMode=intrinsic (aligné à droite)
  - Button-23 (COMMENCER) : widthMode=fill (pleine largeur)
  - Button-27 (+ AJOUTER) : placement=end, widthMode=intrinsic (aligné à droite)

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| reps | >= 1, <= 99, entier | "Les répétitions doivent être entre 1 et 99" |
| workSeconds | >= 5, <= 3600, entier | "Le temps de travail doit être entre 00:05 et 60:00" |
| restSeconds | >= 0, <= 3600, entier | "Le temps de repos doit être entre 00:00 et 60:00" |
| preset.name | non vide, max 50 caractères | "Le nom du préréglage ne peut pas être vide" |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|------|-----------|-----------|-------|
| Durée totale préréglage | reps × (workSeconds + restSeconds) | Affichée au format MM:SS dans Text-31 | Format "14:22" |
| Incrémentation temps | Incrément par 5 secondes | Affichage texte mis à jour (Text-16, Text-20) | Format "MM : SS" avec espaces |
| Visibilité section Démarrage rapide | quickStartExpanded == true | Card-6 visible | IconButton-9 rotate 180° quand collapsed |
| Mode édition préréglages | presetsEditMode == true | Icônes de suppression apparaissent sur chaque Card-28 | — |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Aucun préréglage | Texte centré dans s_presets_list : "Aucun préréglage sauvegardé.\nAppuyez sur + AJOUTER pour créer." | Tap Button-27 |
| Erreur chargement préréglages | SnackBar "Impossible de charger les préréglages" + retry button | Retry |
| Sauvegarde échouée | SnackBar "Échec de la sauvegarde. Réessayez." + dismiss | Dismiss ou retry |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Lancement app | Splash | — | Premier écran |
| Retour depuis TimerRunning | TimerRunning | — | Si intervalle terminé ou annulé |
| Retour depuis PresetEditor | PresetEditor | newPreset?: Preset | Si nouveau préréglage créé |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| Button-23 tap | TimerRunning | { reps, workSeconds, restSeconds } | Démarre l'intervalle |
| Button-27 tap | PresetEditor | { mode: 'create' } | Création nouveau préréglage |
| Card-28 long-press → Éditer | PresetEditor | { mode: 'edit', presetId } | Édition préréglage existant |
| IconButton-5 tap → Paramètres | Settings | — | Navigation menu contextuel |

## 5.3 Événements système
- **Back physique** : Quitte l'app (confirmer si édition en cours)
- **Timer / notifications** : Notification de fin d'intervalle peut ramener sur cet écran
- **Permissions** : Notification permission demandée au premier démarrage d'intervalle

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| reps | int | 16 | SharedPreferences (quick_start) | Nombre de répétitions |
| workSeconds | int | 44 | SharedPreferences (quick_start) | Temps de travail en secondes |
| restSeconds | int | 15 | SharedPreferences (quick_start) | Temps de repos en secondes |
| volume | double | 0.62 | SharedPreferences | 0.0 à 1.0 |
| volumePanelVisible | bool | false | non | Affichage panneau volume étendu |
| quickStartExpanded | bool | true | SharedPreferences | Section Démarrage rapide dépliée |
| presetsEditMode | bool | false | non | Mode édition liste préréglages |
| presets | List\<Preset\> | [] | SharedPreferences (JSON) | Liste des préréglages sauvegardés |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| incrementReps | — | void | — | reps++, max 99 |
| decrementReps | — | void | — | reps--, min 1 |
| incrementWorkTime | — | void | — | workSeconds += 5, max 3600 |
| decrementWorkTime | — | void | — | workSeconds -= 5, min 5 |
| incrementRestTime | — | void | — | restSeconds += 5, max 3600 |
| decrementRestTime | — | void | — | restSeconds -= 5, min 0 |
| onVolumeChange | double value | void | — | volume = value, persiste |
| toggleQuickStartSection | — | void | — | quickStartExpanded = !quickStartExpanded |
| saveCurrentAsPreset | — | Future\<void\> | StorageException | Dialogue nom, puis sauvegarde Preset(name, reps, work, rest) |
| loadPreset | String presetId | void | — | Charge reps/work/rest depuis preset, scroll vers Card-6 |
| startInterval | — | void | — | Navigate vers TimerRunning avec config actuelle |
| createNewPreset | — | void | — | Navigate vers PresetEditor(mode: create) |
| enterEditMode | — | void | — | presetsEditMode = true |
| deletePreset | String presetId | Future\<void\> | StorageException | Supprime preset de la liste, persiste |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|------------|------------|-------|
| IconButton-2 | Régler le volume | button | 1 | — | Icône volume |
| Slider-3 | Curseur de volume | slider | 2 | Flèches gauche/droite | Valeur annoncée en % |
| IconButton-5 | Plus d'options | button | 3 | — | Menu contextuel |
| IconButton-9 | Replier la section Démarrage rapide | button | 4 | — | État expanded/collapsed annoncé |
| IconButton-11 | Diminuer les répétitions | button | 5 | — | Valeur actuelle annoncée après action |
| Text-12 | — | text (value) | — | — | Annoncé comme "16 répétitions" |
| IconButton-13 | Augmenter les répétitions | button | 6 | — | Valeur actuelle annoncée après action |
| IconButton-15 | Diminuer le temps de travail | button | 7 | — | Durée annoncée après action |
| Text-16 | — | text (value) | — | — | Annoncé comme "44 secondes de travail" |
| IconButton-17 | Augmenter le temps de travail | button | 8 | — | Durée annoncée après action |
| IconButton-19 | Diminuer le temps de repos | button | 9 | — | Durée annoncée après action |
| Text-20 | — | text (value) | — | — | Annoncé comme "15 secondes de repos" |
| IconButton-21 | Augmenter le temps de repos | button | 10 | — | Durée annoncée après action |
| Button-22 | Sauvegarder le préréglage rapide | button | 11 | — | — |
| Button-23 | Démarrer l'intervalle | button (primary) | 12 | Enter | Action principale de l'écran |
| IconButton-26 | Éditer les préréglages | button | 13 | — | Mode édition activé |
| Button-27 | Ajouter un préréglage | button | 14 | — | — |
| Card-28 | Sélectionner préréglage gainage | button | 15 | — | Annoncé avec nom + durée totale |

---

# 8. Thème & tokens requis
- **Couleurs sémantiques utilisées** : 
  - `primary` (#607D8B) : boutons, icônes actives
  - `onPrimary` (#FFFFFF) : texte sur fond primary
  - `background` (#F2F2F2) : fond d'écran
  - `surface` (#FFFFFF) : cartes, boutons
  - `textPrimary` (#212121) : texte principal
  - `textSecondary` (#616161) : labels, texte secondaire
  - `divider` (#E0E0E0) : bordures de cartes
  - `accent` (#FFC107) : icône éclair (Button-23)
  - `sliderActive` (#FFFFFF) : piste active slider
  - `sliderInactive` (#90A4AE) : piste inactive slider
  - `sliderThumb` (#FFFFFF) : pouce slider
  - `border` (#DDDDDD) : bordures boutons
  - `cta` (#607D8B) : bouton principal
  - `headerBackgroundDark` (#455A64) : en-tête
  - `presetCardBg` (#FAFAFA) : fond cartes préréglages

- **Typographies référencées (`typographyRef`)** : 
  - `titleLarge` : titre "Démarrage rapide"
  - `label` : labels uppercase (RÉPÉTITIONS, TRAVAIL, REPOS, boutons)
  - `value` : valeurs numériques (16, 00:44, 00:15, 14:22)
  - `title` : titres sections (VOS PRÉRÉGLAGES), noms préréglages
  - `body` : détails préréglages (RÉPÉTITIONS 20x, etc.)

- **Exigences de contraste (WCAG AA)** : oui
  - Ratio minimum 4.5:1 pour texte normal
  - Ratio minimum 3:1 pour texte large et composants interactifs
  - Vérifier contraste texte blanc sur headerBackgroundDark (#455A64)

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran est affiché avec valeurs par défaut (reps=16, work=44s, rest=15s)  
   **When** l'utilisateur appuie sur **COMMENCER**  
   **Then** navigation vers TimerRunning avec paramètres { reps: 16, workSeconds: 44, restSeconds: 15 }

2. **Given** l'utilisateur veut augmenter les répétitions  
   **When** tap sur IconButton-13 (+ à côté de RÉPÉTITIONS)  
   **Then** Text-12 passe de "16" à "17", état persisté

3. **Given** l'utilisateur veut sauvegarder la configuration actuelle  
   **When** tap sur Button-22 (SAUVEGARDER)  
   **Then** dialogue s'affiche pour saisir nom, puis sauvegarde dans presets list

4. **Given** l'utilisateur a un préréglage "gainage" sauvegardé  
   **When** tap sur Card-28  
   **Then** reps=20, workSeconds=40, restSeconds=3, scroll vers Card-6 pour afficher les valeurs chargées

5. **Given** l'utilisateur veut créer un nouveau préréglage de toute pièce  
   **When** tap sur Button-27 (+ AJOUTER)  
   **Then** navigation vers PresetEditor en mode création

## 9.2 Alternatives / Exceptions
- **Limite max répétitions** :  
  **Given** reps=99  
  **When** tap sur IconButton-13 (+)  
  **Then** aucun changement, haptic feedback d'erreur, SnackBar "Maximum 99 répétitions"

- **Limite min temps de travail** :  
  **Given** workSeconds=5  
  **When** tap sur IconButton-15 (−)  
  **Then** aucun changement, haptic feedback d'erreur, SnackBar "Minimum 5 secondes de travail"

- **Liste de préréglages vide** :  
  **Given** presets.isEmpty  
  **When** écran affiché  
  **Then** s_presets_list affiche texte d'état vide : "Aucun préréglage sauvegardé.\nAppuyez sur + AJOUTER pour créer."

- **Échec sauvegarde préréglage** :  
  **Given** erreur stockage (espace plein, permissions)  
  **When** tentative de sauvegarde  
  **Then** SnackBar "Échec de la sauvegarde. Réessayez." avec bouton Retry

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | widget | presets vide, valeurs par défaut | tap `interval_timer_home__Button-23` | Navigation vers TimerRunning avec { reps:16, work:44, rest:15 } |
| T2 | widget | reps=16 | tap `interval_timer_home__IconButton-13` | Text-12 affiche "17" |
| T3 | widget | reps=1 | tap `interval_timer_home__IconButton-11` | Text-12 reste "1", SnackBar erreur affiché |
| T4 | widget | workSeconds=44 | tap `interval_timer_home__IconButton-17` 2× | Text-16 affiche "00 : 54" |
| T5 | widget | valeurs par défaut | tap `interval_timer_home__Button-22`, saisir "test" | Nouveau preset "test" apparaît dans liste |
| T6 | widget | preset "gainage" existe | tap Card-28 (gainage) | Text-12="20", Text-16="00 : 40", Text-20="00 : 03" |
| T7 | widget | — | tap `interval_timer_home__IconButton-9` | Card-6 collapse (hauteur réduite), IconButton-9 rotate 180° |
| T8 | widget | volume=0.62 | drag Slider-3 vers 0.8 | volume state=0.8, persisté dans SharedPreferences |
| T9 | golden | valeurs par défaut | render écran | Match snapshot de référence |
| T10 | golden | quickStartExpanded=false | render écran | Card-6 collapsed, match snapshot |
| T11 | unit | — | incrementReps() appelé avec reps=99 | reps reste 99, pas d'erreur levée |
| T12 | unit | — | decrementWorkTime() appelé avec workSeconds=5 | workSeconds reste 5 |
| T13 | integration | liste vide | ouvrir app, créer preset "test", tap COMMENCER | Timer démarre avec config du preset |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Couleurs #607D8B et #455A64 correspondent au Material Design Blue Grey | 0.75 |
| 2 | Icône IconButton-9 est "expand_less" (chevron haut) pour replier | 0.70 |
| 3 | Positions bbox approchées par inspection visuelle, variations ±5px possibles | 0.70 |
| 4 | Valeur slider normalisée 0.62 est précise à ±0.05 | 0.70 |
| 5 | Variants "ghost" et "secondary" pour boutons non remplis visuellement corrects | 0.80 |
| 6 | Incréments de temps par défaut de 5 secondes (non spécifié dans design) | 0.65 |
| 7 | Format d'affichage temps avec espaces "00 : 44" intentionnel (vs "00:44") | 0.75 |
| 8 | Icon-4 (material.circle) est un indicateur visuel du slider, pas un thumb interactif | 0.70 |

## 11.2 Hors périmètre
- Écran TimerRunning (sera spécifié séparément)
- Écran PresetEditor (sera spécifié séparément)
- Écran Settings (sera spécifié séparément)
- Sons de notification (fichiers audio, variation selon volume)
- Animations de transition entre écrans
- Gestion de multiples timers simultanés
- Synchronisation cloud des préréglages
- Import/export de préréglages

## 11.3 Incertitudes / questions ouvertes
- **Format d'affichage du temps** : "00 : 44" (avec espaces) vs "00:44" (sans espaces) — design montre espaces, à confirmer si intentionnel
- **Limite maximale de préréglages** : aucune limite spécifiée, arbitraire ?
- **Comportement long-press sur Card-28** : menu contextuel (éditer/supprimer) supposé, pas visible dans snapshot
- **Icône material.circle (Icon-4)** : rôle exact (indicateur visuel vs élément interactif) à clarifier
- **Haptic feedback** : intensité et pattern non spécifiés
- **Animation collapse/expand Card-6** : durée et easing non spécifiés

---

# 12. Contraintes
- **Authentification** : Non requise pour cette version
- **Sécurité** : Données locales uniquement (SharedPreferences), pas de données sensibles
- **Performance** : 
  - Chargement écran < 100ms
  - Réactivité tap/slider < 16ms (60fps)
  - Liste préréglages : max 100 items sans dégradation perf
- **Accessibilité** : 
  - Support TalkBack/VoiceOver complet
  - Contraste WCAG AA minimum
  - Taille minimale cibles tactiles 48×48dp
  - Navigation clavier complète
- **Compatibilité** : 
  - Flutter SDK >= 3.0
  - Android >= 5.0 (API 21)
  - iOS >= 12.0
  - Orientation portrait uniquement (cette version)

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en px ou secondes, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Textes **verbatim** du design.json, avec `style.transform` appliqué (uppercase/lowercase/none).
- Tous les composants interactifs ont un `a11y.ariaLabel` défini.
- Tokens de couleurs sémantiques uniquement, pas de hex direct dans le code généré.

