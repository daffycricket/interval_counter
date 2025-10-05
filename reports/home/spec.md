---
# Deterministic Functional Spec — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
specVersion: 2
generatedAt: 2025-10-05T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : Écran principal de configuration de minuteur d'intervalles
- **Code technique / ID** : `interval_timer_home`
- **Type d'écran** : Form / Settings (formulaire de configuration)
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Configurer rapidement un minuteur d'intervalles (répétitions, temps de travail, temps de repos)
  - Démarrer un intervalle de timing immédiatement
  - Gérer le volume audio
  - Sauvegarder des préréglages personnalisés
  - Charger et utiliser des préréglages existants

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId        | type        | variant   | key (stable)                           | texte (après transform) |
|-----|---------------|-------------|-----------|----------------------------------------|-------------------------|
| 1   | Container-1   | Container   | —         | interval_timer_home__Container-1       | —                       |
| 2   | IconButton-2  | IconButton  | ghost     | interval_timer_home__IconButton-2      | —                       |
| 3   | Slider-3      | Slider      | —         | interval_timer_home__Slider-3          | —                       |
| 4   | Icon-4        | Icon        | —         | —                                      | —                       |
| 5   | IconButton-5  | IconButton  | ghost     | interval_timer_home__IconButton-5      | —                       |
| 6   | Card-6        | Card        | —         | interval_timer_home__Card-6            | —                       |
| 7   | Container-7   | Container   | —         | interval_timer_home__Container-7       | —                       |
| 8   | Text-8        | Text        | —         | —                                      | Démarrage rapide        |
| 9   | IconButton-9  | IconButton  | ghost     | interval_timer_home__IconButton-9      | —                       |
| 10  | Text-10       | Text        | —         | —                                      | RÉPÉTITIONS             |
| 11  | IconButton-11 | IconButton  | ghost     | interval_timer_home__IconButton-11     | —                       |
| 12  | Text-12       | Text        | —         | interval_timer_home__Text-12           | 16                      |
| 13  | IconButton-13 | IconButton  | ghost     | interval_timer_home__IconButton-13     | —                       |
| 14  | Text-14       | Text        | —         | —                                      | TRAVAIL                 |
| 15  | IconButton-15 | IconButton  | ghost     | interval_timer_home__IconButton-15     | —                       |
| 16  | Text-16       | Text        | —         | interval_timer_home__Text-16           | 00 : 44                 |
| 17  | IconButton-17 | IconButton  | ghost     | interval_timer_home__IconButton-17     | —                       |
| 18  | Text-18       | Text        | —         | —                                      | REPOS                   |
| 19  | IconButton-19 | IconButton  | ghost     | interval_timer_home__IconButton-19     | —                       |
| 20  | Text-20       | Text        | —         | interval_timer_home__Text-20           | 00 : 15                 |
| 21  | IconButton-21 | IconButton  | ghost     | interval_timer_home__IconButton-21     | —                       |
| 22  | Button-22     | Button      | ghost     | interval_timer_home__Button-22         | SAUVEGARDER             |
| 23  | Button-23     | Button      | cta       | interval_timer_home__Button-23         | COMMENCER               |
| 24  | Container-24  | Container   | —         | interval_timer_home__Container-24      | —                       |
| 25  | Text-25       | Text        | —         | —                                      | VOS PRÉRÉGLAGES         |
| 26  | IconButton-26 | IconButton  | ghost     | interval_timer_home__IconButton-26     | —                       |
| 27  | Button-27     | Button      | secondary | interval_timer_home__Button-27         | + AJOUTER               |
| 28  | Card-28       | Card        | —         | interval_timer_home__Card-28           | —                       |
| 29  | Container-29  | Container   | —         | interval_timer_home__Container-29      | —                       |
| 30  | Text-30       | Text        | —         | —                                      | gainage                 |
| 31  | Text-31       | Text        | —         | —                                      | 14:22                   |
| 32  | Text-32       | Text        | —         | —                                      | RÉPÉTITIONS 20x         |
| 33  | Text-33       | Text        | —         | —                                      | TRAVAIL 00:40           |
| 34  | Text-34       | Text        | —         | —                                      | REPOS 00:03             |

