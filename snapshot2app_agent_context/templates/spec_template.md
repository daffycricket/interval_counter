---
# Deterministic Functional Spec — Template

# YAML front matter for machine-readability
screenName: XXX
screenId: XXX           # stable, kebab_case; used in codegen paths and Keys
designSnapshotRef: XXX  # design.meta.snapshotRef
specVersion: 2
generatedAt: 2025-10-04T07:56:27Z
generator: snapshot2app-specgen
language: fr

---

# 1. Vue d'ensemble
- **Nom de l'écran** : XXX
- **Code technique / ID** : `XXX`
- **Type d'écran** : (Form | List | Details | Wizard | Settings | Other)
- **Orientation supportée** : Portrait | Landscape
- **Objectifs et fonctions principales** :
  - …

> Texte utilisateur : **doit** être la copie *verbatim* des `components.Text.text`, avec `style.transform` appliqué. Toute divergence = échec (Spec→Design).

---

# 2. Inventaire & Contenu (source: design.json)
## 2.1 Inventaire des composants
| idx | compId | type        | variant | key (stable)                | texte (après transform) |
|-----|--------|-------------|---------|-----------------------------|-------------------------|
| 1   | c_001  | Button      | cta     | {screenId}__c_001         | "DÉMARRER"              |
| …   | …      | …           | …       | …                           | …                       |

> Règle de clé: `{screenName}__{compId}` (voir UI Mapping Guide §7).

## 2.2 Sections / blocs (structure visuelle)
| sectionId | intitulé (verbatim) | description courte | composants inclus (ordonnés) |
|-----------|---------------------|--------------------|-------------------------------|
| s_header  | "Minuteur"          | En-tête            | c_010, c_011                  |
| …         | …                   | …                  | …                             |

## 2.3 Libellés & textes
| usage      | valeur (verbatim + transform) |
|------------|-------------------------------|
| Titre      | XXX                           |
| Boutons    | XXX, XXX                      |
| Sections   | XXX, XXX                      |
| Cartes     | XXX                           |

## 2.4 Listes & tableaux (si applicable)
| listeId | colonnes (ordre) | tri par défaut | filtres | vide (empty state) |
|---------|-------------------|----------------|---------|--------------------|

---

# 3. Interactions (par composant interactif)
| compId | type       | variant → rôle | a11y.ariaLabel | action (onTap/submit/…)| état(s) impactés | navigation |
|--------|------------|----------------|-----------------|------------------------|------------------|------------|
| c_001  | Button     | cta → primaire | "Démarrer"      | `startTimer()`         | timer=running    | —          |
| c_002  | IconButton | ghost → faible | "Retour"        | `goBack()`             | —                | Back       |

- **Gestes & clavier** : long-press, swipe, Enter/Escape…
- **Feedback** : snackbars, loaders, désactivation, etc.
- **Règles de placement ayant un impact** : groupes centrés, actions alignées à droite (applique `placement`/`widthMode`).

---

# 4. Règles fonctionnelles & métier
## 4.1 Champs obligatoires / validations
| champ/compId | règle | message d'erreur (verbatim) |
|--------------|-------|-----------------------------|

## 4.2 Calculs & conditions d'affichage
| règle | condition | impact UI | notes |
|------|-----------|-----------|-------|

## 4.3 États vides & erreurs
| contexte | rendu | action de sortie |
|----------|-------|------------------|

---

# 5. Navigation
## 5.1 Origines (arrivées sur l'écran)
| action utilisateur | écran source | paramètres | remarques |
|--------------------|--------------|------------|-----------|

## 5.2 Cibles (sorties de l'écran)
| déclencheur | écran cible | paramètres | remarques |
|-------------|-------------|------------|-----------|

## 5.3 Événements système
- Back physique
- Timer / notifications
- Permissions

---

# 6. Modèle d'état & API internes
## 6.1 État local (store/widget)
| clé           | type     | défaut | persistance | notes |
|---------------|----------|--------|-------------|-------|
| timerState    | enum     | idle   | non         | idle|running|paused|finished |
| durationSecs  | int      | 0      | non         |       |

## 6.2 Actions / effets
| nom           | entrée | sortie | erreurs | description |
|---------------|--------|--------|---------|-------------|
| startTimer    | —      | —      | —       | Passe à running, désactive bouton Démarrer |

---

# 7. Accessibilité
| compId | ariaLabel (design) | rôle sémantique | focus order | raccourcis | notes |
|--------|--------------------|-----------------|-------------|------------|-------|

---

# 8. Thème & tokens requis
- Couleurs sémantiques utilisées : `cta`, `primary`, `warning`, …
- Typographies référencées (`typographyRef`) : titleLarge, label, body, …
- Exigences de contraste (WCAG AA) : oui/non

---

# 9. Scénarios d'usage (Given/When/Then)
## 9.1 Nominal
1. **Given** l'écran est affiché et `timerState=idle`  
   **When** l'utilisateur appuie sur **DÉMARRER**  
   **Then** `timerState=running` et le bouton devient **PAUSE**.

## 9.2 Alternatives / Exceptions
- Valeur invalide : …  
- Liste vide : …

---

# 10. Traçabilité vers des tests
| id | type (widget/golden/unit) | préconditions | étapes | oracle attendu |
|----|---------------------------|---------------|--------|----------------|
| T1 | widget                    | idle          | tap DÉMARRER | `find.byKey('XXX__c_001')` désactivé après start |

---

# 11. Hypothèses, hors périmètre & incertitudes
## 11.1 Hypothèses (avec confiance ∈ [0.6;0.9])
| # | énoncé | confiance |
|---|--------|-----------|

## 11.2 Hors périmètre
- …

## 11.3 Incertitudes / questions ouvertes
- …

---

# 12. Contraintes
- Authentification : …
- Sécurité : …
- Performance : …
- Accessibilité : …
- Compatibilité : …

---

# 13. Déterminisme & conventions
- Vocabulaire **contrôlé** (énumérations fixées ci-dessus). Aucune prose libre dans les colonnes de tables sauf *notes*.
- Formats : dates ISO‑8601, nombres entiers en px, booléens en `true|false`.
- Interdictions : pas de synonymes pour les **variants** (`cta|primary|secondary|ghost`), pas de texte « TBD ».
- Clés stables obligatoires (`{screenId}__{compId}`).
