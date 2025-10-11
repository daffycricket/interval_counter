---
# Deterministic Functional Spec — IntervalTimerHome

# YAML front matter for machine-readability
screenName: IntervalTimerHome
screenId: interval_timer_home
designSnapshotRef: 580c54bd-6e3f-44f9-86ef-ce42233fc0dd.png
specVersion: 2
generatedAt: 2025-10-11T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : IntervalTimerHome
- **Code technique / ID** : `interval_timer_home`
- **Type d'écran** : Form + List (configuration rapide + liste de préréglages)
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Permettre à l'utilisateur de configurer rapidement un minuteur d'intervalles (répétitions, temps de travail, temps de repos)
  - Démarrer un minuteur avec les paramètres configurés
  - Gérer le volume des annonces audio
  - Visualiser et accéder aux préréglages sauvegardés
  - Créer de nouveaux préréglages ou sauvegarder la configuration actuelle

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId        | type        | variant     | key (stable)                        | texte (après transform) |
|-----|---------------|-------------|-------------|-------------------------------------|-------------------------|
| 1   | Container-1   | Container   | —           | interval_timer_home__Container-1    | —                       |
| 2   | IconButton-2  | IconButton  | ghost       | interval_timer_home__IconButton-2   | —                       |
| 3   | Slider-3      | Slider      | —           | interval_timer_home__Slider-3       | —                       |
| 4   | Icon-4        | Icon        | —           | interval_timer_home__Icon-4         | —                       |
| 5   | IconButton-5  | IconButton  | ghost       | interval_timer_home__IconButton-5   | —                       |
| 6   | Card-6        | Card        | —           | interval_timer_home__Card-6         | —                       |
| 7   | Container-7   | Container   | —           | interval_timer_home__Container-7    | —                       |
| 8   | Text-8        | Text        | —           | interval_timer_home__Text-8         | Démarrage rapide        |
| 9   | IconButton-9  | IconButton  | ghost       | interval_timer_home__IconButton-9   | —                       |
| 10  | Text-10       | Text        | —           | interval_timer_home__Text-10        | RÉPÉTITIONS             |
| 11  | IconButton-11 | IconButton  | ghost       | interval_timer_home__IconButton-11  | —                       |
| 12  | Text-12       | Text        | —           | interval_timer_home__Text-12        | 16                      |
| 13  | IconButton-13 | IconButton  | ghost       | interval_timer_home__IconButton-13  | —                       |
| 14  | Text-14       | Text        | —           | interval_timer_home__Text-14        | TRAVAIL                 |
| 15  | IconButton-15 | IconButton  | ghost       | interval_timer_home__IconButton-15  | —                       |
| 16  | Text-16       | Text        | —           | interval_timer_home__Text-16        | 00 : 44                 |
| 17  | IconButton-17 | IconButton  | ghost       | interval_timer_home__IconButton-17  | —                       |
| 18  | Text-18       | Text        | —           | interval_timer_home__Text-18        | REPOS                   |
| 19  | IconButton-19 | IconButton  | ghost       | interval_timer_home__IconButton-19  | —                       |
| 20  | Text-20       | Text        | —           | interval_timer_home__Text-20        | 00 : 15                 |
| 21  | IconButton-21 | IconButton  | ghost       | interval_timer_home__IconButton-21  | —                       |
| 22  | Button-22     | Button      | ghost       | interval_timer_home__Button-22      | SAUVEGARDER             |
| 23  | Button-23     | Button      | cta         | interval_timer_home__Button-23      | COMMENCER               |
| 24  | Container-24  | Container   | —           | interval_timer_home__Container-24   | —                       |
| 25  | Text-25       | Text        | —           | interval_timer_home__Text-25        | VOS PRÉRÉGLAGES         |
| 26  | IconButton-26 | IconButton  | ghost       | interval_timer_home__IconButton-26  | —                       |
| 27  | Button-27     | Button      | secondary   | interval_timer_home__Button-27      | + AJOUTER               |
| 28  | Card-28       | Card        | —           | interval_timer_home__Card-28        | —                       |
| 29  | Container-29  | Container   | —           | interval_timer_home__Container-29   | —                       |
| 30  | Text-30       | Text        | —           | interval_timer_home__Text-30        | gainage                 |
| 31  | Text-31       | Text        | —           | interval_timer_home__Text-31        | 14:22                   |
| 32  | Text-32       | Text        | —           | interval_timer_home__Text-32        | RÉPÉTITIONS 20x         |
| 33  | Text-33       | Text        | —           | interval_timer_home__Text-33        | TRAVAIL 00:40           |
| 34  | Text-34       | Text        | —           | interval_timer_home__Text-34        | REPOS 00:03             |