> Règle de clé: `{screenName}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId         | intitulé (verbatim) | description courte                           | composants inclus (ordonnés)                                    |
|-------------------|---------------------|----------------------------------------------|-----------------------------------------------------------------|
| s_header          | —                   | Barre d'en-tête avec volume et menu          | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5       |
| s_quick_start     | Démarrage rapide    | Carte de configuration rapide                | Card-6, Container-7, Text-8, IconButton-9, Text-10...Text-20, IconButton-11,13,15,17,19,21, Button-22, Button-23 |
| s_presets_header  | VOS PRÉRÉGLAGES     | Barre de titre de la section des préréglages| Container-24, Text-25, IconButton-26, Button-27                 |
| s_preset_card_1   | gainage             | Carte de préréglage exemple                  | Card-28, Container-29, Text-30, Text-31, Text-32, Text-33, Text-34 |

## 2.3 Libellés & textes
| usage               | valeur (verbatim + transform)           |
|---------------------|-----------------------------------------|
| Titre section       | Démarrage rapide                        |
| Titre section       | VOS PRÉRÉGLAGES                         |
| Labels de champs    | RÉPÉTITIONS, TRAVAIL, REPOS             |
| Valeurs             | 16, 00 : 44, 00 : 15                    |
| Boutons             | SAUVEGARDER, COMMENCER, + AJOUTER       |
| Préréglage nom      | gainage                                 |
| Préréglage durée    | 14:22                                   |
| Préréglage détails  | RÉPÉTITIONS 20x, TRAVAIL 00:40, REPOS 00:03 |

## 2.4 Listes & tableaux (si applicable)
| listeId          | colonnes (ordre)                                  | tri par défaut | filtres | vide (empty state) |
|------------------|---------------------------------------------------|----------------|---------|--------------------|
| presets_list     | Nom, Durée totale, Répétitions, Travail, Repos   | Date modif desc| —       | Aucun préréglage   |

---

# 3. Interactions (par composant interactif)
| compId        | type       | variant → rôle          | a11y.ariaLabel                      | action (onTap/submit/…)          | état(s) impactés                  | navigation |
|---------------|------------|-------------------------|-------------------------------------|----------------------------------|-----------------------------------|------------|
| IconButton-2  | IconButton | ghost → faible          | Régler le volume                    | `toggleVolumeSettings()`         | `showVolumeSlider=toggle`         | —          |
| Slider-3      | Slider     | —                       | Curseur de volume                   | `setVolume(value)`               | `volumeLevel=value`               | —          |
| IconButton-5  | IconButton | ghost → faible          | Plus d'options                      | `openMenu()`                     | —                                 | Menu       |
| IconButton-9  | IconButton | ghost → faible          | Replier la section Démarrage rapide | `toggleQuickStartSection()`      | `quickStartExpanded=toggle`       | —          |
| IconButton-11 | IconButton | ghost → faible          | Diminuer les répétitions            | `decrementReps()`                | `repetitions-=1`                  | —          |
| IconButton-13 | IconButton | ghost → faible          | Augmenter les répétitions           | `incrementReps()`                | `repetitions+=1`                  | —          |
| IconButton-15 | IconButton | ghost → faible          | Diminuer le temps de travail        | `decrementWork()`                | `workSeconds-=stepSize`           | —          |
| IconButton-17 | IconButton | ghost → faible          | Augmenter le temps de travail       | `incrementWork()`                | `workSeconds+=stepSize`           | —          |
| IconButton-19 | IconButton | ghost → faible          | Diminuer le temps de repos          | `decrementRest()`                | `restSeconds-=stepSize`           | —          |
| IconButton-21 | IconButton | ghost → faible          | Augmenter le temps de repos         | `incrementRest()`                | `restSeconds+=stepSize`           | —          |
| Button-22     | Button     | ghost → faible          | Sauvegarder le préréglage rapide    | `saveQuickStartPreset()`         | `presets+=[current config]`       | —          |
| Button-23     | Button     | cta → primaire          | Démarrer l'intervalle               | `startInterval()`                | —                                 | →Timer     |
| IconButton-26 | IconButton | ghost → faible          | Éditer les préréglages              | `enterEditMode()`                | `editMode=true`                   | —          |
| Button-27     | Button     | secondary → supportive  | Ajouter un préréglage               | `createNewPreset()`              | —                                 | →Editor    |
| Card-28       | Card       | —                       | —                                   | `selectPreset('gainage')`        | `load preset → (reps,work,rest)`  | —          |

- **Gestes & clavier** : 
  - Tap sur icônes + / − pour incrémenter / décrémenter
  - Drag sur Slider-3 pour ajuster le volume
  - Tap sur Card-28 pour charger un préréglage
  - Enter sur le bouton COMMENCER (focus)
- **Feedback** : 
  - Désactivation du bouton COMMENCER si configuration invalide
  - Snackbar de confirmation après sauvegarde de préréglage
  - Animation de transition lors du changement d'écran
- **Règles de placement ayant un impact** : 
  - Bouton COMMENCER en `widthMode=fill` prend toute la largeur disponible
  - Bouton SAUVEGARDER en `placement=end` aligné à droite
  - Bouton + AJOUTER en `placement=end` aligné à droite

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle                                   | message d'erreur (verbatim)          |
|--------------|-----------------------------------------|--------------------------------------|
| Text-12      | repetitions >= 1                        | Les répétitions doivent être ≥ 1     |
| Text-16      | workSeconds >= 1                        | Le temps de travail doit être ≥ 1s   |
| Text-20      | restSeconds >= 0                        | Le temps de repos doit être ≥ 0s     |
| —            | repetitions <= 999                      | Maximum 999 répétitions              |
| —            | workSeconds <= 3599 (59:59)             | Maximum 59:59 pour le travail        |
| —            | restSeconds <= 3599 (59:59)             | Maximum 59:59 pour le repos          |

## 4.2 Calculs & conditions d'affichage
| règle                        | condition                     | impact UI                                      | notes                                    |
|------------------------------|-------------------------------|------------------------------------------------|------------------------------------------|
| Total duration calculation   | totalSecs = reps * (work+rest)| Affiché dans Text-31 pour chaque préréglage   | Format MM:SS                             |
| COMMENCER button enabled     | reps>=1 AND work>=1 AND rest>=0| Button-23 `enabled=true`                      | Sinon désactivé avec opacité réduite     |
| QuickStart section visibility| quickStartExpanded==true      | Card-6 visible, IconButton-9 icon=expand_less  | Sinon card cachée, icon=expand_more      |

## 4.3 États vides & erreurs
| contexte              | rendu                                              | action de sortie                      |
|-----------------------|----------------------------------------------------|---------------------------------------|
| Aucun préréglage      | Message "Aucun préréglage enregistré"              | Tap sur Button-27 pour créer          |
| Configuration invalide| Button-23 désactivé, tooltip explicatif           | Corriger les valeurs                  |
| Erreur de sauvegarde  | Snackbar d'erreur rouge                            | Réessayer                             |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur         | écran source | paramètres | remarques                  |
|----------------------------|--------------|------------|----------------------------|
| Lancement de l'application | (splash)     | —          | Écran par défaut           |
| Retour depuis Timer        | TimerScreen  | —          | Back hardware ou bouton    |
| Retour depuis PresetEditor | PresetEditor | —          | Après création/édition     |

## 5.2 Cibles (sorties de l'écran)
| déclencheur                | écran cible  | paramètres                            | remarques                                        |
|----------------------------|--------------|---------------------------------------|--------------------------------------------------|
| Tap sur Button-23          | TimerScreen  | {reps, work, rest}                    | Démarrage d'un intervalle                        |
| Tap sur Button-27          | PresetEditor | mode=create                           | Création d'un nouveau préréglage                 |
| Tap sur IconButton-5       | MenuScreen   | —                                     | Menu d'options                                   |

## 5.3 Événements système
- **Back physique** : Quitte l'app (confirmation si modifications non sauvegardées)
- **Timer / notifications** : —
- **Permissions** : Aucune permission requise pour cet écran

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé                  | type     | défaut | persistance | notes                                    |
|----------------------|----------|--------|-------------|------------------------------------------|
| repetitions          | int      | 16     | oui         | Nombre de répétitions                    |
| workSeconds          | int      | 44     | oui         | Durée de travail en secondes             |
| restSeconds          | int      | 15     | oui         | Durée de repos en secondes               |
| volumeLevel          | double   | 0.62   | oui         | Volume normalisé [0.0-1.0]               |
| quickStartExpanded   | bool     | true   | oui         | État d'expansion de la section rapide    |
| editMode             | bool     | false  | non         | Mode édition des préréglages             |
| presets              | List<Preset> | []  | oui         | Liste des préréglages sauvegardés        |

## 6.2 Actions / effets
| nom                      | entrée                        | sortie | erreurs                 | description                                           |
|--------------------------|-------------------------------|--------|-------------------------|-------------------------------------------------------|
| incrementReps            | —                             | —      | max_reached             | Incrémente repetitions (max 999)                      |
| decrementReps            | —                             | —      | min_reached             | Décrémente repetitions (min 1)                        |
| incrementWork            | —                             | —      | max_reached             | Incrémente workSeconds (step 1s, max 3599)            |
| decrementWork            | —                             | —      | min_reached             | Décrémente workSeconds (step 1s, min 1)               |
| incrementRest            | —                             | —      | max_reached             | Incrémente restSeconds (step 1s, max 3599)            |
| decrementRest            | —                             | —      | min_reached             | Décrémente restSeconds (step 1s, min 0)               |
| setVolume                | double value                  | —      | —                       | Met à jour volumeLevel                                |
| toggleQuickStartSection  | —                             | —      | —                       | Bascule quickStartExpanded                            |
| saveQuickStartPreset     | —                             | Preset | save_failed             | Sauvegarde la config actuelle comme préréglage        |
| startInterval            | —                             | —      | invalid_config          | Navigate vers TimerScreen avec les paramètres actuels |
| selectPreset             | String presetId               | —      | preset_not_found        | Charge un préréglage dans la config rapide            |
| createNewPreset          | —                             | —      | —                       | Navigate vers PresetEditor en mode création           |
| enterEditMode            | —                             | —      | —                       | Passe en mode édition des préréglages                 |
| openMenu                 | —                             | —      | —                       | Ouvre le menu d'options                               |

---

# 7. Accessibilité
| compId        | ariaLabel (design)                          | rôle sémantique | focus order | raccourcis | notes                                      |
|---------------|---------------------------------------------|-----------------|-------------|------------|--------------------------------------------|
| IconButton-2  | Régler le volume                            | button          | 1           | —          | —                                          |
| Slider-3      | Curseur de volume                           | slider          | 2           | ←→         | Ajustement par flèches                     |
| IconButton-5  | Plus d'options                              | button          | 3           | —          | —                                          |
| IconButton-9  | Replier la section Démarrage rapide         | button          | 4           | —          | —                                          |
| IconButton-11 | Diminuer les répétitions                    | button          | 5           | —          | —                                          |
| Text-12       | —                                           | text            | —           | —          | Valeur lue par screenreader                |
| IconButton-13 | Augmenter les répétitions                   | button          | 6           | —          | —                                          |
| IconButton-15 | Diminuer le temps de travail                | button          | 7           | —          | —                                          |
| Text-16       | —                                           | text            | —           | —          | Valeur lue par screenreader                |
| IconButton-17 | Augmenter le temps de travail               | button          | 8           | —          | —                                          |
| IconButton-19 | Diminuer le temps de repos                  | button          | 9           | —          | —                                          |
| Text-20       | —                                           | text            | —           | —          | Valeur lue par screenreader                |
| IconButton-21 | Augmenter le temps de repos                 | button          | 10          | —          | —                                          |
| Button-22     | Sauvegarder le préréglage rapide            | button          | 11          | —          | —                                          |
| Button-23     | Démarrer l'intervalle                       | button          | 12          | Enter      | Bouton principal, focusable par Enter      |
| IconButton-26 | Éditer les préréglages                      | button          | 13          | —          | —                                          |
| Button-27     | Ajouter un préréglage                       | button          | 14          | —          | —                                          |

---

# 8. Thème & tokens requis
- **Couleurs sémantiques utilisées** : 
  - `primary` (#607D8B)
  - `onPrimary` (#FFFFFF)
  - `background` (#F2F2F2)
  - `surface` (#FFFFFF)
  - `textPrimary` (#212121)
  - `textSecondary` (#616161)
  - `divider` (#E0E0E0)
  - `accent` (#FFC107)
  - `sliderActive` (#FFFFFF)
  - `sliderInactive` (#90A4AE)
  - `sliderThumb` (#FFFFFF)
  - `border` (#DDDDDD)
  - `cta` (#607D8B)
  - `headerBackgroundDark` (#455A64)
  - `presetCardBg` (#FAFAFA)

- **Typographies référencées (`typographyRef`)** : 
  - `titleLarge` (Text-8: Démarrage rapide)
  - `label` (Text-10, Text-14, Text-18, Button-22, Button-27)
  - `value` (Text-12, Text-16, Text-20, Text-31)
  - `title` (Text-25, Text-30, Button-23)
  - `body` (Text-32, Text-33, Text-34)

- **Exigences de contraste (WCAG AA)** : Oui
  - Ratio minimum 4.5:1 pour le texte normal
  - Ratio minimum 3:1 pour le texte large et les composants UI

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran est affiché avec les valeurs par défaut (16 reps, 00:44 travail, 00:15 repos)  
   **When** l'utilisateur appuie sur **COMMENCER** (Button-23)  
   **Then** Navigation vers TimerScreen avec les paramètres {reps:16, work:44, rest:15}

2. **Given** l'écran est affiché  
   **When** l'utilisateur appuie sur IconButton-13 (augmenter répétitions) 3 fois  
   **Then** Text-12 affiche "19"

3. **Given** l'écran est affiché  
   **When** l'utilisateur appuie sur la carte préréglage "gainage" (Card-28)  
   **Then** Les valeurs sont chargées: Text-12="20", Text-16="00:40", Text-20="00:03"

4. **Given** l'écran est affiché avec une configuration modifiée  
   **When** l'utilisateur appuie sur **SAUVEGARDER** (Button-22)  
   **Then** Un nouveau préréglage est créé et ajouté à la liste, snackbar de confirmation affiché

## 9.2 Alternatives / Exceptions
- **Valeur minimale atteinte** : IconButton de décrémentation désactivé (opacité réduite)
- **Valeur maximale atteinte** : IconButton d'incrémentation désactivé (opacité réduite)
- **Liste vide de préréglages** : Message "Aucun préréglage enregistré" + bouton "+ AJOUTER" mis en évidence
- **Erreur de sauvegarde** : Snackbar d'erreur "Impossible de sauvegarder le préréglage" + bouton "Réessayer"

---

# 10. Traçabilité vers des tests
| id  | type (widget/golden/unit) | préconditions                           | étapes                                                | oracle attendu                                                        |
|-----|---------------------------|-----------------------------------------|-------------------------------------------------------|-----------------------------------------------------------------------|
| T1  | widget                    | État initial (reps=16)                  | tap sur IconButton-13 (augmenter répétitions)         | Text-12 affiche "17"                                                  |
| T2  | widget                    | État initial (reps=16)                  | tap sur IconButton-11 (diminuer répétitions)          | Text-12 affiche "15"                                                  |
| T3  | widget                    | État avec reps=1                        | tap sur IconButton-11                                 | reps reste à 1, IconButton-11 désactivé                               |
| T4  | widget                    | État initial                            | tap sur Button-23 (COMMENCER)                         | Navigation vers TimerScreen avec paramètres corrects                  |
| T5  | widget                    | État initial                            | tap sur Card-28 (préréglage "gainage")                | Valeurs chargées: reps=20, work=40s, rest=3s                          |
| T6  | widget                    | Configuration modifiée                  | tap sur Button-22 (SAUVEGARDER)                       | Nouveau préréglage créé, snackbar de confirmation affiché             |
| T7  | widget                    | État initial                            | drag sur Slider-3 à 0.8                               | volumeLevel=0.8, feedback visuel du slider                            |
| T8  | widget                    | quickStartExpanded=true                 | tap sur IconButton-9                                  | Section repliée, icon devient expand_more                             |
| T9  | golden                    | État initial                            | render complet de l'écran                             | Snapshot conforme au design.json                                      |
| T10 | unit                      | reps=16, work=44, rest=15               | appel calculateTotalDuration()                        | retourne 944 secondes (15:44)                                         |
| T11 | widget                    | État initial                            | tap sur Button-27 (+ AJOUTER)                         | Navigation vers PresetEditor en mode création                         |
| T12 | widget                    | État avec work=1                        | tap sur IconButton-15 (diminuer travail)              | work reste à 1, IconButton-15 désactivé                               |
| T13 | a11y                      | Focus sur Button-23                     | press Enter                                           | startInterval() appelé, navigation vers TimerScreen                   |
| T14 | widget                    | État initial                            | tap sur IconButton-5 (menu)                           | Menu d'options affiché                                                |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé                                                                                              | confiance |
|---|-----------------------------------------------------------------------------------------------------|-----------|
| 1 | Couleurs estimées à partir du rendu (Material Design gris/bleu)                                     | 0.75      |
| 2 | Nom d'icône d'en-tête 'expand_less' supposé (chevron de repli)                                      | 0.70      |
| 3 | Positions/bbox approchées par inspection visuelle (sans mesure pixel-perfect)                       | 0.70      |
| 4 | Valeur du slider normalisée à ~0.62 d'après la position du pouce                                    | 0.70      |
| 5 | Les boutons 'Sauvegarder' et '+ Ajouter' modélisés en 'ghost/secondary' selon le rendu non rempli  | 0.80      |
| 6 | Le step d'incrémentation pour work/rest est de 1 seconde                                            | 0.85      |
| 7 | La persistance des valeurs se fait via SharedPreferences                                            | 0.80      |
| 8 | Le format de temps affiché est MM : SS avec espace autour des deux-points                           | 0.90      |

## 11.2 Hors périmètre
- Édition inline des préréglages (nécessite un écran dédié PresetEditor)
- Réorganisation par drag & drop des préréglages
- Import/Export de préréglages
- Synchronisation cloud
- Personnalisation des sons de notification
- Historique des séances passées

## 11.3 Incertitudes / questions ouvertes
- Quel est le comportement exact du tap sur IconButton-2 (volume) ? Ouvre-t-il un popup ou toggle-t-il simplement la visibilité du slider ?
- Y a-t-il une limite au nombre de préréglages pouvant être créés ?
- Le menu IconButton-5 donne-t-il accès à quelles fonctionnalités précisément ?
- Le préréglage "gainage" est-il un exemple ou fait-il partie des préréglages par défaut de l'app ?

---

# 12. Contraintes
- **Authentification** : Non requise pour cet écran
- **Sécurité** : Aucune donnée sensible manipulée
- **Performance** : 
  - Animations fluides (60 fps) lors des transitions
  - Réponse tactile < 100ms pour les boutons +/-
  - Chargement des préréglages < 200ms
- **Accessibilité** : 
  - Support complet du screen reader
  - Contraste WCAG AA minimum
  - Touch targets ≥ 44x44 dp
  - Support du scaling de texte (jusqu'à 200%)
- **Compatibilité** : 
  - Flutter SDK ≥ 3.0
  - Android ≥ 5.0 (API 21)
  - iOS ≥ 12.0

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, temps en secondes (int), volume normalisé (double [0.0-1.0]), booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Tous les textes sont copiés verbatim depuis `design.json` avec `style.transform` appliqué.
- Les actions utilisent des noms de méthodes en camelCase sans ambiguïté.
- Les états sont typés explicitement (int, double, bool, enum, List<T>).