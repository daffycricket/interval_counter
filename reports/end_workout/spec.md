---
screenName: end_workout
screenId: end_workout
designSnapshotRef: c6581509-e5b9-4306-9f04-0faf619e3f6c
specVersion: 2
generatedAt: 2026-03-04T00:00:00Z
generator: snapshot2app-specgen
language: fr
---

# 1. Vue d'ensemble
- **Nom de l'écran** : Fin de workout
- **Code technique / ID** : `end_workout`
- **Type d'écran** : Other (écran terminal)
- **Orientation supportée** : Portrait
- **Objectifs et fonctions principales** :
  - Afficher "FINI" à l'issue du workout
  - Permettre à l'utilisateur d'arrêter et de retourner à la home
  - Permettre à l'utilisateur de relancer exactement le même workout depuis zéro

> Texte utilisateur : "FINI" — copie verbatim de `components.Text.text`, transform `uppercase` appliqué.

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId        | type        | variant   | key (stable)                    | texte (après transform) |
|-----|---------------|-------------|-----------|----------------------------------|-------------------------|
| 1   | container-1   | Container   | —         | end_workout__container-1        | —                       |
| 2   | text-2        | Text        | —         | end_workout__text-2             | "FINI"                  |
| 3   | container-3   | Container   | —         | end_workout__container-3        | —                       |
| 4   | iconbutton-4  | IconButton  | secondary | end_workout__iconbutton-4       | —                       |
| 5   | icon-5        | Icon        | —         | —                               | —                       |
| 6   | iconbutton-6  | IconButton  | secondary | end_workout__iconbutton-6       | —                       |
| 7   | icon-7        | Icon        | —         | —                               | —                       |

## 2.2 Sections / blocs
| sectionId  | intitulé    | description courte        | composants inclus       |
|------------|-------------|---------------------------|-------------------------|
| s_title    | "FINI"      | Titre plein écran centré  | text-2                  |
| s_actions  | —           | Boutons Arrêter/Reprendre | container-3, iconbutton-4, iconbutton-6 |

## 2.3 Libellés & textes
| usage        | valeur (verbatim + transform) |
|--------------|-------------------------------|
| Titre        | "FINI" (uppercase)            |
| A11y Stop    | "Stop timer"                  |
| A11y Restart | "Restart timer"               |

## 2.4 Listes & tableaux
| listeId | colonnes | tri | filtres | vide |
|---------|----------|-----|---------|------|
| —       | —        | —   | —       | —    |

---

# 3. Interactions (par composant interactif)
| compId       | type       | variant → rôle         | a11y.ariaLabel  | action             | état(s) impactés | navigation                         |
|--------------|------------|------------------------|-----------------|--------------------|------------------|------------------------------------|
| iconbutton-4 | IconButton | secondary → arrêter    | "Stop timer"    | `onStop()`         | —                | Pop → Home                         |
| iconbutton-6 | IconButton | secondary → reprendre  | "Restart timer" | `onRestart()`      | —                | pushReplacement → WorkoutScreen    |

- **Gestes** : tap uniquement
- **Feedback** : navigation immédiate
- **Placement** : row centré, gap lg (24px)

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur |
|--------------|-------|------------------|
| —            | —     | —                |

## 4.2 Calculs & conditions d'affichage
| règle           | condition | impact UI                | notes |
|----------------|-----------|--------------------------|-------|
| Écran terminal | isComplete | Remplace WorkoutScreen   | pushReplacementNamed |

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|
| —        | —     | —                |

---

# 5. Navigation
## 5.1 Origines
| action utilisateur           | écran source   | paramètres | remarques |
|------------------------------|----------------|------------|-----------|
| Workout terminé (isComplete) | WorkoutScreen  | Preset     | pushReplacementNamed('/end_workout') |

## 5.2 Cibles
| déclencheur              | écran cible    | paramètres | remarques |
|--------------------------|----------------|------------|-----------|
| Tap bouton "Arrêter"     | HomeScreen     | —          | pop() |
| Tap bouton "Reprendre"   | WorkoutScreen  | Preset     | pushReplacementNamed('/workout', arguments: preset) |

## 5.3 Événements système
- Back physique → équivalent à "Arrêter" (pop → Home)

---

# 6. Modèle d'état & API internes
## 6.1 État local
| clé | type | défaut | persistance | notes |
|-----|------|--------|-------------|-------|
| —   | —    | —      | —           | Aucun état local — écran stateless |

## 6.2 Actions / effets
| nom        | entrée | sortie | erreurs | description |
|------------|--------|--------|---------|-------------|
| onStop     | —      | —      | —       | Navigator.pop() — retour home |
| onRestart  | Preset | —      | —       | pushReplacementNamed('/workout', preset) |

---

# 7. Accessibilité
| compId       | ariaLabel       | rôle sémantique | focus order | raccourcis | notes |
|--------------|-----------------|-----------------|-------------|------------|-------|
| iconbutton-4 | "Stop timer"    | button          | 1           | —          | Tooltip visible |
| iconbutton-6 | "Restart timer" | button          | 2           | —          | Tooltip visible |

---

# 8. Thème & tokens requis
- Couleurs : `background` (#0F7C82), `surface` (#6F7F86), `onPrimary` (#E6E6E6), `textPrimary` (#1A1A1A)
- Typographies : `titleLarge` (text-2)
- Exigences de contraste (WCAG AA) : non testé (degraded mode)

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal — Arrêter
1. **Given** l'écran end_workout est affiché (workout terminé)
   **When** l'utilisateur tape le bouton Stop (iconbutton-4)
   **Then** l'écran se ferme et l'utilisateur revient sur la Home.

## 9.2 Nominal — Reprendre
1. **Given** l'écran end_workout est affiché (workout terminé)
   **When** l'utilisateur tape le bouton Restart (iconbutton-6)
   **Then** l'écran se ferme et un nouveau workout démarre depuis zéro avec le même preset.

---

# 10. Traçabilité vers des tests
| id | type    | préconditions | étapes                    | oracle attendu |
|----|---------|---------------|---------------------------|----------------|
| T1 | screen  | écran affiché | trouver key text-2        | find.byKey('end_workout__text-2') findsOneWidget |
| T2 | screen  | écran affiché | trouver key iconbutton-4  | find.byKey('end_workout__iconbutton-4') findsOneWidget |
| T3 | screen  | écran affiché | trouver key iconbutton-6  | find.byKey('end_workout__iconbutton-6') findsOneWidget |
| T4 | e2e     | workout complet → end_workout affiché | tap stop | retour home |
| T5 | e2e     | workout complet → end_workout affiché | tap restart | nouveau workout démarre |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses
| # | énoncé | confiance |
|---|--------|-----------|
| 1 | Couleur fond teal approximée depuis screenshot | 0.75 |
| 2 | Couleur gris boutons approximée | 0.75 |
| 3 | Icônes material.stop et material.refresh | 0.80 |

## 11.2 Hors périmètre
- Statistiques de workout (durée totale, calories, etc.) — non présentes dans le design

## 11.3 Incertitudes
- —

---

# 12. Contraintes
- Authentification : —
- Sécurité : —
- Performance : StatelessWidget, rendu immédiat
- Accessibilité : tooltips sur boutons
- Compatibilité : portrait uniquement

---

# 13. Déterminisme & conventions
- Vocabulaires contrôlés respectés
- Clés stables : `end_workout__{compId}`
- Textes verbatim depuis design.json
