---
# Deterministic Functional Spec — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
specVersion: 2
generatedAt: 2025-10-04T08:30:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : IntervalTimerHome
- **Code technique / ID** : `interval_timer_home`
- **Type d'écran** : Form + List
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Configurer rapidement un minuteur d'intervalles (répétitions, temps de travail, temps de repos)
  - Régler le volume audio
  - Démarrer un intervalle configuré
  - Gérer des préréglages personnalisés (liste, ajout, édition)
  - Visualiser et lancer des préréglages sauvegardés

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

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|--------------------|-------------------------------|
| s_header | — | Barre d'en-tête avec volume et options | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5 |
| s_quick_start | Démarrage rapide | Configuration rapide du minuteur | Card-6 (contient Container-7 à Button-23) |
| s_presets_header | VOS PRÉRÉGLAGES | En-tête de la section préréglages | Container-24, Text-25, IconButton-26, Button-27 |
| s_presets_list | — | Liste des préréglages sauvegardés | Card-28 (contient Container-29 à Text-34) |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Titre section | Démarrage rapide |
| Titre section | VOS PRÉRÉGLAGES |
| Labels champs | RÉPÉTITIONS, TRAVAIL, REPOS |
| Valeurs | 16, 00 : 44, 00 : 15 |
| Boutons action | SAUVEGARDER, COMMENCER, + AJOUTER |
| Préréglage titre | gainage |
| Préréglage durée | 14:22 |
| Préréglage détails | RÉPÉTITIONS 20x, TRAVAIL 00:40, REPOS 00:03 |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|
| presets_list | nom, durée totale, détails config | ordre de création (récent en premier) | — | Afficher message "Aucun préréglage" + bouton "+ AJOUTER" |

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| IconButton-2 | IconButton | ghost → faible | Régler le volume | `toggleVolumePopup()` | volumePopupVisible | — |
| Slider-3 | Slider | — | Curseur de volume | `setVolume(value)` | volumeLevel | — |
| IconButton-5 | IconButton | ghost → faible | Plus d'options | `showOptionsMenu()` | optionsMenuVisible | — |
| IconButton-9 | IconButton | ghost → faible | Replier la section Démarrage rapide | `toggleQuickStartExpanded()` | quickStartExpanded | — |
| IconButton-11 | IconButton | ghost → faible | Diminuer les répétitions | `decrementRepetitions()` | repetitions | — |
| IconButton-13 | IconButton | ghost → faible | Augmenter les répétitions | `incrementRepetitions()` | repetitions | — |
| IconButton-15 | IconButton | ghost → faible | Diminuer le temps de travail | `decrementWorkTime()` | workSeconds | — |
| IconButton-17 | IconButton | ghost → faible | Augmenter le temps de travail | `incrementWorkTime()` | workSeconds | — |
| IconButton-19 | IconButton | ghost → faible | Diminuer le temps de repos | `decrementRestTime()` | restSeconds | — |
| IconButton-21 | IconButton | ghost → faible | Augmenter le temps de repos | `incrementRestTime()` | restSeconds | — |
| Button-22 | Button | ghost → faible | Sauvegarder le préréglage rapide | `saveQuickStartAsPreset()` | presetsList | — |
| Button-23 | Button | cta → primaire | Démarrer l'intervalle | `startInterval()` | — | /timer |
| IconButton-26 | IconButton | ghost → faible | Éditer les préréglages | `toggleEditMode()` | editModeActive | — |
| Button-27 | Button | secondary → supportive | Ajouter un préréglage | `createNewPreset()` | — | /preset/new |

- **Gestes & clavier** : 
  - Tap sur les IconButton pour incrémenter/décrémenter
  - Drag sur le Slider-3 pour ajuster le volume
  - Tap sur les cartes de préréglages pour les sélectionner et démarrer
  - Enter sur Button-23 pour démarrer
  
- **Feedback** : 
  - Feedback haptique léger sur tap des boutons +/-
  - Animation de pulsation sur Button-23 au hover
  - Désactivation du Button-22 si configuration invalide
  - Snackbar de confirmation après sauvegarde d'un préréglage
  