> Règle de clé: `{screenId}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId        | intitulé (verbatim)  | description courte                      | composants inclus (ordonnés)                                                |
|------------------|----------------------|-----------------------------------------|-----------------------------------------------------------------------------|
| s_header         | —                    | En-tête avec contrôle de volume        | Container-1, IconButton-2, Slider-3, Icon-4, IconButton-5                  |
| s_quick_start    | Démarrage rapide     | Configuration rapide des intervalles    | Card-6, Container-7, Text-8, IconButton-9, Text-10...Text-20, Button-22, Button-23 |
| s_presets_header | VOS PRÉRÉGLAGES      | Barre de titre des préréglages          | Container-24, Text-25, IconButton-26, Button-27                             |
| s_preset_card    | gainage              | Carte de préréglage exemple             | Card-28, Container-29, Text-30, Text-31, Text-32, Text-33, Text-34          |

## 2.3 Libellés & textes
| usage              | valeur (verbatim + transform) |
|--------------------|-------------------------------|
| Titre section      | Démarrage rapide              |
| Titre section      | VOS PRÉRÉGLAGES               |
| Labels             | RÉPÉTITIONS, TRAVAIL, REPOS   |
| Valeurs            | 16, 00 : 44, 00 : 15          |
| Boutons            | SAUVEGARDER, COMMENCER, + AJOUTER |
| Nom préréglage     | gainage                       |
| Durée préréglage   | 14:22                         |
| Détails préréglage | RÉPÉTITIONS 20x, TRAVAIL 00:40, REPOS 00:03 |

## 2.4 Listes & tableaux (si applicable)
| listeId       | colonnes (ordre)                           | tri par défaut | filtres | vide (empty state)           |
|---------------|--------------------------------------------|----------------|---------|------------------------------|
| presets_list  | nom, durée, détails (reps, work, rest)    | date création  | —       | Aucun préréglage (+ AJOUTER) |

---

# 3. Interactions (par composant interactif)
| compId        | type       | variant → rôle      | a11y.ariaLabel                      | action (onTap/submit/…)        | état(s) impactés              | navigation |
|---------------|------------|---------------------|-------------------------------------|--------------------------------|-------------------------------|------------|
| IconButton-2  | IconButton | ghost → faible      | Régler le volume                    | toggleVolumeControls()         | showVolumeSlider              | —          |
| Slider-3      | Slider     | —                   | Curseur de volume                   | onVolumeChanged(value)         | volume                        | —          |
| IconButton-5  | IconButton | ghost → faible      | Plus d'options                      | showOptionsMenu()              | —                             | Menu       |
| IconButton-9  | IconButton | ghost → faible      | Replier la section Démarrage rapide | toggleQuickStartSection()      | quickStartExpanded            | —          |
| IconButton-11 | IconButton | ghost → faible      | Diminuer les répétitions            | decrementReps()                | reps                          | —          |
| IconButton-13 | IconButton | ghost → faible      | Augmenter les répétitions           | incrementReps()                | reps                          | —          |
| IconButton-15 | IconButton | ghost → faible      | Diminuer le temps de travail        | decrementWorkTime()            | workSeconds                   | —          |
| IconButton-17 | IconButton | ghost → faible      | Augmenter le temps de travail       | incrementWorkTime()            | workSeconds                   | —          |
| IconButton-19 | IconButton | ghost → faible      | Diminuer le temps de repos          | decrementRestTime()            | restSeconds                   | —          |
| IconButton-21 | IconButton | ghost → faible      | Augmenter le temps de repos         | incrementRestTime()            | restSeconds                   | —          |
| Button-22     | Button     | ghost → faible      | Sauvegarder le préréglage rapide    | saveCurrentConfig()            | presets                       | —          |
| Button-23     | Button     | cta → primaire      | Démarrer l'intervalle               | startTimer()                   | —                             | Timer      |
| IconButton-26 | IconButton | ghost → faible      | Éditer les préréglages              | enterEditMode()                | presetsEditMode               | —          |
| Button-27     | Button     | secondary → support | Ajouter un préréglage               | createNewPreset()              | —                             | Editor     |
| Card-28       | Card       | —                   | —                                   | loadPreset(presetId)           | reps, workSeconds, restSeconds| —          |

- **Gestes & clavier** : Tap sur les IconButton pour incrémenter/décrémenter, tap sur Card pour charger un préréglage
- **Feedback** : 
  - Désactivation du bouton COMMENCER si reps=0 ou workSeconds=0
  - SnackBar "Préréglage sauvegardé" après saveCurrentConfig()
  - Animation de repli/dépli pour la section Démarrage rapide
- **Règles de placement ayant un impact** : 
  - Button-22 (SAUVEGARDER) aligné à droite (placement=end, widthMode=intrinsic)
  - Button-23 (COMMENCER) pleine largeur (widthMode=fill)
  - Button-27 (+ AJOUTER) aligné à droite (placement=end, widthMode=intrinsic)

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle                        | message d'erreur (verbatim)                    |
|--------------|------------------------------|------------------------------------------------|
| reps         | min=1, max=999               | Les répétitions doivent être entre 1 et 999    |
| workSeconds  | min=1, max=3600 (1h)         | Le temps de travail doit être entre 1s et 1h   |
| restSeconds  | min=0, max=3600 (1h)         | Le temps de repos doit être entre 0s et 1h     |

## 4.2 Calculs & conditions d'affichage
| règle                  | condition                         | impact UI                           | notes |
|------------------------|-----------------------------------|-------------------------------------|-------|
| Durée totale           | reps × (workSeconds + restSeconds)| Affichée sur Card-28 (ex: 14:22)    | Format MM:SS |
| Bouton COMMENCER actif | reps ≥ 1 AND workSeconds ≥ 1      | Enabled/Disabled                    | —     |
| Section repliée        | quickStartExpanded = false        | Card-6 masquée, IconButton-9 devient expand_more | —     |

## 4.3 États vides & erreurs
| contexte            | rendu                                                      | action de sortie |
|---------------------|------------------------------------------------------------|------------------|
| Aucun préréglage    | Texte "Aucun préréglage. Créez-en un avec + AJOUTER"     | Tap Button-27    |
| Volume à 0          | IconButton-2 affiche volume_off au lieu de volume_up      | —                |
| Erreur sauvegarde   | SnackBar "Erreur lors de la sauvegarde"                   | Retry            |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques                    |
|--------------------|--------------|------------|------------------------------|
| Lancement app      | —            | —          | Écran principal (home)       |
| Retour             | Timer        | —          | Après fin ou annulation      |
| Retour             | Editor       | savedPreset| Après création de préréglage |

## 5.2 Cibles (sorties de l'écran)
| déclencheur      | écran cible | paramètres                              | remarques                      |
|------------------|--------------|-----------------------------------------|--------------------------------|
| Button-23 (COMMENCER) | Timer   | reps, workSeconds, restSeconds          | Démarre la session d'intervalle|
| Button-27 (+ AJOUTER) | Editor  | mode=create                             | Création nouveau préréglage    |
| Card-28 (tap)         | Timer   | reps, workSeconds, restSeconds (preset) | Charge et démarre préréglage   |
| IconButton-5          | Menu    | —                                       | Options générales              |

## 5.3 Événements système
- **Back physique** : Ferme l'application (demande confirmation si configuration non sauvegardée)
- **Timer / notifications** : —
- **Permissions** : Audio (pour les annonces vocales)

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé                  | type    | défaut | persistance | notes                                      |
|----------------------|---------|--------|-------------|--------------------------------------------|
| reps                 | int     | 16     | SharedPrefs | Nombre de répétitions                      |
| workSeconds          | int     | 44     | SharedPrefs | Temps de travail en secondes               |
| restSeconds          | int     | 15     | SharedPrefs | Temps de repos en secondes                 |
| volume               | double  | 0.62   | SharedPrefs | Volume normalisé [0.0-1.0]                 |
| quickStartExpanded   | bool    | true   | SharedPrefs | État de dépli de la section Démarrage rapide|
| showVolumeSlider     | bool    | true   | non         | Affichage du slider de volume              |
| presetsEditMode      | bool    | false  | non         | Mode édition des préréglages               |
| presets              | List<Preset> | [] | SharedPrefs | Liste des préréglages sauvegardés         |

## 6.2 Actions / effets
| nom                  | entrée              | sortie | erreurs       | description                                          |
|----------------------|---------------------|--------|---------------|------------------------------------------------------|
| incrementReps        | —                   | —      | max reached   | Incrémente reps de 1 (max 999)                       |
| decrementReps        | —                   | —      | min reached   | Décrémente reps de 1 (min 1)                         |
| incrementWorkTime    | —                   | —      | max reached   | Incrémente workSeconds de 1 (max 3600)               |
| decrementWorkTime    | —                   | —      | min reached   | Décrémente workSeconds de 1 (min 1)                  |
| incrementRestTime    | —                   | —      | max reached   | Incrémente restSeconds de 1 (max 3600)               |
| decrementRestTime    | —                   | —      | min reached   | Décrémente restSeconds de 1 (min 0)                  |
| onVolumeChanged      | double value        | —      | —             | Met à jour le volume et persiste dans SharedPrefs    |
| saveCurrentConfig    | —                   | Preset | storage error | Crée un nouveau préréglage avec la config actuelle   |
| startTimer           | —                   | —      | validation    | Valide les paramètres et navigue vers Timer          |
| loadPreset           | String presetId     | —      | not found     | Charge un préréglage et met à jour reps/work/rest    |
| toggleQuickStartSection | —                | —      | —             | Inverse quickStartExpanded                           |
| createNewPreset      | —                   | —      | —             | Navigue vers Editor en mode création                 |
| enterEditMode        | —                   | —      | —             | Active presetsEditMode pour éditer/supprimer         |

---

# 7. Accessibilité
| compId        | ariaLabel (design)                      | rôle sémantique | focus order | raccourcis | notes                           |
|---------------|-----------------------------------------|-----------------|-------------|------------|---------------------------------|
| IconButton-2  | Régler le volume                        | button          | 1           | —          | —                               |
| Slider-3      | Curseur de volume                       | slider          | 2           | ←/→        | Ajustable au clavier            |
| IconButton-5  | Plus d'options                          | button          | 3           | —          | —                               |
| IconButton-9  | Replier la section Démarrage rapide     | button          | 4           | —          | État expand/collapse annoncé    |
| IconButton-11 | Diminuer les répétitions                | button          | 5           | —          | Annonce la nouvelle valeur      |
| Text-12       | —                                       | text            | —           | —          | Valeur lue après changement     |
| IconButton-13 | Augmenter les répétitions               | button          | 6           | —          | Annonce la nouvelle valeur      |
| IconButton-15 | Diminuer le temps de travail            | button          | 7           | —          | Annonce la nouvelle valeur      |
| Text-16       | —                                       | text            | —           | —          | Valeur lue après changement     |
| IconButton-17 | Augmenter le temps de travail           | button          | 8           | —          | Annonce la nouvelle valeur      |
| IconButton-19 | Diminuer le temps de repos              | button          | 9           | —          | Annonce la nouvelle valeur      |
| Text-20       | —                                       | text            | —           | —          | Valeur lue après changement     |
| IconButton-21 | Augmenter le temps de repos             | button          | 10          | —          | Annonce la nouvelle valeur      |
| Button-22     | Sauvegarder le préréglage rapide        | button          | 11          | —          | —                               |
| Button-23     | Démarrer l'intervalle                   | button          | 12          | Enter      | Focus principal, CTA            |
| IconButton-26 | Éditer les préréglages                  | button          | 13          | —          | —                               |
| Button-27     | Ajouter un préréglage                   | button          | 14          | —          | —                               |
| Card-28       | —                                       | button          | 15          | —          | Carte cliquable, rôle button    |

---

# 8. Thème & tokens requis
- **Couleurs sémantiques utilisées** : 
  - `primary` (#607D8B) : Boutons, icônes interactives
  - `cta` (#607D8B) : Bouton COMMENCER
  - `accent` (#FFC107) : Icône éclair du bouton COMMENCER
  - `background` (#F2F2F2) : Fond de l'écran
  - `surface` (#FFFFFF) : Cartes, slider
  - `textPrimary` (#212121) : Textes principaux
  - `textSecondary` (#616161) : Labels, textes secondaires
  - `divider` (#E0E0E0) : Bordures de cartes
  - `border` (#DDDDDD) : Bordures des boutons
  - `headerBackgroundDark` (#455A64) : En-tête avec volume
  - `presetCardBg` (#FAFAFA) : Fond des cartes de préréglages
  - `sliderActive` (#FFFFFF) : Piste active du slider
  - `sliderInactive` (#90A4AE) : Piste inactive du slider
  - `sliderThumb` (#FFFFFF) : Pouce du slider

- **Typographies référencées (`typographyRef`)** :
  - `titleLarge` : Titre "Démarrage rapide" (fontSize 20, bold)
  - `title` : "VOS PRÉRÉGLAGES", nom des préréglages (fontSize 16-20, bold)
  - `label` : Labels en majuscules, textes de boutons (fontSize 12-14, medium)
  - `body` : Détails des préréglages (fontSize 14, regular)
  - `value` : Valeurs numériques et temporelles (fontSize 16-24, bold/medium)

- **Exigences de contraste (WCAG AA)** : Oui
  - Ratio minimal 4.5:1 pour les textes normaux
  - Ratio minimal 3:1 pour les textes larges (≥18pt)
  - Vérifié sur tous les couples texte/fond

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran est affiché avec reps=16, workSeconds=44, restSeconds=15  
   **When** l'utilisateur appuie sur **IconButton-13** (augmenter répétitions)  
   **Then** Text-12 affiche "17"

2. **Given** l'écran est affiché avec la configuration actuelle  
   **When** l'utilisateur appuie sur **COMMENCER**  
   **Then** navigation vers l'écran Timer avec les paramètres reps=16, workSeconds=44, restSeconds=15

3. **Given** l'écran est affiché avec reps=16, workSeconds=44, restSeconds=15  
   **When** l'utilisateur appuie sur **SAUVEGARDER**  
   **Then** un dialogue s'ouvre pour nommer le préréglage, puis le préréglage est ajouté à la liste

4. **Given** l'écran affiche la carte préréglage "gainage"  
   **When** l'utilisateur appuie sur Card-28  
   **Then** les valeurs reps=20, workSeconds=40, restSeconds=3 sont chargées et affichées

5. **Given** l'écran est affiché avec le Slider-3 à 0.62  
   **When** l'utilisateur déplace le slider vers 0.8  
   **Then** le volume est mis à jour et persisté dans SharedPrefs

## 9.2 Alternatives / Exceptions
1. **Given** reps=1  
   **When** l'utilisateur appuie sur **IconButton-11** (diminuer répétitions)  
   **Then** aucune action (valeur minimale atteinte)

2. **Given** reps=999  
   **When** l'utilisateur appuie sur **IconButton-13** (augmenter répétitions)  
   **Then** aucune action (valeur maximale atteinte)

3. **Given** aucun préréglage n'existe  
   **When** l'écran s'affiche  
   **Then** un état vide "Aucun préréglage" est affiché avec un CTA "+ AJOUTER"

4. **Given** l'utilisateur modifie la configuration  
   **When** l'utilisateur appuie sur le bouton Back  
   **Then** un dialogue de confirmation "Sauvegarder les modifications ?" s'affiche

---

# 10. Traçabilité vers des tests
| id  | type (widget/golden/unit) | préconditions          | étapes                                    | oracle attendu                                                  |
|-----|---------------------------|------------------------|-------------------------------------------|-----------------------------------------------------------------|
| T1  | widget                    | reps=16                | tap IconButton-13                         | Text-12 affiche "17"                                            |
| T2  | widget                    | reps=16                | tap IconButton-11                         | Text-12 affiche "15"                                            |
| T3  | widget                    | reps=1                 | tap IconButton-11                         | Text-12 reste à "1" (min atteint)                               |
| T4  | widget                    | workSeconds=44         | tap IconButton-17                         | Text-16 affiche "00 : 45"                                       |
| T5  | widget                    | workSeconds=44         | tap IconButton-15                         | Text-16 affiche "00 : 43"                                       |
| T6  | widget                    | restSeconds=15         | tap IconButton-21                         | Text-20 affiche "00 : 16"                                       |
| T7  | widget                    | restSeconds=15         | tap IconButton-19                         | Text-20 affiche "00 : 14"                                       |
| T8  | widget                    | restSeconds=0          | tap IconButton-19                         | Text-20 reste à "00 : 00" (min atteint)                         |
| T9  | widget                    | volume=0.5             | drag Slider-3 to 0.8                      | volume state = 0.8                                              |
| T10 | widget                    | config valide          | tap Button-23 (COMMENCER)                 | navigation vers Timer avec params corrects                      |
| T11 | widget                    | —                      | tap Button-22 (SAUVEGARDER)               | dialogue de nom de préréglage s'affiche                         |
| T12 | widget                    | preset "gainage" existe| tap Card-28                               | reps=20, workSeconds=40, restSeconds=3 chargés                  |
| T13 | widget                    | quickStartExpanded=true| tap IconButton-9                          | Card-6 se replie, iconName devient expand_more                  |
| T14 | golden                    | état initial           | —                                         | snapshot correspond à home_design.json                          |
| T15 | unit                      | reps=16, work=44, rest=15| calculateTotalDuration()                | retourne 944 secondes (15:44)                                   |
| T16 | unit                      | reps=20, work=40, rest=3 | calculateTotalDuration()                | retourne 860 secondes (14:20)                                   |
| T17 | widget                    | —                      | tap Button-27 (+ AJOUTER)                 | navigation vers PresetEditor en mode création                   |
| T18 | widget                    | —                      | tap IconButton-26 (éditer)                | presetsEditMode=true, checkboxes d'édition s'affichent         |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé                                                                       | confiance |
|---|------------------------------------------------------------------------------|-----------|
| 1 | Couleurs estimées à partir du rendu (Material Design gris/bleu)              | 0.75      |
| 2 | Nom d'icône 'expand_less' supposé pour le bouton de repli                   | 0.70      |
| 3 | Positions/bbox approchées par inspection visuelle (sans mesure pixel-perfect)| 0.70      |
| 4 | Valeur du slider normalisée à ~0.62 d'après la position du pouce            | 0.70      |
| 5 | Boutons 'SAUVEGARDER' et '+ AJOUTER' modélisés en ghost/secondary           | 0.80      |
| 6 | Icon-4 est un décor de thumb à ignorer lors de la génération Flutter        | 0.85      |

## 11.2 Hors périmètre
- Écran Timer (exécution du minuteur d'intervalles)
- Écran PresetEditor (création/édition détaillée de préréglages)
- Menu d'options (accessible via IconButton-5)
- Gestion des permissions audio
- Synchronisation cloud des préréglages
- Historique des sessions
- Statistiques et graphiques

## 11.3 Incertitudes / questions ouvertes
- Aucune

---

# 12. Contraintes
- **Authentification** : Non requis pour cette version
- **Sécurité** : Données stockées localement (SharedPreferences), pas de transmission réseau
- **Performance** : 
  - Chargement de l'écran < 300ms
  - Réactivité des contrôles < 100ms
  - Persistence des préférences < 50ms
- **Accessibilité** : 
  - Support TalkBack/VoiceOver complet
  - Contraste WCAG AA minimum
  - Taille des zones tactiles ≥ 48dp
  - Navigation clavier complète
- **Compatibilité** : 
  - Flutter SDK ≥ 3.0
  - Android ≥ 5.0 (API 21)
  - iOS ≥ 12.0

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en px, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Tous les textes UI sont en français, tous les identifiants techniques en anglais.
- Les timestamps sont en format MM:SS pour durées < 1h, HH:MM:SS pour durées ≥ 1h.

