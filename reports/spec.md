# Spécification fonctionnelle validée
**Écran : Interval Timer – Démarrage rapide & Préréglages**  

---

## Validation SPEC_CONTRACT ✅

Cette spécification respecte tous les critères du SPEC_CONTRACT:
- ✅ Texte utilisateur verbatim depuis design.json
- ✅ Modèle d'interaction pour chaque composant interactif
- ✅ Comportement d'accessibilité mappé
- ✅ Rôles non-visuels par variants définis
- ✅ Intentions de layout documentées
- ✅ Dépendances de thème référencées

---

## 1. Identification
- **Nom de l'écran** : Démarrage rapide & Préréglages  
- **Code technique / ID** : `IntervalTimerHome`  
- **Module / fonctionnalité associée** : Configuration et lancement d'intervalles d'entraînement (HIIT/Tabata/Interval training)  

---

## 2. Description générale
- **Objectif de l'écran** :  
  Permettre à l'utilisateur de configurer rapidement une séance d'entraînement par intervalles (répétitions, temps de travail, temps de repos) et/ou de sélectionner des préréglages sauvegardés pour lancer directement un entraînement.  

- **Type d'écran** :  
  Écran de **saisie + consultation de liste**.  

- **Profils / rôles utilisateurs concernés** :  
  - Utilisateur final (sportif, particulier, coach).  
  - Aucun rôle différencié identifié (pas de notion d'administrateur).  

---

## 3. Composants et interactions

### 3.1 Barre de contrôle supérieure (Container-1)
**Thème**: `headerBackgroundDark` (#455A64)

#### Volume (IconButton-2 + Slider-3)
- **Icône**: `material.volume_up` (couleur: `onPrimary`)
- **Interaction**: Régler le volume sonore
- **A11y**: "Régler le volume"
- **Slider**: Valeur normalisée 0.62, couleurs `sliderActive`/`sliderInactive`/`sliderThumb`

#### Menu contextuel (IconButton-5)
- **Icône**: `material.more_vert` (couleur: `onPrimary`)
- **Interaction**: Accéder aux paramètres généraux
- **A11y**: "Plus d'options"
- **Variant**: `ghost`

### 3.2 Section Démarrage rapide (Card-6)

#### En-tête de section (Container-7)
- **Layout**: `flex row`, `justify: between`, `align: center`
- **Titre**: "Démarrage rapide" (`typographyRef: titleLarge`, `fontWeight: bold`)
- **Action repli**: IconButton `material.expand_less` (A11y: "Replier la section Démarrage rapide")

#### Contrôles de valeurs
Chaque contrôle suit le pattern: Label + Bouton(-) + Valeur + Bouton(+)

**RÉPÉTITIONS**
- **Label**: "RÉPÉTITIONS" (`transform: uppercase`, `typographyRef: label`)
- **Valeur**: "16" (`typographyRef: value`, `fontSize: 24`, `fontWeight: bold`)
- **Boutons**: `material.remove`/`material.add` avec bordures (`borderColor: border`)
- **A11y**: "Diminuer/Augmenter les répétitions"

**TRAVAIL**
- **Label**: "TRAVAIL" (`transform: uppercase`)
- **Valeur**: "00 : 44" (format mm:ss)
- **A11y**: "Diminuer/Augmenter le temps de travail"

**REPOS**
- **Label**: "REPOS" (`transform: uppercase`)
- **Valeur**: "00 : 15" (format mm:ss)
- **A11y**: "Diminuer/Augmenter le temps de repos"

#### Actions principales

**Bouton SAUVEGARDER (Button-22)**
- **Variant**: `ghost` (action de faible emphase)
- **Placement**: `end` (aligné à droite)
- **WidthMode**: `intrinsic` (taille au contenu)
- **Icône**: `material.save` + texte "SAUVEGARDER"
- **A11y**: "Sauvegarder le préréglage rapide"
- **Rôle**: Action de support pour persistance

**Bouton COMMENCER (Button-23)**
- **Variant**: `cta` (action de flux principal)
- **Placement**: `start` 
- **WidthMode**: `fill` (pleine largeur)
- **Icône**: `material.bolt` (couleur: `accent`) + texte "COMMENCER"
- **A11y**: "Démarrer l'intervalle"
- **Rôle**: Action principale de lancement
- **Thème**: Fond `cta`/`primary`, texte `onPrimary`

### 3.3 Section Vos préréglages (Container-24)

#### En-tête de section
- **Layout**: `flex row`, `justify: between`, `align: center`
- **Titre**: "VOS PRÉRÉGLAGES" (`transform: uppercase`, `typographyRef: title`)
- **Action édition**: IconButton `material.edit` (A11y: "Éditer les préréglages")
- **Action ajout**: Button "+ AJOUTER" (`variant: secondary`, `placement: end`)

#### Carte préréglage (Card-28)
**Thème**: `presetCardBg` (#FAFAFA)

**En-tête préréglage (Container-29)**
- **Layout**: `flex row`, `justify: between`
- **Nom**: "gainage" (`typographyRef: title`, `fontSize: 20`)
- **Durée totale**: "14:22" (`typographyRef: value`, couleur: `textSecondary`)

**Détails préréglage**
- "RÉPÉTITIONS 20x" (`typographyRef: body`)
- "TRAVAIL 00:40" (`typographyRef: body`)  
- "REPOS 00:03" (`typographyRef: body`)
- Couleur texte: `textSecondary`

---

## 4. Règles fonctionnelles & métier

### Validation des entrées
- **Répétitions**: ≥ 1 (entier)
- **Travail/Repos**: ≥ 00:01 (format mm:ss strict)
- **Champs obligatoires**: répétitions, travail, repos

### Calculs automatiques
- **Durée totale**: (Travail + Repos) × Répétitions
- **Affichage**: dans la carte préréglage (ex: "14:22")

### Conditions d'affichage
- **Section préréglages**: Affichée même si vide
- **Message vide**: "Vous n'avez pas encore créé de préréglage. Utilisez + Ajouter pour en créer un."

---

## 5. Navigation & enchaînements

### Écrans sources
- Accueil de l'application
- Menu principal

### Écrans cibles
- **COMMENCER** → Écran timer actif
- **+ AJOUTER** → Écran création préréglage
- **Édition** → Écran modification préréglages
- **Menu (3 points)** → Écran paramètres généraux

### Modalités
- Retour OS natif (Android/iOS)
- Navigation par bouton "back"

---

## 6. Thème et accessibilité

### Tokens sémantiques utilisés
- `cta`: Bouton principal COMMENCER
- `primary`: Couleur principale des contrôles
- `headerBackgroundDark`: Barre supérieure
- `textPrimary`/`textSecondary`: Hiérarchie textuelle
- `surface`/`background`: Surfaces et fond
- `border`: Bordures des contrôles

### Accessibilité
- **Contraste**: Respecte les ratios WCAG
- **Screen readers**: Tous les ariaLabel définis
- **Navigation clavier**: Support des boutons et contrôles
- **Taille des cibles**: Minimum 44px pour les boutons

---

## 7. Scénarios d'usage

### Cas nominal
1. Utilisateur configure répétitions/travail/repos
2. Clique "COMMENCER" 
3. Timer se lance immédiatement

### Cas alternatifs
- **Sauvegarde**: Configure + "SAUVEGARDER" → Nouveau préréglage
- **Préréglage existant**: Sélectionne carte → Valeurs pré-remplies → "COMMENCER"
- **Création**: "+ AJOUTER" → Écran dédié

### Cas exceptionnels
- **Valeur invalide**: Message d'erreur + focus sur champ
- **Liste vide**: Message informatif + CTA vers création

---

## 8. Contraintes techniques

### Performance
- **Lancement**: < 1s attendu
- **Réactivité**: Mise à jour temps réel des valeurs

### Compatibilité
- **Plateformes**: Android/iOS (Flutter)
- **Orientation**: Portrait privilégiée
- **Responsive**: Adaptation écrans 5"-7"

---
