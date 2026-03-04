---
# Deterministic Functional Spec — Preset Editor Advanced

screenName: Interval Timer – Advanced Edit
screenId: preset_editor_advanced
designSnapshotRef: Screenshot_20260304_110158_Interval_Timer.jpg
specVersion: 2
generatedAt: 2026-03-04T12:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : Interval Timer – Advanced Edit
- **Code technique / ID** : `preset_editor_advanced`
- **Type d'écran** : Form
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Permettre la construction d'un entraînement sous forme de séquence d'étapes personnalisables organisées en groupes.
  - Chaque groupe possède un nombre de répétitions et contient une liste ordonnée d'étapes.
  - Chaque étape possède un nom, une couleur, et un mode (TIME = durée chrono, REPS = N répétitions x durée).
  - L'utilisateur peut ajouter/supprimer/dupliquer/réordonner des étapes, et ajouter des groupes.
  - Un bloc FINISH configurable (couleur, alarme) termine la séquence.
  - Le preset est sauvegardé et utilisé par l'écran Workout.

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué.

---

# 2. Inventaire & Contenu (source: design.json)

## 2.1 Inventaire des composants

| idx | compId        | type       | variant   | key (stable)                                       | texte (après transform) |
|-----|---------------|------------|-----------|-----------------------------------------------------|-------------------------|
| 1   | iconbutton-0  | IconButton | ghost     | preset_editor_advanced__iconbutton-0                | —                       |
| 2   | button-0      | Button     | ghost     | preset_editor_advanced__button-0                    | SIMPLE                  |
| 3   | button-1      | Button     | secondary | preset_editor_advanced__button-1                    | ADVANCED                |
| 4   | iconbutton-1  | IconButton | ghost     | preset_editor_advanced__iconbutton-1                | —                       |
| 5   | text-2        | Text       | —         | preset_editor_advanced__text-2                      | Nom prédéfini           |
| 6   | text-3        | Text       | —         | preset_editor_advanced__text-3                      | Programme spécifique    |
| 7   | text-4        | Text       | —         | preset_editor_advanced__text-4                      | RÉPÉTITIONS             |
| 8   | iconbutton-3  | IconButton | secondary | preset_editor_advanced__iconbutton-3                | —                       |
| 9   | text-5        | Text       | —         | preset_editor_advanced__text-5                      | 1                       |
| 10  | iconbutton-4  | IconButton | secondary | preset_editor_advanced__iconbutton-4                | —                       |
| 11  | text-6        | Text       | —         | preset_editor_advanced__text-6                      | Étape 1                 |
| 12  | iconbutton-5  | IconButton | ghost     | preset_editor_advanced__iconbutton-5                | —                       |
| 13  | text-7        | Text       | —         | preset_editor_advanced__text-7                      | TIME                    |
| 14  | text-8        | Text       | —         | preset_editor_advanced__text-8                      | REPS                    |
| 15  | iconbutton-6  | IconButton | secondary | preset_editor_advanced__iconbutton-6                | —                       |
| 16  | text-9        | Text       | —         | preset_editor_advanced__text-9                      | 00 : 05                 |
| 17  | iconbutton-7  | IconButton | secondary | preset_editor_advanced__iconbutton-7                | —                       |
| 18  | button-2      | Button     | ghost     | preset_editor_advanced__button-2                    | COLOR                   |
| 19  | iconbutton-8  | IconButton | ghost     | preset_editor_advanced__iconbutton-8                | —                       |
| 20  | iconbutton-9  | IconButton | ghost     | preset_editor_advanced__iconbutton-9                | —                       |
| 21  | text-10       | Text       | —         | preset_editor_advanced__text-10                     | Étape 2                 |
| 22  | iconbutton-11 | IconButton | ghost     | preset_editor_advanced__iconbutton-11               | —                       |
| 23  | text-11       | Text       | —         | preset_editor_advanced__text-11                     | TIME                    |
| 24  | text-12       | Text       | —         | preset_editor_advanced__text-12                     | REPS                    |
| 25  | iconbutton-12 | IconButton | secondary | preset_editor_advanced__iconbutton-12               | —                       |
| 26  | text-13       | Text       | —         | preset_editor_advanced__text-13                     | 3                       |
| 27  | text-14       | Text       | —         | preset_editor_advanced__text-14                     | x                       |
| 28  | iconbutton-13 | IconButton | secondary | preset_editor_advanced__iconbutton-13               | —                       |
| 29  | iconbutton-14 | IconButton | secondary | preset_editor_advanced__iconbutton-14               | —                       |
| 30  | text-15       | Text       | —         | preset_editor_advanced__text-15                     | 10.0s                   |
| 31  | iconbutton-15 | IconButton | secondary | preset_editor_advanced__iconbutton-15               | —                       |
| 32  | button-3      | Button     | ghost     | preset_editor_advanced__button-3                    | COLOR                   |
| 33  | iconbutton-16 | IconButton | ghost     | preset_editor_advanced__iconbutton-16               | —                       |
| 34  | iconbutton-17 | IconButton | ghost     | preset_editor_advanced__iconbutton-17               | —                       |
| 35  | iconbutton-19 | IconButton | ghost     | preset_editor_advanced__iconbutton-19               | —                       |
| 36  | text-16       | Text       | —         | preset_editor_advanced__text-16                     | 00:35                   |
| 37  | text-17       | Text       | —         | preset_editor_advanced__text-17                     | RÉPÉTITIONS             |
| 38  | iconbutton-21 | IconButton | secondary | preset_editor_advanced__iconbutton-21               | —                       |
| 39  | text-18       | Text       | —         | preset_editor_advanced__text-18                     | 3                       |
| 40  | iconbutton-22 | IconButton | secondary | preset_editor_advanced__iconbutton-22               | —                       |
| 41  | iconbutton-23 | IconButton | ghost     | preset_editor_advanced__iconbutton-23               | —                       |
| 42  | text-19       | Text       | —         | preset_editor_advanced__text-19                     | 00:00                   |
| 43  | text-20       | Text       | —         | preset_editor_advanced__text-20                     | RÉPÉTITIONS             |
| 44  | iconbutton-25 | IconButton | secondary | preset_editor_advanced__iconbutton-25               | —                       |
| 45  | text-21       | Text       | —         | preset_editor_advanced__text-21                     | 1                       |
| 46  | iconbutton-26 | IconButton | secondary | preset_editor_advanced__iconbutton-26               | —                       |
| 47  | text-22       | Text       | —         | preset_editor_advanced__text-22                     | Étape 3                 |
| 48  | iconbutton-27 | IconButton | ghost     | preset_editor_advanced__iconbutton-27               | —                       |
| 49  | text-23       | Text       | —         | preset_editor_advanced__text-23                     | TIME                    |
| 50  | text-24       | Text       | —         | preset_editor_advanced__text-24                     | REPS                    |
| 51  | iconbutton-28 | IconButton | secondary | preset_editor_advanced__iconbutton-28               | —                       |
| 52  | text-25       | Text       | —         | preset_editor_advanced__text-25                     | 01 : 30                 |
| 53  | iconbutton-29 | IconButton | secondary | preset_editor_advanced__iconbutton-29               | —                       |
| 54  | button-4      | Button     | ghost     | preset_editor_advanced__button-4                    | COLOR                   |
| 55  | iconbutton-30 | IconButton | ghost     | preset_editor_advanced__iconbutton-30               | —                       |
| 56  | iconbutton-31 | IconButton | ghost     | preset_editor_advanced__iconbutton-31               | —                       |
| 57  | text-26       | Text       | —         | preset_editor_advanced__text-26                     | Étape 3 bis             |
| 58  | iconbutton-33 | IconButton | ghost     | preset_editor_advanced__iconbutton-33               | —                       |
| 59  | text-27       | Text       | —         | preset_editor_advanced__text-27                     | TIME                    |
| 60  | text-28       | Text       | —         | preset_editor_advanced__text-28                     | REPS                    |
| 61  | iconbutton-34 | IconButton | secondary | preset_editor_advanced__iconbutton-34               | —                       |
| 62  | text-29       | Text       | —         | preset_editor_advanced__text-29                     | 01 : 30                 |
| 63  | iconbutton-35 | IconButton | secondary | preset_editor_advanced__iconbutton-35               | —                       |
| 64  | button-5      | Button     | ghost     | preset_editor_advanced__button-5                    | COLOR                   |
| 65  | iconbutton-36 | IconButton | ghost     | preset_editor_advanced__iconbutton-36               | —                       |
| 66  | iconbutton-37 | IconButton | ghost     | preset_editor_advanced__iconbutton-37               | —                       |
| 67  | iconbutton-39 | IconButton | ghost     | preset_editor_advanced__iconbutton-39               | —                       |
| 68  | text-30       | Text       | —         | preset_editor_advanced__text-30                     | 3:00                    |
| 69  | iconbutton-40 | IconButton | ghost     | preset_editor_advanced__iconbutton-40               | —                       |
| 70  | text-31       | Text       | —         | preset_editor_advanced__text-31                     | TOTAL 03:35             |
| 71  | text-32       | Text       | —         | preset_editor_advanced__text-32                     | FINISH                  |
| 72  | button-6      | Button     | ghost     | preset_editor_advanced__button-6                    | COLOR                   |
| 73  | text-33       | Text       | —         | preset_editor_advanced__text-33                     | ALARM                   |
| 74  | icon-4        | Icon       | —         | preset_editor_advanced__icon-4                      | —                       |
| 75  | text-34       | Text       | —         | preset_editor_advanced__text-34                     | BEEP X3                 |

