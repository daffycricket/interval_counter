---
# Deterministic Functional Spec — Home

# YAML front matter for machine-readability
screenName: Home
screenId: home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
specVersion: 2
generatedAt: 2025-10-19T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : Home
- **Code technique / ID** : `home`
- **Type d'écran** : Form
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Configurer rapidement un intervalle d'entraînement (répétitions, temps de travail, temps de repos)
  - Démarrer un intervalle avec les paramètres du démarrage rapide
  - Gérer des préréglages d'intervalles personnalisés (consulter, ajouter, supprimer)
  - Ajuster le volume sonore
  - Accéder aux options globales

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId | type        | variant   | key (stable)              | texte (après transform) |
|-----|--------|-------------|-----------|---------------------------|-------------------------|
| 1   | Container-1 | Container | — | home__Container-1 | — |
| 2   | IconButton-2 | IconButton | ghost | home__IconButton-2 | — |
| 3   | Slider-3 | Slider | — | home__Slider-3 | — |
| 4   | Icon-4 | Icon | — | home__Icon-4 | — |
| 5   | IconButton-5 | IconButton | ghost | home__IconButton-5 | — |
| 6   | Card-6 | Card | — | home__Card-6 | — |
| 7   | Container-7 | Container | — | home__Container-7 | — |
| 8   | Text-8 | Text | — | home__Text-8 | Démarrage rapide |
| 9   | IconButton-9 | IconButton | ghost | home__IconButton-9 | — |
| 10  | Text-10 | Text | — | home__Text-10 | RÉPÉTITIONS |
| 11  | IconButton-11 | IconButton | ghost | home__IconButton-11 | — |
| 12  | Text-12 | Text | — | home__Text-12 | 16 |
| 13  | IconButton-13 | IconButton | ghost | home__IconButton-13 | — |
| 14  | Text-14 | Text | — | home__Text-14 | TRAVAIL |
| 15  | IconButton-15 | IconButton | ghost | home__IconButton-15 | — |
| 16  | Text-16 | Text | — | home__Text-16 | 00 : 44 |
| 17  | IconButton-17 | IconButton | ghost | home__IconButton-17 | — |
| 18  | Text-18 | Text | — | home__Text-18 | REPOS |
| 19  | IconButton-19 | IconButton | ghost | home__IconButton-19 | — |
| 20  | Text-20 | Text | — | home__Text-20 | 00 : 15 |
| 21  | IconButton-21 | IconButton | ghost | home__IconButton-21 | — |
| 22  | Button-22 | Button | ghost | home__Button-22 | SAUVEGARDER |
| 23  | Button-23 | Button | cta | home__Button-23 | COMMENCER |
| 24  | Container-24 | Container | — | home__Container-24 | — |
| 25  | Text-25 | Text | — | home__Text-25 | VOS PRÉRÉGLAGES |
| 26  | IconButton-26 | IconButton | ghost | home__IconButton-26 | — |
| 27  | Button-27 | Button | secondary | home__Button-27 | + AJOUTER |
| 28  | Card-28 | Card | — | home__Card-28 | — |
| 29  | Container-29 | Container | — | home__Container-29 | — |
| 30  | Text-30 | Text | — | home__Text-30 | gainage |
| 31  | Text-31 | Text | — | home__Text-31 | 14:22 |
| 32  | Text-32 | Text | — | home__Text-32 | RÉPÉTITIONS 20x |
| 33  | Text-33 | Text | — | home__Text-33 | TRAVAIL 00:40 |
| 34  | Text-34 | Text | — | home__Text-34 | REPOS 00:03 |

