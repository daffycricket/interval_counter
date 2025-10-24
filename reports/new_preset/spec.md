---
# Deterministic Functional Spec — PresetEditor

# YAML front matter for machine-readability
screenName: PresetEditor
screenId: preset_editor
designSnapshotRef: e1cb6394-36df-45ff-8766-c9d4db68dd37.png
specVersion: 2
generatedAt: 2025-10-23T00:00:00Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : PresetEditor
- **Code technique / ID** : `preset_editor`
- **Type d'écran** : Form
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Créer ou modifier un préréglage d'intervalle d'entraînement
  - Configurer les paramètres : préparation, répétitions, travail, repos, refroidissement
  - Basculer entre vue SIMPLE et vue ADVANCED
  - Sauvegarder le préréglage et retourner à l'écran Home
  - Annuler les modifications et retourner à l'écran Home

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId | type        | variant   | key (stable)              | texte (après transform) |
|-----|--------|-------------|-----------|---------------------------|-------------------------|
| 1   | container-1 | Container | — | preset_editor__container-1 | — |
| 2   | iconbutton-2 | IconButton | ghost | preset_editor__iconbutton-2 | — |
| 3   | button-3 | Button | primary | preset_editor__button-3 | SIMPLE |
| 4   | button-4 | Button | ghost | preset_editor__button-4 | ADVANCED |
| 5   | iconbutton-5 | IconButton | ghost | preset_editor__iconbutton-5 | — |
| 6   | input-6 | Input | — | preset_editor__input-6 | Nom prédéfini |
| 7   | container-7 | Container | — | preset_editor__container-7 | — |
| 8   | text-8 | Text | — | preset_editor__text-8 | PRÉPARER |
| 9   | iconbutton-9 | IconButton | ghost | preset_editor__iconbutton-9 | — |
| 10  | text-10 | Text | — | preset_editor__text-10 | 00 : 05 |
| 11  | iconbutton-11 | IconButton | ghost | preset_editor__iconbutton-11 | — |
| 12  | text-12 | Text | — | preset_editor__text-12 | RÉPÉTITIONS |
| 13  | iconbutton-13 | IconButton | ghost | preset_editor__iconbutton-13 | — |
| 14  | text-14 | Text | — | preset_editor__text-14 | 1 |
| 15  | iconbutton-15 | IconButton | ghost | preset_editor__iconbutton-15 | — |
| 16  | text-16 | Text | — | preset_editor__text-16 | TRAVAIL |
| 17  | iconbutton-17 | IconButton | ghost | preset_editor__iconbutton-17 | — |
| 18  | text-18 | Text | — | preset_editor__text-18 | 01 : 29 |
| 19  | iconbutton-19 | IconButton | ghost | preset_editor__iconbutton-19 | — |
| 20  | text-20 | Text | — | preset_editor__text-20 | REPOS |
| 21  | iconbutton-21 | IconButton | ghost | preset_editor__iconbutton-21 | — |
| 22  | text-22 | Text | — | preset_editor__text-22 | 00 : 30 |
| 23  | iconbutton-23 | IconButton | ghost | preset_editor__iconbutton-23 | — |
| 24  | text-24 | Text | — | preset_editor__text-24 | REFROIDIR |
| 25  | iconbutton-25 | IconButton | ghost | preset_editor__iconbutton-25 | — |
| 26  | text-26 | Text | — | preset_editor__text-26 | 00 : 00 |
| 27  | iconbutton-27 | IconButton | ghost | preset_editor__iconbutton-27 | — |
| 28  | text-28 | Text | — | preset_editor__text-28 | TOTAL 01:34 |

