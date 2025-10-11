# Validation Report — IntervalTimerHome

**Date:** 2025-10-11  
**Design File:** `examples/home/home_design.json`  
**Schema:** `schema/minifigma.schema.json`  
**Contract:** `contracts/DESIGN_CONTRACT.md`

---

## Summary

| Critère | Statut | Détails |
|---------|--------|---------|
| **Coverage Ratio** | ✅ **PASS** | 1.0 (100%) |
| **Measurements** | ✅ **PASS** | Tous les composants ont bbox et sourceRect en entiers |
| **A11y Labels** | ✅ **PASS** | Tous les éléments interactifs ont ariaLabel |
| **Colors** | ✅ **PASS** | Toutes les couleurs sont mappées aux tokens |
| **Semantics** | ✅ **PASS** | Variants, placement, widthMode, groupes alignés |
| **Confidence Global** | ⚠️ **DEGRADED** | 0.78 (< 0.85) |

---

## Findings

### ✅ Pass Criteria Met

1. **Coverage Ratio = 1.0**
   - Tous les éléments visuels du snapshot sont représentés.
   - Aucun `missingAtoms` dans l'inventaire QA.

2. **Integer Measurements**
   - Tous les `bbox` et `sourceRect` sont des entiers en pixels.
   - Aucune valeur `"unknown"` ou flottante détectée.

3. **A11y Labels**
   - Vérification des éléments interactifs:
     - IconButton-2: ✅ "Régler le volume"
     - Slider-3: ✅ "Curseur de volume"
     - IconButton-5: ✅ "Plus d'options"
     - IconButton-9: ✅ "Replier la section Démarrage rapide"
     - IconButton-11: ✅ "Diminuer les répétitions"
     - IconButton-13: ✅ "Augmenter les répétitions"
     - IconButton-15: ✅ "Diminuer le temps de travail"
     - IconButton-17: ✅ "Augmenter le temps de travail"
     - IconButton-19: ✅ "Diminuer le temps de repos"
     - IconButton-21: ✅ "Augmenter le temps de repos"
     - Button-22: ✅ "Sauvegarder le préréglage rapide"
     - Button-23: ✅ "Démarrer l'intervalle"
     - IconButton-26: ✅ "Éditer les préréglages"
     - Button-27: ✅ "Ajouter un préréglage"

4. **Color Tokens**
   - Toutes les couleurs utilisées sont définies dans `tokens.colors`:
     - `#455A64` → headerBackgroundDark
     - `#FFFFFF` → surface/onPrimary/sliderActive/sliderThumb
     - `#F2F2F2` → background
     - `#212121` → textPrimary
     - `#616161` → textSecondary
     - `#E0E0E0` → divider
     - `#DDDDDD` → border
     - `#607D8B` → primary/cta
     - `#FFC107` → accent/warning
     - `#90A4AE` → sliderInactive
     - `#FAFAFA` → presetCardBg

5. **Semantic Markup**
   - ✅ Variants présents sur tous les Button/IconButton
   - ✅ `placement` et `widthMode` sur les actions non-fullwidth (Button-22, Button-27)
   - ✅ `group.alignment` et `group.distribution` sur tous les containers/cards
   - ✅ `typographyRef` présent sur tous les textes
   - ✅ `style.transform` utilisé pour les labels en majuscules
   - ✅ `leadingIcon` utilisé pour les boutons avec icônes (Button-22, Button-23, Button-27)

---

### ⚠️ Warnings

#### 1. Confidence Global Below Threshold
**Statut:** DEGRADED MODE  
**Valeur:** 0.78 (seuil recommandé: 0.85)

**Raison:** Plusieurs estimations avec confiance < 0.8
- Couleurs estimées à partir du rendu (confidence: 0.75)
- Nom d'icône 'expand_less' supposé (confidence: 0.7)
- Positions/bbox approchées par inspection visuelle (confidence: 0.7)
- Valeur du slider normalisée (confidence: 0.7)

**Impact:** La génération peut continuer mais avec un avertissement. Recommandation: vérifier manuellement les couleurs et positions.

#### 2. Orphan Thumb Detection (Slider)

**Slider-3** (Curseur de volume)
- Sibling trouvé: **Icon-4** (material.circle)
- Position: bbox [312, 26, 16, 16]
- Couleur: #FFFFFF (correspond à sliderThumb)
- Distance du bord droit du slider: ~10px
- **Raison:** thumb-like sibling (report-only)

**Action:** Aucune modification requise. Ce thumb sera ignoré lors de la génération Flutter car Flutter génère automatiquement le thumb du Slider.

**Flag:** `summary.flags.hasOrphanThumb = true`

---

### 📋 Text Coverage

**Found (16/16):**
- ✅ "Démarrage rapide"
- ✅ "RÉPÉTITIONS"
- ✅ "16"
- ✅ "TRAVAIL"
- ✅ "00 : 44"
- ✅ "REPOS"
- ✅ "00 : 15"
- ✅ "SAUVEGARDER"
- ✅ "COMMENCER"
- ✅ "VOS PRÉRÉGLAGES"
- ✅ "+ AJOUTER"
- ✅ "gainage"
- ✅ "14:22"
- ✅ "RÉPÉTITIONS 20x"
- ✅ "TRAVAIL 00:40"
- ✅ "REPOS 00:03"

**Missing:** Aucun

---

### 📊 Component Inventory

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

## Assumptions (from QA section)

1. **Couleurs estimées à partir du rendu (matériel design gris/bleu)**
   - Confidence: 0.75
   - Note: Nécessite validation avec un color picker précis

2. **Nom d'icône d'en-tête 'expand_less' supposé (chevron de repli)**
   - Confidence: 0.7
   - Note: Basé sur l'apparence visuelle

3. **Positions/bbox approchées par inspection visuelle**
   - Confidence: 0.7
   - Note: Sans mesure pixel-perfect

4. **Valeur du slider normalisée à ~0,62**
   - Confidence: 0.7
   - Note: D'après la position du pouce

5. **Les boutons 'Sauvegarder' et '+ Ajouter' modélisés en 'ghost/secondary'**
   - Confidence: 0.8
   - Note: Selon le rendu non rempli

---

## Open Questions

Aucune question ouverte.

---

## Recommendations

1. **Pour améliorer la confidence:**
   - Utiliser un color picker pour valider les couleurs exactes
   - Mesurer les bbox avec un outil de capture précis
   - Confirmer les noms d'icônes Material Design

2. **Pour le développement:**
   - Ignorer Icon-4 (thumb orphelin) lors de la génération du Slider
   - Utiliser les tokens de couleur systématiquement
   - Respecter les groupes et alignements définis

---

## Final Status

🟡 **PASS WITH WARNINGS**

Le design est valide et respecte tous les critères obligatoires du contrat, mais la confiance globale est en mode dégradé (0.78 < 0.85). La génération peut continuer avec prudence.

---

**Generated by:** Design Validator  
**Pipeline:** Step 1 / Orchestrator