> Règle de clé: `{screenName}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|--------------------|-------------------------------|
| s_header  | — | Barre de contrôle volume et menu | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5 |
| s_quick_start | Démarrage rapide | Configuration rapide d'intervalle | Card-6, Container-7, Text-8, IconButton-9, Text-10, IconButton-11, Text-12, IconButton-13, Text-14, IconButton-15, Text-16, IconButton-17, Text-18, IconButton-19, Text-20, IconButton-21, Button-22 |
| s_cta | — | Bouton d'action principal | Button-23 |
| s_presets_header | VOS PRÉRÉGLAGES | Titre section préréglages | Container-24, Text-25, IconButton-26, Button-27 |
| s_presets_list | — | Liste des préréglages | Card-28, Container-29, Text-30, Text-31, Text-32, Text-33, Text-34 |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Titre section démarrage | Démarrage rapide |
| Titre section préréglages | VOS PRÉRÉGLAGES |
| Labels contrôles | RÉPÉTITIONS, TRAVAIL, REPOS |
| Valeurs contrôles | 16, 00 : 44, 00 : 15 |
| Bouton primaire | COMMENCER |
| Bouton sauvegarde | SAUVEGARDER |
| Bouton ajout | + AJOUTER |
| Préréglage exemple | gainage |
| Durée totale préréglage | 14:22 |
| Détails préréglage | RÉPÉTITIONS 20x, TRAVAIL 00:40, REPOS 00:03 |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|
| presets_list | nom, durée totale, répétitions, travail, repos | ordre d'ajout | — | Aucun préréglage |

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| IconButton-2 | IconButton | ghost → faible | Régler le volume | `adjustVolume()` | — | — |
| Slider-3 | Slider | — | Curseur de volume | `onVolumeChange(value)` | volume | — |
| IconButton-5 | IconButton | ghost → faible | Plus d'options | `openMenu()` | — | Menu |
| IconButton-9 | IconButton | ghost → faible | Replier la section Démarrage rapide | `toggleQuickStart()` | quickStartExpanded | — |
| IconButton-11 | IconButton | ghost → faible | Diminuer les répétitions | `decrementReps()` | reps | — |
| IconButton-13 | IconButton | ghost → faible | Augmenter les répétitions | `incrementReps()` | reps | — |
| IconButton-15 | IconButton | ghost → faible | Diminuer le temps de travail | `decrementWork()` | workSeconds | — |
| IconButton-17 | IconButton | ghost → faible | Augmenter le temps de travail | `incrementWork()` | workSeconds | — |
| IconButton-19 | IconButton | ghost → faible | Diminuer le temps de repos | `decrementRest()` | restSeconds | — |
| IconButton-21 | IconButton | ghost → faible | Augmenter le temps de repos | `incrementRest()` | restSeconds | — |
| Button-22 | Button | ghost → faible | Sauvegarder le préréglage rapide | `savePreset()` | presets | Dialog |
| Button-23 | Button | cta → primaire | Démarrer l'intervalle | `startInterval()` | — | Timer |
| IconButton-26 | IconButton | ghost → faible | Éditer les préréglages | `editPresets()` | editMode | — |
| Button-27 | Button | secondary → supportive | Ajouter un préréglage | `addPreset()` | presets | Dialog |

- **Gestes & clavier** : 
  - Swipe sur une carte de préréglage : supprime le préréglage
  - Enter sur Button-23 : lance l'intervalle
- **Feedback** : 
  - Ajout préréglage : boîte de dialogue pour saisie du nom
  - Suppression préréglage : confirmation via swipe (pas de confirmation supplémentaire)
  - Désactivation bouton COMMENCER si configuration invalide
- **Règles de placement ayant un impact** : 
  - Button-23 : `placement=start`, `widthMode=fill` (action principale pleine largeur)
  - Button-22 : `placement=end`, `widthMode=intrinsic` (action secondaire alignée à droite)
  - Button-27 : `placement=end`, `widthMode=intrinsic` (action d'ajout alignée à droite)

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| reps | > 0 | — |
| workSeconds | ≥ 1 | — |
| restSeconds | ≥ 0 | — |
| preset.name | non vide lors de la sauvegarde | Veuillez saisir un nom |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|------|-----------|-----------|-------|
| Affichage temps | toujours | Format "00 : 44" avec espaces | Spec complément §Autres règles |
| Incrément contrôles | tous les +/− | 1 seconde | Spec complément §Autres règles |
| État vide préréglages | presets.length == 0 | Texte "Aucun préréglage" | Spec complément §2.2 |
| Bouton COMMENCER actif | reps > 0 && workSeconds ≥ 1 | enabled | — |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Aucun préréglage | Afficher message "Aucun préréglage" dans la liste | Button-27 (+ AJOUTER) |
| Nom préréglage vide | Bloquer sauvegarde | Saisir nom |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Lancement app | — | — | Écran principal au démarrage |
| Retour depuis Timer | Timer | — | Après fin d'intervalle |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| Button-23 (COMMENCER) | Timer | reps, workSeconds, restSeconds | Lance session d'intervalle |
| IconButton-5 (menu) | Menu/Settings | — | Options globales |
| Button-22 (SAUVEGARDER) | Dialog | — | Saisie nom préréglage |
| Button-27 (+ AJOUTER) | Dialog | — | Saisie nom préréglage |

## 5.3 Événements système
- Back physique : ferme l'app (écran principal)
- Timer : —
- Permissions : —

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| reps | int | 10 | oui | Répétitions (spec complément §1) |
| workSeconds | int | 40 | oui | Temps de travail en secondes (spec complément §1) |
| restSeconds | int | 20 | oui | Temps de repos en secondes (spec complément §1) |
| volume | double | 0.62 | oui | Volume normalisé [0.0, 1.0] |
| quickStartExpanded | bool | true | non | Section démarrage rapide dépliée |
| presets | List<Preset> | [] | oui | Liste des préréglages (spec complément §2) |
| editMode | bool | false | non | Mode édition préréglages |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| incrementReps | — | — | — | Augmente reps de 1 |
| decrementReps | — | — | — | Diminue reps de 1 (min 1) |
| incrementWork | — | — | — | Augmente workSeconds de 1 |
| decrementWork | — | — | — | Diminue workSeconds de 1 (min 1) |
| incrementRest | — | — | — | Augmente restSeconds de 1 |
| decrementRest | — | — | — | Diminue restSeconds de 1 (min 0) |
| onVolumeChange | double value | — | — | Met à jour volume |
| toggleQuickStart | — | — | — | Inverse quickStartExpanded |
| savePreset | String name | — | nom vide | Crée nouveau préréglage avec valeurs actuelles |
| addPreset | — | — | — | Ouvre dialog puis appelle savePreset |
| deletePreset | String id | — | — | Supprime préréglage de la liste |
| startInterval | — | — | — | Navigation vers Timer avec params |
| editPresets | — | — | — | Toggle editMode |
| openMenu | — | — | — | Navigation vers Menu |
| adjustVolume | — | — | — | Action informative (UI déjà présente via Slider) |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|
| IconButton-2 | Régler le volume | button | 1 | — | — |
| Slider-3 | Curseur de volume | slider | 2 | — | — |
| IconButton-5 | Plus d'options | button | 3 | — | — |
| IconButton-9 | Replier la section Démarrage rapide | button | 4 | — | — |
| IconButton-11 | Diminuer les répétitions | button | 5 | — | — |
| Text-12 | — | text | — | — | Valeur répétitions |
| IconButton-13 | Augmenter les répétitions | button | 6 | — | — |
| IconButton-15 | Diminuer le temps de travail | button | 7 | — | — |
| Text-16 | — | text | — | — | Valeur travail |
| IconButton-17 | Augmenter le temps de travail | button | 8 | — | — |
| IconButton-19 | Diminuer le temps de repos | button | 9 | — | — |
| Text-20 | — | text | — | — | Valeur repos |
| IconButton-21 | Augmenter le temps de repos | button | 10 | — | — |
| Button-22 | Sauvegarder le préréglage rapide | button | 11 | — | — |
| Button-23 | Démarrer l'intervalle | button | 12 | Enter | Action principale |
| IconButton-26 | Éditer les préréglages | button | 13 | — | — |
| Button-27 | Ajouter un préréglage | button | 14 | — | — |

---

# 8. Thème & tokens requis
- Couleurs sémantiques utilisées : `primary`, `onPrimary`, `background`, `surface`, `textPrimary`, `textSecondary`, `divider`, `accent`, `sliderActive`, `sliderInactive`, `sliderThumb`, `border`, `cta`, `headerBackgroundDark`, `presetCardBg`
- Typographies référencées (`typographyRef`) : titleLarge, label, body, value, title
- Exigences de contraste (WCAG AA) : oui

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran Home est affiché avec valeurs par défaut (reps=10, workSeconds=40, restSeconds=20)  
   **When** l'utilisateur appuie sur IconButton-13 (+ répétitions) 6 fois  
   **Then** Text-12 affiche "16".

2. **Given** l'écran Home avec reps=16, workSeconds=44, restSeconds=15  
   **When** l'utilisateur appuie sur Button-23 (COMMENCER)  
   **Then** navigation vers Timer avec params (16, 44, 15).

3. **Given** l'écran Home avec reps=16, workSeconds=44, restSeconds=15  
   **When** l'utilisateur appuie sur Button-22 (SAUVEGARDER)  
   **Then** une boîte de dialogue s'ouvre pour saisir le nom du préréglage.

4. **Given** la boîte de dialogue de sauvegarde est ouverte  
   **When** l'utilisateur saisit "gainage" et valide  
   **Then** un nouveau préréglage "gainage" apparaît dans la liste avec les valeurs (16, 44, 15).

5. **Given** un préréglage "gainage" existe dans la liste  
   **When** l'utilisateur effectue un swipe sur Card-28  
   **Then** le préréglage "gainage" est supprimé de la liste.

## 9.2 Alternatives / Exceptions
- **Valeur minimale répétitions** : Diminuer en dessous de 1 → bloqué à 1  
- **Valeur minimale travail** : Diminuer en dessous de 1 seconde → bloqué à 1  
- **Valeur minimale repos** : Diminuer en dessous de 0 → bloqué à 0  
- **Liste vide préréglages** : Afficher message "Aucun préréglage"  
- **Nom préréglage vide** : Bloquer la sauvegarde, afficher "Veuillez saisir un nom"

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | widget | reps=10 | tap IconButton-13 | find.byKey('home__Text-12') text = "11" |
| T2 | widget | reps=10 | tap IconButton-11 9 fois | find.byKey('home__Text-12') text = "1", IconButton-11 disabled |
| T3 | widget | workSeconds=40 | tap IconButton-17 4 fois | find.byKey('home__Text-16') text = "00 : 44" |
| T4 | widget | restSeconds=20 | tap IconButton-19 5 fois | find.byKey('home__Text-20') text = "00 : 15" |
| T5 | widget | presets=[] | tap Button-27 | dialog appears |
| T6 | unit | state.reps=10 | incrementReps() | state.reps = 11 |
| T7 | unit | state.reps=1 | decrementReps() | state.reps = 1 |
| T8 | unit | state.workSeconds=1 | decrementWork() | state.workSeconds = 1 |
| T9 | unit | state.restSeconds=0 | decrementRest() | state.restSeconds = 0 |
| T10 | widget | presets=[] | — | find.text('Aucun préréglage') |
| T11 | widget | presets=[gainage] | swipe Card-28 | presets.length = 0 |
| T12 | a11y | — | — | all interactive components have Semantics with label |
| T13 | golden | default state | — | matches golden file |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Les couleurs du design.json sont fidèles au rendu final | 0.75 |
| 2 | L'icône expand_less est correcte pour le bouton de repli | 0.70 |
| 3 | Les bbox sont suffisamment précises pour le layout | 0.70 |
| 4 | La valeur initiale du slider (0.62) correspond au volume par défaut | 0.70 |
| 5 | Les variantes ghost/secondary correspondent au style visuel | 0.80 |

## 11.2 Hors périmètre
- Écran Timer (destination de navigation)
- Écran Menu/Settings
- Gestion audio détaillée (fichiers sons, types de sons)
- Persistance des données (implémentation concrète)
- Gestion des préférences système (thème sombre, langue)

## 11.3 Incertitudes / questions ouvertes
- Format de la durée totale du préréglage (14:22) : mm:ss ou hh:mm ?
- Confirmation de suppression d'un préréglage : nécessaire ou pas ?
- Limite maximale des valeurs (répétitions, temps) ?

---

# 12. Contraintes
- **Authentification** : —
- **Sécurité** : —
- **Performance** : Réactivité immédiate des contrôles (+/−)
- **Accessibilité** : Tous les éléments interactifs doivent avoir des labels sémantiques (WCAG AA)
- **Compatibilité** : iOS et Android

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en secondes, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Textes verbatim avec `style.transform` appliqué (RÉPÉTITIONS, TRAVAIL, REPOS, SAUVEGARDER, COMMENCER, VOS PRÉRÉGLAGES, + AJOUTER).