**Excluded (per user decision):** iconbutton-2 (more_vert grp1), iconbutton-10 (settings step1), iconbutton-18 (settings step2), iconbutton-20 (more_vert grp2), iconbutton-24 (more_vert grp3), iconbutton-32 (settings step3), iconbutton-38 (settings step3bis), icon-3 (trending_down — deferred).

**Excluded (system):** container-0 (status bar), text-0, icon-0, icon-1, text-1, icon-2.

## 2.2 Sections / blocs (structure visuelle)

| sectionId       | intitulé (verbatim)    | description courte                        | composants inclus (ordonnés)                     |
|-----------------|------------------------|-------------------------------------------|--------------------------------------------------|
| s_header        | —                      | Barre haut : Fermer, SIMPLE/ADVANCED, Sauvegarder | iconbutton-0, button-0, button-1, iconbutton-1 |
| s_name          | Nom prédéfini          | Champ de saisie nom du preset              | text-2, text-3 (container-4)                     |
| s_group_1       | RÉPÉTITIONS (grp 1)   | Groupe 1 : reps + étapes 1 et 2           | card-0 (text-4..text-16, iconbutton-3..19)       |
| s_step_1        | Étape 1                | Étape 1 (magenta) — mode TIME              | card-1 (text-6..text-9, iconbutton-5..9)         |
| s_step_2        | Étape 2                | Étape 2 (lavender) — mode REPS             | card-2 (text-10..text-15, iconbutton-11..17)     |
| s_group_2       | RÉPÉTITIONS (grp 2)   | Groupe 2 : reps (vide, pas d'étapes)       | card-3 (text-17..text-19, iconbutton-21..23)     |
| s_group_3       | RÉPÉTITIONS (grp 3)   | Groupe 3 : reps + étapes 3 et 3 bis        | card-4 (text-20..text-30, iconbutton-25..39)     |
| s_step_3        | Étape 3                | Étape 3 (vert) — mode TIME                 | card-5 (text-22..text-25, iconbutton-27..31)     |
| s_step_3bis     | Étape 3 bis            | Étape 3 bis (rouge) — mode TIME            | card-6 (text-26..text-29, iconbutton-33..37)     |
| s_add_group     | —                      | Bouton ajouter nouveau groupe + total       | container-32 (iconbutton-40, text-31)            |
| s_finish        | FINISH                 | Carte finish : couleur + alarme             | card-7 (text-32..text-34, button-6, icon-4)      |

## 2.3 Libellés & textes

| usage      | valeur (verbatim + transform)            |
|------------|------------------------------------------|
| Titre      | —                                        |
| Boutons    | SIMPLE, ADVANCED, COLOR                  |
| Sections   | RÉPÉTITIONS, TIME, REPS, FINISH, ALARM   |
| Cartes     | Étape 1, Étape 2, Étape 3, Étape 3 bis  |
| Valeurs    | 1, 3, 00 : 05, 10.0s, 01 : 30, 3:00    |
| Total      | TOTAL 03:35                              |
| Alarme     | BEEP X3                                  |
| Champ      | Nom prédéfini, Programme spécifique      |

## 2.4 Listes & tableaux (si applicable)

| listeId     | colonnes (ordre)               | tri par défaut | filtres | vide (empty state)        |
|-------------|--------------------------------|----------------|---------|---------------------------|
| groups_list | [group_card]                   | order (manual) | —       | Un groupe vide par défaut |
| steps_list  | [step_card] (within group)     | order (manual) | —       | Bouton "ajouter étape"    |

---

# 3. Interactions (par composant interactif)

| compId        | type       | variant → rôle      | a11y.ariaLabel                      | action                          | état(s) impactés            | navigation |
|---------------|------------|----------------------|-------------------------------------|---------------------------------|-----------------------------|------------|
| iconbutton-0  | IconButton | ghost → faible       | Fermer                              | `close()`                       | —                           | Pop        |
| button-0      | Button     | ghost → faible       | Mode simple                         | `switchToSimple()`              | viewMode=simple             | —          |
| button-1      | Button     | secondary → support  | Mode avancé                         | `switchToAdvanced()`            | viewMode=advanced           | —          |
| iconbutton-1  | IconButton | ghost → faible       | Enregistrer                         | `save()`                        | presets list                | Pop        |
| iconbutton-3  | IconButton | secondary → support  | Diminuer répétitions                | `decrementGroupReps(groupIdx)`  | group.repeatCount−1         | —          |
| iconbutton-4  | IconButton | secondary → support  | Augmenter répétitions               | `incrementGroupReps(groupIdx)`  | group.repeatCount+1         | —          |
| iconbutton-5  | IconButton | ghost → faible       | Réorganiser étape 1                 | `beginReorder(stepIdx)`         | drag state                  | —          |
| text-7/text-8 | Text (tap) | —                    | —                                   | `toggleStepMode(stepIdx)`       | step.mode=TIME↔REPS         | —          |
| iconbutton-6  | IconButton | secondary → support  | Diminuer temps étape 1              | `decrementStepValue(stepIdx)`   | step.durationSeconds−1      | —          |
| iconbutton-7  | IconButton | secondary → support  | Augmenter temps étape 1             | `incrementStepValue(stepIdx)`   | step.durationSeconds+1      | —          |
| button-2      | Button     | ghost → faible       | Choisir couleur étape 1             | `openColorPicker(stepIdx)`      | step.color                  | Dialog     |
| iconbutton-8  | IconButton | ghost → faible       | Dupliquer étape 1                   | `duplicateStep(stepIdx)`        | steps list (insert after)   | —          |
| iconbutton-9  | IconButton | ghost → faible       | Supprimer étape 1                   | `deleteStep(stepIdx)`           | steps list (remove)         | —          |
| iconbutton-12 | IconButton | secondary → support  | Diminuer répétitions étape 2        | `decrementStepValue(stepIdx)`   | step.repeatCount−1          | —          |
| iconbutton-13 | IconButton | secondary → support  | Augmenter répétitions étape 2       | `incrementStepValue(stepIdx)`   | step.repeatCount+1          | —          |
| iconbutton-14 | IconButton | secondary → support  | Diminuer durée étape 2              | `decrementStepDuration(stepIdx)` | step.durationSeconds−1     | —          |
| iconbutton-15 | IconButton | secondary → support  | Augmenter durée étape 2             | `incrementStepDuration(stepIdx)` | step.durationSeconds+1     | —          |
| iconbutton-19 | IconButton | ghost → faible       | Ajouter étape au groupe 1           | `addStep(groupIdx)`             | steps list (append)         | —          |
| iconbutton-23 | IconButton | ghost → faible       | Ajouter étape au groupe 2           | `addStep(groupIdx)`             | steps list (append)         | —          |
| iconbutton-39 | IconButton | ghost → faible       | Ajouter étape au groupe 3           | `addStep(groupIdx)`             | steps list (append)         | —          |
| iconbutton-40 | IconButton | ghost → faible       | Ajouter un nouveau groupe           | `addGroup()`                    | groups list (append)        | —          |
| button-6      | Button     | ghost → faible       | Choisir couleur finish              | `openFinishColorPicker()`       | finishColor                 | Dialog     |

**Gestes & clavier** : Drag handle (iconbutton-5, -11, -27, -33) pour réordonner les étapes par glisser-déposer.

**Feedback** : SnackBar sur erreur de sauvegarde (nom vide). Animation de suppression/ajout d'étapes.

---

# 4. Règles fonctionnelles & métier

## 4.1 Champs obligatoires / validations

| champ/compId | règle                   | message d'erreur (verbatim)     |
|--------------|-------------------------|---------------------------------|
| text-3 (nom) | trim().isNotEmpty       | Veuillez saisir un nom          |
| group.reps   | ≥ 1, ≤ 999             | —                               |
| step.duration| ≥ 0, ≤ 3599            | —                               |
| step.reps    | ≥ 1, ≤ 999             | —                               |

## 4.2 Calculs & conditions d'affichage

| règle                         | condition                           | impact UI                              | notes                              |
|-------------------------------|-------------------------------------|----------------------------------------|------------------------------------|
| Total duration                | Σ (group.reps × Σ step.effectiveDuration) pour chaque groupe | Affiché dans text-31 "TOTAL mm:ss" | Recalculé à chaque modification    |
| Group subtotal                | group.reps × Σ step.effectiveDuration | Affiché en bas de chaque groupe (text-16, text-19, text-30) | —                |
| Step effective duration       | mode=TIME: durationSeconds; mode=REPS: repeatCount × durationSeconds | Utilisé dans le calcul total | —        |
| Step mode toggle              | Tap TIME/REPS labels                | Bascule entre affichage chrono et compteur reps | Bold = mode actif, muted = inactif |
| Step mode REPS display        | mode=REPS                           | Affiche "N x" + durée au lieu du seul chrono | Voir Étape 2 dans le design      |
| Minimum 1 group               | groups.length ≥ 1                   | Impossible de supprimer le dernier groupe | —                                 |
| TEXT contrast                  | Step card bg color → text color    | Dark bg = white text; light bg = black text | Déterminer automatiquement         |

## 4.3 États vides & erreurs

| contexte                | rendu                                         | action de sortie              |
|-------------------------|-----------------------------------------------|-------------------------------|
| Groupe sans étapes      | Carte groupe avec seulement reps + bouton add | Tap "+" pour ajouter          |
| Nom vide à la save      | SnackBar erreur                               | Corriger le nom               |

---

# 5. Navigation

## 5.1 Origines (arrivées sur l'écran)

| action utilisateur             | écran source | paramètres                     | remarques         |
|--------------------------------|-------------|--------------------------------|--------------------|
| Tap "AJOUTER" preset          | HomeScreen  | —                              | Mode création      |
| Tap carte preset (edit)       | HomeScreen  | presetId, isEditMode=true      | Mode édition       |

## 5.2 Cibles (sorties de l'écran)

| déclencheur     | écran cible | paramètres | remarques                      |
|-----------------|-------------|------------|--------------------------------|
| Tap Fermer (X)  | HomeScreen  | —          | Pop sans sauvegarde            |
| Tap Enregistrer | HomeScreen  | —          | Pop après sauvegarde réussie   |

## 5.3 Événements système
- **Back physique** : Équivalent à Fermer (pop sans sauvegarde).

---

# 6. Modèle d'état & API internes

## 6.1 État local (store/widget)

| clé                | type                 | défaut          | persistance | notes                                    |
|--------------------|----------------------|-----------------|-------------|------------------------------------------|
| name               | String               | ""              | oui (preset)| Nom du preset                            |
| viewMode           | ViewMode enum        | simple          | non         | simple\|advanced                         |
| groups             | List\<WorkoutGroup\> | [1 group, 1 step] | oui (preset)| Liste des groupes                      |
| editMode           | bool                 | false           | non         | true si édition d'un preset existant     |
| presetId           | String?              | null            | non         | ID du preset en édition                  |
| finishColor        | Color                | #CDDC39         | oui (preset)| Couleur du bloc FINISH                   |
| finishAlarmBeeps   | int                  | 3               | oui (preset)| Nombre de beeps à la fin                 |

**WorkoutGroup:**

| clé          | type              | défaut | notes                       |
|--------------|-------------------|--------|-----------------------------|
| id           | String            | uuid   |                             |
| repeatCount  | int               | 1      | ≥ 1, ≤ 999                 |
| steps        | List\<WorkoutStep\> | []   | Étapes du groupe            |
| order        | int               | auto   | Position dans la séquence   |

**AdvancedStep:**

| clé              | type         | défaut    | notes                           |
|------------------|--------------|-----------|---------------------------------|
| id               | String       | uuid      |                                 |
| name             | String       | "Étape N" | Nom affiché                     |
| durationSeconds  | int          | 5         | ≥ 0, ≤ 3599                    |
| color            | Color        | stepMagenta | Couleur de fond de la carte   |
| order            | int          | auto      | Position dans le groupe         |
| mode             | StepMode enum| time      | time\|reps                      |
| repeatCount      | int          | 1         | Utilisé si mode=reps, ≥ 1      |

## 6.2 Actions / effets

| nom                           | entrée                | sortie | erreurs            | description                                          |
|-------------------------------|-----------------------|--------|--------------------|------------------------------------------------------|
| switchToSimple                | —                     | —      | —                  | viewMode → simple                                    |
| switchToAdvanced              | —                     | —      | —                  | viewMode → advanced                                  |
| onNameChange                  | String                | —      | —                  | Met à jour le nom                                    |
| addGroup                      | —                     | —      | —                  | Ajoute un groupe vide à la fin                       |
| removeGroup                   | int groupIdx          | —      | min 1 group        | Supprime le groupe à l'index                         |
| incrementGroupReps            | int groupIdx          | —      | max 999            | group.repeatCount + 1                                |
| decrementGroupReps            | int groupIdx          | —      | min 1              | group.repeatCount − 1                                |
| addStep                       | int groupIdx          | —      | —                  | Ajoute une étape par défaut au groupe                |
| removeStep                    | int groupIdx, int stepIdx | —  | —                  | Supprime l'étape                                     |
| duplicateStep                 | int groupIdx, int stepIdx | —  | —                  | Duplique l'étape après l'originale                   |
| reorderStep                   | int groupIdx, int oldIdx, int newIdx | — | — | Réordonne l'étape dans le groupe                    |
| toggleStepMode                | int groupIdx, int stepIdx | — | —                  | Bascule TIME ↔ REPS                                  |
| incrementStepValue            | int groupIdx, int stepIdx | — | max 3599/999       | +1 sur la valeur active (duration ou repeatCount)    |
| decrementStepValue            | int groupIdx, int stepIdx | — | min 0/1            | −1 sur la valeur active                              |
| incrementStepDuration         | int groupIdx, int stepIdx | — | max 3599           | +1 sur durationSeconds (mode REPS seulement)         |
| decrementStepDuration         | int groupIdx, int stepIdx | — | min 0              | −1 sur durationSeconds (mode REPS seulement)         |
| setStepColor                  | int groupIdx, int stepIdx, Color | — | —          | Change la couleur de l'étape                         |
| setFinishColor                | Color                 | —      | —                  | Change la couleur du bloc FINISH                     |
| save                          | —                     | bool   | nom vide           | Valide et persiste le preset                         |
| close                         | —                     | —      | —                  | Nettoyage                                            |

---

# 7. Accessibilité

| compId        | ariaLabel (design)             | rôle sémantique | focus order | raccourcis | notes |
|---------------|--------------------------------|-----------------|-------------|------------|-------|
| iconbutton-0  | Fermer                         | button          | 1           | —          | —     |
| button-0      | Mode simple                    | button          | 2           | —          | —     |
| button-1      | Mode avancé                    | button          | 3           | —          | —     |
| iconbutton-1  | Enregistrer                    | button          | 4           | —          | —     |
| iconbutton-3  | Diminuer répétitions           | button          | 5           | —          | —     |
| iconbutton-4  | Augmenter répétitions          | button          | 6           | —          | —     |
| iconbutton-5  | Réorganiser étape 1            | button          | 7           | —          | drag  |
| iconbutton-6  | Diminuer temps étape 1         | button          | 8           | —          | —     |
| iconbutton-7  | Augmenter temps étape 1        | button          | 9           | —          | —     |
| button-2      | Choisir couleur étape 1        | button          | 10          | —          | —     |
| iconbutton-8  | Dupliquer étape 1              | button          | 11          | —          | —     |
| iconbutton-9  | Supprimer étape 1              | button          | 12          | —          | —     |
| iconbutton-19 | Ajouter étape au groupe 1      | button          | 13          | —          | —     |
| iconbutton-40 | Ajouter un nouveau groupe      | button          | auto        | —          | —     |
| button-6      | Choisir couleur finish         | button          | auto        | —          | —     |

---

# 8. Thème & tokens requis

- **Couleurs sémantiques** : background (#000000), surface/cardBackground (#1C1C1C), headerBackgroundDark (#111111), textPrimary (#FFFFFF), textSecondary (#AAAAAA), onPrimary (#FFFFFF), inputBorder (#555555), stepMagenta (#CC1177), stepLavender (#B39DDB), stepGreen (#388E3C), stepRed (#D32F2F), finishYellow (#CDDC39), addButtonBg (#FFFFFF), addButtonFg (#000000)
- **Typographies** : titleLarge (22px bold), label (12-14px medium), body (14-16px regular), value (22-28px bold, custom sizes), muted (10-12px regular)
- **Contraste WCAG AA** : oui (texte blanc sur fond coloré, texte noir sur fond clair)

---

# 9. Scénarios d'usage (Given/When/Then)

## 9.1 Nominal

1. **Given** l'écran est en mode ADVANCED avec 1 groupe et 1 étape
   **When** l'utilisateur tape sur "+" (ajouter étape)
   **Then** une nouvelle étape par défaut apparaît dans le groupe.

2. **Given** une étape est en mode TIME affichant "00:05"
   **When** l'utilisateur tape sur le label "REPS"
   **Then** l'étape bascule en mode REPS et affiche "1 x" + durée.

3. **Given** le preset a un nom et au moins 1 groupe avec 1 étape
   **When** l'utilisateur tape sur "Enregistrer"
   **Then** le preset est sauvegardé et l'écran se ferme.

4. **Given** 2 étapes dans un groupe
   **When** l'utilisateur drag-and-drop une étape
   **Then** l'ordre des étapes est mis à jour.

## 9.2 Alternatives / Exceptions

- **Nom vide** : SnackBar "Veuillez saisir un nom", save échoue.
- **Suppression dernière étape** : Le groupe reste avec 0 étapes et affiche le bouton "+".
- **Groupe vide** : Groupe 2 dans le design (3 reps, aucune étape visible).

---

# 10. Traçabilité vers des tests

| id  | type   | préconditions                  | étapes                              | oracle attendu                                              |
|-----|--------|--------------------------------|-------------------------------------|-------------------------------------------------------------|
| T1  | widget | ADVANCED mode, 1 group         | Tap add step                        | New step card appears in group                              |
| T2  | widget | Step in TIME mode              | Tap REPS label                      | Step switches to REPS display (N x)                         |
| T3  | widget | Step in TIME, value "00:05"    | Tap "+" button                      | Value becomes "00:06"                                       |
| T4  | widget | Group with reps=1              | Tap "+" reps                        | Reps value becomes 2                                        |
| T5  | widget | Valid name + groups            | Tap save                            | Navigator.pop() called                                      |
| T6  | widget | Empty name                     | Tap save                            | SnackBar with error shown                                   |
| T7  | unit   | 2 groups, 2 steps each         | Calculate total                     | Σ(group.reps × Σ step.effectiveDuration) correct            |
| T8  | widget | 2 steps                        | Tap duplicate on step 1             | 3 steps, step 2 is copy of step 1                           |
| T9  | widget | 2 steps                        | Tap delete on step 1                | 1 step remaining                                            |
| T10 | widget | FINISH card                    | Tap COLOR button                    | Color picker dialog opens                                   |

---

# 11. Hypothèses, hors périmètre & incertitudes

## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])

| # | énoncé                                                           | confiance |
|---|------------------------------------------------------------------|-----------|
| 1 | Les couleurs d'étape (magenta, lavender, green, red) sont des estimations visuelles. Les vraies valeurs seront ajustables par l'utilisateur via le color picker. | 0.75 |
| 2 | Le toggle TIME/REPS est un tap sur le label correspondant (text bold = actif, text muted = inactif). | 0.80 |
| 3 | Le modèle SIMPLE existant continue de fonctionner tel quel ; la conversion SIMPLE→ADVANCED n'est pas dans cette itération. | 0.85 |
| 4 | Le drag handle (material.drag_handle) utilise ReorderableListView de Flutter. | 0.80 |

## 11.2 Hors périmètre

- trending_down (répétitions dégressives) — reporté
- Boutons settings et more_vert — exclus du build
- Conversion automatique SIMPLE → ADVANCED — itération future
- Impact sur WorkoutScreen — itération future

## 11.3 Incertitudes / questions ouvertes

- Le color picker : utiliser un package externe (flex_color_picker) ou un sélecteur maison ? → Package externe recommandé.
- Persistance des groupes/étapes dans le modèle Preset existant : nécessite extension du modèle JSON. → Voir plan.md.

---

# 12. Contraintes
- **Authentification** : —
- **Sécurité** : —
- **Performance** : Scroll fluide avec N groupes × M étapes. ReorderableListView.
- **Accessibilité** : a11y labels sur tous les interactifs, drag handles annoncés.
- **Compatibilité** : Les presets SIMPLE existants doivent continuer à fonctionner (pas de migration breaking).

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (variants: `cta|primary|secondary|ghost`; placement: `start|center|end|stretch`; widthMode: `fixed|hug|fill`).
- Formats : dates ISO-8601, nombres entiers en px, booléens en `true|false`.
- Interdictions : pas de synonymes pour les variants, pas de texte « TBD ».
- Clés stables : `preset_editor_advanced__{compId}`.
