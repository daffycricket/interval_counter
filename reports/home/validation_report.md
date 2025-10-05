# Validation Report — IntervalTimerHome

## Summary
- **coverageRatio**: 1.0 ✅
- **confidenceGlobal**: 0.78 ⚠️ (seuil recommandé: 0.85)
- **issues**: Mode dégradé - Confiance globale sous le seuil
- **assumptions**: 5 hypothèses avec confiances 0.70-0.80

## Statut Global
⚠️ **PASS (avec avertissement)** — Le design respecte les critères du contrat DESIGN_CONTRACT.md, mais la confiance globale (0.78) est sous le seuil recommandé de 0.85. La génération peut procéder en mode dégradé.

---

## Vérification par critère

### ✅ 1. Coverage
- **Critère**: `qa.coverageRatio == 1.0`
- **Résultat**: 1.0
- **Statut**: ✅ PASS

### ✅ 2. Measurements
- **Critère**: tous les composants ont des `bbox` et `sourceRect` entiers
- **Résultat**: Tous les 34 composants ont des mesures entières valides
- **Statut**: ✅ PASS

### ✅ 3. A11y
- **Critère**: composants interactifs ont `a11y.ariaLabel`
- **Résultat**: 
  - 10 IconButton → tous avec ariaLabel ✅
  - 3 Button → tous avec ariaLabel ✅
  - 1 Slider → avec ariaLabel ✅
- **Statut**: ✅ PASS

### ✅ 4. Colors
- **Critère**: toutes les couleurs existent dans `tokens.colors`
- **Résultat**: 10 couleurs utilisées, toutes mappées à des tokens
  - `#455A64` → `headerBackgroundDark`
  - `#FFFFFF` → `surface`
  - `#F2F2F2` → `background`
  - `#212121` → `textPrimary`
  - `#616161` → `textSecondary`
  - `#E0E0E0` → `divider`
  - `#DDDDDD` → `border`
  - `#607D8B` → `primary`
  - `#FFC107` → `accent`
  - `#90A4AE` → `sliderInactive`
- **Statut**: ✅ PASS

### ✅ 5. Semantics
- **Critère**: présence des attributs sémantiques quand visuellement applicable
- **Résultat**:
  - **Variants**: Tous les Button/IconButton ont des variants appropriés (cta, ghost, secondary) ✅
  - **Placement + widthMode**: Présents sur tous les boutons non-fullwidth ✅
  - **Group attributes**: Tous les Container/Card ont alignment, distribution, maxWidth ✅
  - **TypographyRef**: Présent sur tous les Text ✅
  - **Transform**: Présent sur les labels uppercase ✅
  - **LeadingIcon**: Présent sur les boutons avec icônes (Button-22, Button-23, Button-27) ✅
- **Statut**: ✅ PASS

### ⚠️ 6. Confidence
- **Critère**: `qa.confidenceGlobal >= 0.85`
- **Résultat**: 0.78
- **Statut**: ⚠️ WARNING — Sous le seuil, mode dégradé

---

## Findings

### Decorations (Slider Thumbs)
#### finding.decorations.orphanThumb
- **sliderId**: `Slider-3`
- **nodeId**: `Icon-4`
- **reason**: thumb-like sibling (report-only)
- **description**: L'icône `Icon-4` (material.circle, #FFFFFF, 16x16) est positionnée à [312, 26] dans le même groupe que le Slider-3 [52, 26, 420, 28]. Son centre (320, 34) est à ~3px du bord droit du slider (472). Ce pattern correspond à un thumb visuel redondant.
- **action**: Report-only (pas de modification requise)

### Assumptions (depuis design.json)
| # | Énoncé | Confiance |
|---|--------|-----------|
| 1 | Couleurs estimées à partir du rendu (matériel design gris/bleu) | 0.75 |
| 2 | Nom d'icône d'en-tête 'expand_less' supposé (chevron de repli) | 0.70 |
| 3 | Positions/bbox approchées par inspection visuelle (sans mesure pixel-perfect) | 0.70 |
| 4 | Valeur du slider normalisée à ~0,62 d'après la position du pouce | 0.70 |
| 5 | Les boutons 'Sauvegarder' et '+ Ajouter' modélisés en 'ghost/secondary' selon le rendu non rempli | 0.80 |

**Moyenne des confiances**: 0.73

---

## JSON Patch (normalization)
Aucune modification structurelle requise. Le fichier est valide tel quel.

```json
[]
```

---

## Open Questions
- Aucune question ouverte.

---

## Text Coverage Verification
### Found (16/16) ✅
- "Démarrage rapide"
- "RÉPÉTITIONS"
- "16"
- "TRAVAIL"
- "00 : 44"
- "REPOS"
- "00 : 15"
- "SAUVEGARDER"
- "COMMENCER"
- "VOS PRÉRÉGLAGES"
- "+ AJOUTER"
- "gainage"
- "14:22"
- "RÉPÉTITIONS 20x"
- "TRAVAIL 00:40"
- "REPOS 00:03"

### Missing (0/16) ✅
- (aucun)

---

## Counts by Type
| Type | Count |
|------|-------|
| Text | 13 |
| IconButton | 10 |
| Container | 4 |
| Button | 3 |
| Card | 2 |
| Slider | 1 |
| Icon | 1 |
| **Total** | **34** |

---

## Flags
- `hasOrphanThumb`: true (Icon-4 détecté comme thumb orphelin du Slider-3)

---

## Recommendation
✅ **Procéder à l'étape suivante** avec les notes suivantes:
- La confiance globale de 0.78 est acceptable pour continuer en mode dégradé.
- Les 5 assumptions doivent être traitées avec prudence lors de la génération.
- Le thumb orphelin (Icon-4) peut être ignoré ou nettoyé selon les besoins.
- Tous les critères structurels du contrat sont respectés.

---

**Validateur**: Design Validator Agent  
**Date**: 2025-10-05T00:00:00Z  
**Version du schema**: 1.0