- **Règles de placement ayant un impact** : 
  - Container-1 : groupe centré avec distribution between (volume control spanning header)
  - Button-22 : placement `end`, widthMode `intrinsic` (aligné à droite, taille adaptée)
  - Button-23 : placement `start`, widthMode `fill` (pleine largeur, icône à gauche)
  - Button-27 : placement `end`, widthMode `intrinsic` (aligné à droite, taille adaptée)

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| repetitions | ≥ 1 et ≤ 99 | Répétitions invalides |
| workSeconds | ≥ 5 et ≤ 3600 | Temps de travail invalide |
| restSeconds | ≥ 3 et ≤ 3600 | Temps de repos invalide |
| presetName (lors sauvegarde) | non vide, ≤ 30 caractères | Nom requis (max 30 caractères) |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|------|-----------|-----------|-------|
| Durée totale préréglage | repetitions × (workSeconds + restSeconds) | Affichée en MM:SS (Text-31) | Recalculée à chaque modification |
| Activation Button-22 | configuration valide (règles §4.1) | Désactivé si invalide | — |
| Expansion section Quick Start | quickStartExpanded == true | Tous les contrôles visibles | IconButton-9 change d'icône (expand_less ↔ expand_more) |
| Mode édition préréglages | editModeActive == true | Icônes de suppression apparaissent sur les cartes | — |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Liste préréglages vide | Texte centré "Aucun préréglage sauvegardé" + Button-27 mis en évidence | Tap sur Button-27 |
| Échec sauvegarde préréglage | Snackbar "Erreur lors de la sauvegarde" | Retry automatique ou dismiss |
| Échec chargement préréglages | Snackbar "Impossible de charger les préréglages" | Bouton "Réessayer" |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Lancement app | — (initial route) | — | Route par défaut |
| Retour depuis /timer | /timer | — | Back navigation |
| Retour depuis /preset/new | /preset/new | presetCreated: bool | Si créé, rafraîchir liste |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| Tap Button-23 | /timer | repetitions, workSeconds, restSeconds | Configuration quick start |
| Tap carte préréglage | /timer | presetId | Charge config du préréglage |
| Tap Button-27 | /preset/new | — | Création nouveau préréglage |

## 5.3 Événements système
- **Back physique** : Pas d'action (écran racine)
- **Timer / notifications** : N/A (pas sur cet écran)
- **Permissions** : Notification permission (pour alertes timer en arrière-plan)

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| volumeLevel | double | 0.62 | SharedPreferences | Normalisé 0.0-1.0 |
| volumePopupVisible | bool | false | non | — |
| optionsMenuVisible | bool | false | non | — |
| quickStartExpanded | bool | true | SharedPreferences | — |
| repetitions | int | 16 | SharedPreferences (draft) | — |
| workSeconds | int | 44 | SharedPreferences (draft) | — |
| restSeconds | int | 15 | SharedPreferences (draft) | — |
| presetsList | List<Preset> | [] | Stockage local (JSON file) | — |
| editModeActive | bool | false | non | — |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| setVolume | double value | — | — | Met à jour volumeLevel et persiste |
| toggleVolumePopup | — | — | — | Bascule volumePopupVisible |
| showOptionsMenu | — | — | — | Affiche menu options (settings, about, etc.) |
| toggleQuickStartExpanded | — | — | — | Bascule quickStartExpanded et persiste |
| incrementRepetitions | — | — | — | repetitions + 1 (max 99) |
| decrementRepetitions | — | — | — | repetitions - 1 (min 1) |
| incrementWorkTime | — | — | — | workSeconds + 5 (max 3600) |
| decrementWorkTime | — | — | — | workSeconds - 5 (min 5) |
| incrementRestTime | — | — | — | restSeconds + 1 (max 3600) |
| decrementRestTime | — | — | — | restSeconds - 1 (min 3) |
| saveQuickStartAsPreset | — | Preset | ValidationError | Valide, demande nom, sauvegarde |
| startInterval | — | — | ValidationError | Valide config, navigue vers /timer |
| toggleEditMode | — | — | — | Bascule editModeActive |
| createNewPreset | — | — | — | Navigue vers /preset/new |
| loadPresets | — | List<Preset> | FileError | Charge depuis stockage |
| deletePreset | String presetId | — | FileError | Supprime et rafraîchit |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|
| IconButton-2 | Régler le volume | button | 1 | — | — |
| Slider-3 | Curseur de volume | slider | 2 | Arrow keys | — |
| IconButton-5 | Plus d'options | button | 3 | — | — |
| IconButton-9 | Replier la section Démarrage rapide | button | 4 | — | — |
| IconButton-11 | Diminuer les répétitions | button | 5 | — | Annonce nouvelle valeur |
| Text-12 | — | text | — | — | Valeur annoncée lors changement |
| IconButton-13 | Augmenter les répétitions | button | 6 | — | Annonce nouvelle valeur |
| IconButton-15 | Diminuer le temps de travail | button | 7 | — | Annonce nouvelle valeur |
| Text-16 | — | text | — | — | Valeur annoncée lors changement |
| IconButton-17 | Augmenter le temps de travail | button | 8 | — | Annonce nouvelle valeur |
| IconButton-19 | Diminuer le temps de repos | button | 9 | — | Annonce nouvelle valeur |
| Text-20 | — | text | — | — | Valeur annoncée lors changement |
| IconButton-21 | Augmenter le temps de repos | button | 10 | — | Annonce nouvelle valeur |
| Button-22 | Sauvegarder le préréglage rapide | button | 11 | — | — |
| Button-23 | Démarrer l'intervalle | button | 12 | Enter | — |
| IconButton-26 | Éditer les préréglages | button | 13 | — | — |
| Button-27 | Ajouter un préréglage | button | 14 | — | — |
| Card-28 | — | button | 15 | — | Carte préréglage tappable |