> Règle de clé: `{screenId}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|--------------------|-------------------------------|
| s_header  | — | Barre d'outils et navigation | container-1, iconbutton-2, button-3, button-4, iconbutton-5 |
| s_name    | Nom prédéfini | Champ de saisie du nom | input-6 |
| s_params  | — | Configuration des paramètres d'intervalle | container-7, text-8 à text-27 |
| s_total   | — | Affichage du temps total | text-28 |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Bouton mode simple | SIMPLE |
| Bouton mode avancé | ADVANCED |
| Champ nom | Nom prédéfini |
| Labels paramètres | PRÉPARER, RÉPÉTITIONS, TRAVAIL, REPOS, REFROIDIR |
| Valeurs paramètres | 00 : 05, 1, 01 : 29, 00 : 30, 00 : 00 |
| Total | TOTAL 01:34 |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|
| — | — | — | — | — |

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| iconbutton-2 | IconButton | ghost → faible | Fermer | `close()` | — | Home (sans sauvegarder) |
| button-3 | Button | primary → primaire | Mode simple | `switchToSimple()` | viewMode | — |
| button-4 | Button | ghost → faible | Mode avancé | `switchToAdvanced()` | viewMode | — |
| iconbutton-5 | IconButton | ghost → faible | Enregistrer | `save()` | preset | Home (avec sauvegarde) |
| input-6 | Input | — | Nom prédéfini | `onNameChange(text)` | name | — |
| iconbutton-9 | IconButton | ghost → faible | Diminuer préparer | `decrementPrepare()` | prepareSeconds | — |
| iconbutton-11 | IconButton | ghost → faible | Augmenter préparer | `incrementPrepare()` | prepareSeconds | — |
| iconbutton-13 | IconButton | ghost → faible | Diminuer répétitions | `decrementReps()` | repetitions | — |
| iconbutton-15 | IconButton | ghost → faible | Augmenter répétitions | `incrementReps()` | repetitions | — |
| iconbutton-17 | IconButton | ghost → faible | Diminuer travail | `decrementWork()` | workSeconds | — |
| iconbutton-19 | IconButton | ghost → faible | Augmenter travail | `incrementWork()` | workSeconds | — |
| iconbutton-21 | IconButton | ghost → faible | Diminuer repos | `decrementRest()` | restSeconds | — |
| iconbutton-23 | IconButton | ghost → faible | Augmenter repos | `incrementRest()` | restSeconds | — |
| iconbutton-25 | IconButton | ghost → faible | Diminuer refroidir | `decrementCooldown()` | cooldownSeconds | — |
| iconbutton-27 | IconButton | ghost → faible | Augmenter refroidir | `incrementCooldown()` | cooldownSeconds | — |

- **Gestes & clavier** : 
  - Enter sur input-6 : focus sur le champ suivant (aucun pour ce formulaire)
  - Back physique : ferme l'écran sans sauvegarder (équivalent iconbutton-2)
- **Feedback** : 
  - Calcul automatique du TOTAL lors de la modification de tout paramètre
  - Mise à jour immédiate des valeurs affichées lors des incréments/décréments
- **Règles de placement ayant un impact** : 
  - button-3, button-4 : positionnés au centre du header
  - iconbutton-2 : aligné à gauche du header
  - iconbutton-5 : aligné à droite du header
  - Tous les contrôles de paramètres : centrés dans container-7

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|
| name | non vide lors de la sauvegarde | Veuillez saisir un nom |
| repetitions | ≥ 1 | — |
| workSeconds | ≥ 0 | — |
| prepareSeconds | ≥ 0 | — |
| restSeconds | ≥ 0 | — |
| cooldownSeconds | ≥ 0 | — |

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|------|-----------|-----------|-------|
| Total calculé | toujours | Affichage "TOTAL mm:ss" | Somme: prepare + (reps × (work + rest)) + cooldown |
| Format temps | toujours | Format "00 : 05" avec espaces | Conforme au format Home |
| Incrément contrôles temps | tous les +/− de temps | 1 seconde | Conforme au comportement Home |
| Incrément contrôles répétitions | +/− répétitions | 1 répétition | — |
| Bouton SIMPLE actif | viewMode == simple | variant=primary, background=#FFFFFF | — |
| Bouton ADVANCED actif | viewMode == advanced | variant=primary, background=#FFFFFF | — |
| Vue SIMPLE visible | viewMode == simple | Affichage container-7 | — |
| Vue ADVANCED visible | viewMode == advanced | Affichage écran vide (hors périmètre) | — |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| Nom vide lors de sauvegarde | Bloquer sauvegarde, afficher message | Saisir nom |
| Valeur répétitions < 1 | Bloquer décrémentation à 1 | — |
| Valeurs temps < 0 | Bloquer décrémentation à 0 | — |

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|
| Tap sur Button-27 (+ AJOUTER) | Home | mode=create | Valeurs par défaut (spec complément §Valeurs par défaut) |
| Tap sur Button-22 (SAUVEGARDER) | Home | mode=create, valeurs Quick Start | Valeurs du Quick Start |
| Tap sur PresetCard | Home | mode=edit, preset | Valeurs du préréglage existant |

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|
| iconbutton-2 (Fermer) | Home | — | Sans sauvegarder les modifications |
| iconbutton-5 (Enregistrer) | Home | preset | Sauvegarde le préréglage (création ou modification) |
| Back physique | Home | — | Sans sauvegarder les modifications |

## 5.3 Événements système
- Back physique : ferme l'écran sans sauvegarder (équivalent iconbutton-2)
- Timer : —
- Permissions : —

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| name | String | "" | via sauvegarde | Nom du préréglage |
| prepareSeconds | int | 5 | via sauvegarde | Temps de préparation (mode création) |
| repetitions | int | 10 | via sauvegarde | Nombre de répétitions (mode création) |
| workSeconds | int | 40 | via sauvegarde | Temps de travail (mode création) |
| restSeconds | int | 20 | via sauvegarde | Temps de repos (mode création) |
| cooldownSeconds | int | 30 | via sauvegarde | Temps de refroidissement (mode création) |
| viewMode | enum | simple | non | simple|advanced |
| editMode | bool | false | non | false = création, true = modification |
| presetId | String? | null | non | ID du préréglage en cours d'édition (null si création) |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| incrementPrepare | — | — | — | Augmente prepareSeconds de 1 |
| decrementPrepare | — | — | — | Diminue prepareSeconds de 1 (min 0) |
| incrementReps | — | — | — | Augmente repetitions de 1 |
| decrementReps | — | — | — | Diminue repetitions de 1 (min 1) |
| incrementWork | — | — | — | Augmente workSeconds de 1 |
| decrementWork | — | — | — | Diminue workSeconds de 1 (min 0) |
| incrementRest | — | — | — | Augmente restSeconds de 1 |
| decrementRest | — | — | — | Diminue restSeconds de 1 (min 0) |
| incrementCooldown | — | — | — | Augmente cooldownSeconds de 1 |
| decrementCooldown | — | — | — | Diminue cooldownSeconds de 1 (min 0) |
| onNameChange | String text | — | — | Met à jour name |
| switchToSimple | — | — | — | Met viewMode à simple |
| switchToAdvanced | — | — | — | Met viewMode à advanced |
| save | — | — | nom vide | Sauvegarde le préréglage et retourne à Home |
| close | — | — | — | Ferme l'écran sans sauvegarder |
| calculateTotal | — | String | — | Calcule et formate le temps total : prepare + (reps × (work + rest)) + cooldown |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|
| iconbutton-2 | Fermer | button | 1 | — | — |
| button-3 | Mode simple | button | 2 | — | — |
| button-4 | Mode avancé | button | 3 | — | — |
| iconbutton-5 | Enregistrer | button | 4 | — | — |
| input-6 | Nom prédéfini | textField | 5 | — | — |
| iconbutton-9 | Diminuer préparer | button | 6 | — | — |
| text-10 | — | text | — | — | Valeur préparer |
| iconbutton-11 | Augmenter préparer | button | 7 | — | — |
| iconbutton-13 | Diminuer répétitions | button | 8 | — | — |
| text-14 | — | text | — | — | Valeur répétitions |
| iconbutton-15 | Augmenter répétitions | button | 9 | — | — |
| iconbutton-17 | Diminuer travail | button | 10 | — | — |
| text-18 | — | text | — | — | Valeur travail |
| iconbutton-19 | Augmenter travail | button | 11 | — | — |
| iconbutton-21 | Diminuer repos | button | 12 | — | — |
| text-22 | — | text | — | — | Valeur repos |
| iconbutton-23 | Augmenter repos | button | 13 | — | — |
| iconbutton-25 | Diminuer refroidir | button | 14 | — | — |
| text-26 | — | text | — | — | Valeur refroidir |
| iconbutton-27 | Augmenter refroidir | button | 15 | — | — |
| text-28 | — | text | — | — | Total |

---

# 8. Thème & tokens requis
- Couleurs sémantiques utilisées : `primary`, `onPrimary`, `background`, `surface`, `textPrimary`, `textSecondary`, `divider`, `accent`, `border`, `headerBackground`
- Typographies référencées (`typographyRef`) : label, body, value
- Exigences de contraste (WCAG AA) : oui

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran PresetEditor est affiché en mode création avec valeurs par défaut  
   **When** l'utilisateur appuie sur iconbutton-11 (+ préparer)  
   **Then** text-10 affiche "00 : 06" et text-28 affiche "TOTAL 01:35".

2. **Given** l'écran PresetEditor avec prepareSeconds=5, repetitions=10, workSeconds=40, restSeconds=20, cooldownSeconds=30  
   **When** l'utilisateur saisit "Séance HIIT" dans input-6 et appuie sur iconbutton-5 (Enregistrer)  
   **Then** le préréglage "Séance HIIT" est sauvegardé, l'écran se ferme, navigation vers Home, le préréglage apparaît dans la liste.

3. **Given** l'écran PresetEditor en mode simple  
   **When** l'utilisateur appuie sur button-4 (ADVANCED)  
   **Then** viewMode devient "advanced", button-4 devient variant=primary, button-3 devient variant=ghost, l'écran affiche la vue ADVANCED (vide pour l'instant).

4. **Given** l'écran PresetEditor en mode advanced  
   **When** l'utilisateur appuie sur button-3 (SIMPLE)  
   **Then** viewMode devient "simple", button-3 devient variant=primary, button-4 devient variant=ghost, l'écran affiche la vue SIMPLE avec container-7.

5. **Given** l'écran PresetEditor avec des modifications non sauvegardées  
   **When** l'utilisateur appuie sur iconbutton-2 (Fermer) ou Back physique  
   **Then** l'écran se ferme sans sauvegarder, navigation vers Home, la liste des préréglages n'a pas changé.

6. **Given** l'écran PresetEditor ouvert depuis Home en mode modification d'un préréglage existant  
   **When** l'utilisateur modifie repetitions de 10 à 15 et appuie sur iconbutton-5 (Enregistrer)  
   **Then** le préréglage est mis à jour avec repetitions=15, l'écran se ferme, navigation vers Home, le préréglage mis à jour apparaît dans la liste.

## 9.2 Alternatives / Exceptions
- **Nom vide lors de sauvegarde** : Bloquer la sauvegarde, afficher message "Veuillez saisir un nom"  
- **Valeur minimale répétitions** : Diminuer en dessous de 1 → bloqué à 1  
- **Valeur minimale temps** : Diminuer en dessous de 0 → bloqué à 0  
- **Calcul du total** : Recalculé automatiquement à chaque modification de paramètre

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | widget | prepareSeconds=5 | tap iconbutton-11 | find.byKey('preset_editor__text-10') text = "00 : 06" |
| T2 | widget | prepareSeconds=0 | tap iconbutton-9 | find.byKey('preset_editor__text-10') text = "00 : 00", iconbutton-9 disabled |
| T3 | widget | repetitions=1 | tap iconbutton-13 | find.byKey('preset_editor__text-14') text = "1", iconbutton-13 disabled |
| T4 | widget | repetitions=10 | tap iconbutton-15 | find.byKey('preset_editor__text-14') text = "11" |
| T5 | widget | workSeconds=40 | tap iconbutton-19 | find.byKey('preset_editor__text-18') text = "00 : 41" |
| T6 | widget | restSeconds=20 | tap iconbutton-23 | find.byKey('preset_editor__text-22') text = "00 : 21" |
| T7 | widget | cooldownSeconds=30 | tap iconbutton-27 | find.byKey('preset_editor__text-26') text = "00 : 31" |
| T8 | widget | viewMode=simple | tap button-4 | viewMode=advanced, button-4 variant=primary |
| T9 | widget | viewMode=advanced | tap button-3 | viewMode=simple, button-3 variant=primary |
| T10 | widget | name="", all params set | tap iconbutton-5 | error message "Veuillez saisir un nom" |
| T11 | widget | name="Test", all params set | tap iconbutton-5 | preset saved, navigates to Home |
| T12 | widget | modifications not saved | tap iconbutton-2 | navigates to Home without saving |
| T13 | unit | prepare=5, reps=10, work=40, rest=20, cooldown=30 | calculateTotal() | returns "TOTAL 11:35" (5 + 10×(40+20) + 30 = 635s = 10:35) |
| T14 | a11y | — | — | all interactive components have Semantics with label |
| T15 | golden | default state simple mode | — | matches golden file |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Les couleurs du design.json sont fidèles au rendu final | 0.80 |
| 2 | Les valeurs par défaut en mode création sont celles spécifiées dans spec complément | 0.85 |
| 3 | Le format de temps avec espaces ("00 : 05") est cohérent avec Home | 0.90 |
| 4 | La vue ADVANCED sera implémentée ultérieurement avec un design dédié | 0.95 |
| 5 | Le modèle Preset devra être étendu pour inclure prepareSeconds et cooldownSeconds | 0.95 |

## 11.2 Hors périmètre
- Vue ADVANCED (sera traitée dans une itération future)
- Écran Home (destination de navigation)
- Validation avancée (ex: durée totale maximale)
- Prévisualisation de l'intervalle
- Gestion des conflits de noms de préréglages

## 11.3 Incertitudes / questions ouvertes
- Confirmation de sortie sans sauvegarde : nécessaire ou pas ? (actuellement non)
- Limite maximale des valeurs (répétitions, temps) ?
- Comportement si le préréglage en cours d'édition a été supprimé par ailleurs ?

---

# 12. Contraintes
- **Authentification** : —
- **Sécurité** : —
- **Performance** : Réactivité immédiate des contrôles (+/−), calcul du total en temps réel
- **Accessibilité** : Tous les éléments interactifs doivent avoir des labels sémantiques (WCAG AA)
- **Compatibilité** : iOS et Android

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en secondes, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
- Textes verbatim avec `style.transform` appliqué (SIMPLE, ADVANCED, PRÉPARER, RÉPÉTITIONS, TRAVAIL, REPOS, REFROIDIR, TOTAL).