---

# 8. Thème & tokens requis
- **Couleurs sémantiques utilisées** : 
  - `primary` (#607D8B) - boutons principaux, icônes
  - `cta` (#607D8B) - Button-23 background
  - `onPrimary` (#FFFFFF) - textes sur primary
  - `background` (#F2F2F2) - fond de page
  - `surface` (#FFFFFF) - cartes
  - `textPrimary` (#212121) - textes principaux
  - `textSecondary` (#616161) - labels et textes secondaires
  - `divider` (#E0E0E0) - bordures de cartes
  - `border` (#DDDDDD) - bordures boutons
  - `accent` (#FFC107) - icône bolt sur Button-23
  - `sliderActive` (#FFFFFF) - piste active slider
  - `sliderInactive` (#90A4AE) - piste inactive slider
  - `sliderThumb` (#FFFFFF) - pouce slider
  - `headerBackgroundDark` (#455A64) - fond header
  - `presetCardBg` (#FAFAFA) - fond cartes préréglages
  
- **Typographies référencées (`typographyRef`)** : 
  - `titleLarge` (Text-8 : "Démarrage rapide")
  - `label` (Text-10, 14, 18, Button-22, Button-27)
  - `value` (Text-12, 16, 20, Text-31)
  - `title` (Text-25, Button-23, Text-30)
  - `body` (Text-32, 33, 34)
  
- **Exigences de contraste (WCAG AA)** : oui
  - Contraste minimum 4.5:1 pour textes normaux
  - Contraste minimum 3:1 pour textes larges et éléments UI
  - Vérifié pour toutes les combinaisons couleur/fond

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran est affiché avec configuration par défaut (16 rép, 44s travail, 15s repos)  
   **When** l'utilisateur appuie sur **COMMENCER**  
   **Then** la configuration est validée et l'application navigue vers `/timer` avec les paramètres

2. **Given** l'utilisateur veut augmenter les répétitions  
   **When** l'utilisateur tape sur le bouton `+` des répétitions  
   **Then** la valeur passe de 16 à 17 et est affichée instantanément

3. **Given** l'utilisateur a configuré un intervalle personnalisé  
   **When** l'utilisateur tape sur **SAUVEGARDER**  
   **Then** une boîte de dialogue demande le nom du préréglage, puis le sauvegarde et l'ajoute à la liste

4. **Given** l'utilisateur voit la liste des préréglages  
   **When** l'utilisateur tape sur la carte "gainage"  
   **Then** l'application navigue vers `/timer` avec la configuration du préréglage "gainage"

5. **Given** l'utilisateur veut créer un nouveau préréglage  
   **When** l'utilisateur tape sur **+ AJOUTER**  
   **Then** l'application navigue vers `/preset/new`

## 9.2 Alternatives / Exceptions
- **Valeur invalide** : Si l'utilisateur tente de décrémenter en dessous des limites (ex: répétitions < 1), le bouton `-` est désactivé ou l'action est ignorée
- **Liste vide** : Si aucun préréglage n'existe, afficher un état vide avec message encourageant à créer le premier préréglage
- **Erreur de sauvegarde** : Si la sauvegarde échoue, afficher un snackbar avec message d'erreur et option de réessayer
- **Configuration invalide** : Si l'utilisateur tape sur COMMENCER avec des valeurs invalides, afficher un snackbar expliquant le problème

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | widget | idle, config par défaut | tap COMMENCER | Navigation vers /timer avec params corrects |
| T2 | widget | idle | tap + répétitions | Valeur passe de 16 à 17 |
| T3 | widget | idle | tap - répétitions | Valeur passe de 16 à 15 |
| T4 | widget | idle | tap + répétitions 99 fois | Valeur plafonnée à 99, bouton + désactivé |
| T5 | widget | idle | tap - répétitions 15 fois | Valeur plafonnée à 1, bouton - désactivé |
| T6 | widget | idle | tap + travail | workSeconds +5 (44→49) |
| T7 | widget | idle | tap - travail | workSeconds -5 (44→39) |
| T8 | widget | idle | tap + repos | restSeconds +1 (15→16) |
| T9 | widget | idle | tap - repos | restSeconds -1 (15→14) |
| T10 | widget | idle, config valide | tap SAUVEGARDER | Dialog demande nom, puis preset ajouté à liste |
| T11 | widget | idle | tap + AJOUTER | Navigation vers /preset/new |
| T12 | widget | idle, préréglages chargés | tap carte préréglage | Navigation vers /timer avec config du preset |
| T13 | widget | idle | tap IconButton-9 | Section Quick Start collapse/expand |
| T14 | widget | idle | drag Slider-3 | volumeLevel mis à jour |
| T15 | golden | idle, config par défaut | — | Snapshot stable de l'écran |
| T16 | unit | — | incrementRepetitions() | repetitions passe de 16 à 17 |
| T17 | unit | — | decrementRepetitions() | repetitions passe de 16 à 15 |
| T18 | unit | repetitions=99 | incrementRepetitions() | repetitions reste à 99 |
| T19 | unit | repetitions=1 | decrementRepetitions() | repetitions reste à 1 |
| T20 | unit | — | saveQuickStartAsPreset() | Preset créé et ajouté à presetsList |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Couleurs estimées à partir du rendu (Material Design gris/bleu) | 0.75 |
| 2 | Nom d'icône 'expand_less' supposé pour le chevron de repli | 0.70 |
| 3 | Positions/bbox approchées par inspection visuelle | 0.70 |
| 4 | Valeur du slider normalisée à ~0.62 d'après position du pouce | 0.70 |
| 5 | Boutons 'SAUVEGARDER' et '+ AJOUTER' en variants ghost/secondary | 0.80 |
| 6 | Incréments de +5s pour le temps de travail, +1s pour repos | 0.75 |
| 7 | Persistance des valeurs quick start dans SharedPreferences | 0.80 |
| 8 | Format de durée "MM : SS" avec espaces (verbatim du design) | 0.90 |

## 11.2 Hors périmètre
- Édition inline des préréglages existants (doit passer par écran dédié)
- Synchronisation cloud des préréglages
- Historique des sessions d'intervalles
- Statistiques et analytics
- Sons personnalisés pour les alertes
- Thèmes clairs/sombres (uniquement thème clair pour l'instant)

## 11.3 Incertitudes / questions ouvertes
- Comportement exact du IconButton-5 (menu options) : contenu du menu non spécifié
- Feedback haptique : force et patterns exacts à définir
- Animation du bouton COMMENCER : durée et style exacts
- Politique de tri des préréglages : par date de création, modification, ou alphabétique ?
- Confirmation avant suppression d'un préréglage en mode édition

---

# 12. Contraintes
- **Authentification** : Non requise pour cette version
- **Sécurité** : 
  - Validation côté client des valeurs numériques
  - Sanitization des noms de préréglages (pas de caractères spéciaux filesystem)
- **Performance** : 
  - Chargement liste préréglages < 100ms
  - Réactivité UI < 16ms (60 FPS)
  - Pas de calculs lourds sur le thread UI
- **Accessibilité** : 
  - Support lecteurs d'écran (TalkBack, VoiceOver)
  - Contraste WCAG AA minimum
  - Zones tactiles ≥ 44×44 dp
  - Ordre de focus logique
- **Compatibilité** : 
  - Flutter ≥ 3.0
  - iOS ≥ 12.0
  - Android ≥ API 21 (Lollipop)

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en px, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`interval_timer_home__{compId}`).
- Textes strictement verbatim du design.json avec `style.transform` appliqué.
- Tous les composants interactifs ont une clé unique et un label a11y.
