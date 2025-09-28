# Spécification fonctionnelle - Écran Interval Timer

## 1. Identification
- **Nom de l'écran** : IntervalTimerHome
- **ID technique** : `interval_timer_home_screen`
- **Module** : Configuration et lancement d'entraînements par intervalles

## 2. Description générale
**Objectif** : Permettre aux utilisateurs de configurer rapidement des séances d'entraînement par intervalles (HIIT/Tabata) via des contrôles directs ou des préréglages sauvegardés.

**Type d'écran** : Écran de configuration avec saisie de paramètres et gestion de préréglages.

**Utilisateurs cibles** : Sportifs, particuliers, coachs souhaitant créer des entraînements par intervalles.

## 3. Structure et contenu

### 3.1 Sections principales

#### Barre supérieure (Container-1)
- **Contrôle de volume** : Slider avec icône haut-parleur
- **Menu contextuel** : Icône 3 points pour accès aux paramètres

#### Section Démarrage rapide (Card-6)
- **Configuration manuelle** des paramètres d'entraînement
- **Contrôles de valeur** : boutons +/- pour ajustement précis
- **Actions** : Sauvegarder et Commencer

#### Section Vos préréglages (Card-28)
- **Liste des configurations** sauvegardées
- **Actions de gestion** : Ajouter, Éditer
- **Aperçu des paramètres** par préréglage

### 3.2 Champs et contrôles

| Champ | Type | Format | Valeur par défaut | Validation |
|-------|------|--------|-------------------|------------|
| Volume | Slider | 0.0-1.0 | 0.62 | - |
| Répétitions | Numérique | Entier | 16 | ≥ 1 |
| Temps de travail | Durée | mm:ss | 00:44 | ≥ 00:01 |
| Temps de repos | Durée | mm:ss | 00:15 | ≥ 00:01 |

### 3.3 Textes et libellés
- **Titres de section** : "Démarrage rapide", "VOS PRÉRÉGLAGES"
- **Labels de champs** : "RÉPÉTITIONS", "TRAVAIL", "REPOS" (en majuscules)
- **Actions principales** : "COMMENCER" (CTA), "SAUVEGARDER", "+ AJOUTER"
- **Exemple de préréglage** : "gainage" avec durée totale "14:22"

## 4. Actions utilisateur

### Actions principales
- **IconButton volume** (IconButton-2) : Accès rapide aux réglages audio
- **Slider volume** (Slider-3) : Ajustement du niveau sonore (0-100%)
- **Menu contextuel** (IconButton-5) : Accès aux paramètres généraux

### Contrôles de valeurs
- **Boutons -/+** (IconButton-11,13,15,17,19,21) : Incrémentation/décrémentation des valeurs
- **Affichage des valeurs** (Text-12,16,20) : Visualisation en temps réel

### Actions de workflow
- **SAUVEGARDER** (Button-22, variant: ghost) : Enregistre la configuration actuelle comme préréglage
- **COMMENCER** (Button-23, variant: cta) : Lance l'entraînement avec les paramètres actuels
- **+ AJOUTER** (Button-27, variant: secondary) : Crée un nouveau préréglage
- **Éditer** (IconButton-26) : Modifie les préréglages existants

## 5. Règles fonctionnelles

### Validation des données
- **Répétitions** : Valeur entière ≥ 1
- **Durées** : Format mm:ss, valeur ≥ 00:01
- **Volume** : Valeur normalisée entre 0.0 et 1.0

### Calculs automatiques
- **Durée totale** = (Temps de travail + Temps de repos) × Répétitions
- **Affichage** : Format hh:mm pour les durées totales

### Règles d'affichage
- **Section préréglages** : Affichage conditionnel (masquée si vide)
- **Boutons d'action** : État actif/inactif selon la validation des champs

## 6. Navigation et enchaînements

### Écrans sources
- Écran d'accueil de l'application
- Menu principal

### Écrans cibles
- **Écran de timer actif** (via COMMENCER)
- **Écran d'édition de préréglage** (via bouton Éditer)
- **Écran de paramètres** (via menu contextuel)

### Modalités de navigation
- Navigation native Android/iOS (bouton retour)
- Actions contextuelles dans l'écran

## 7. Scénarios d'usage

### Cas nominal - Configuration rapide
1. L'utilisateur ouvre l'écran
2. Ajuste les paramètres (répétitions, travail, repos) via les contrôles +/-
3. Clique sur "COMMENCER"
4. L'entraînement se lance avec les paramètres configurés

### Cas alternatif - Utilisation de préréglage
1. L'utilisateur sélectionne un préréglage existant
2. Les paramètres se chargent automatiquement
3. Possibilité d'ajustement avant lancement
4. Clique sur "COMMENCER"

### Cas alternatif - Sauvegarde de configuration
1. L'utilisateur configure ses paramètres
2. Clique sur "SAUVEGARDER"
3. Saisit un nom pour le préréglage
4. Le préréglage apparaît dans la liste

### Cas d'erreur - Validation
- **Valeur invalide** : Message d'erreur contextuel, champ mis en évidence
- **Durée zéro** : Blocage de l'action COMMENCER, indication visuelle

## 8. Accessibilité

### Labels ARIA implémentés
- Tous les contrôles interactifs ont des `ariaLabel` descriptifs
- Navigation au clavier supportée
- Contraste respectant les standards WCAG

### Support des technologies d'assistance
- Lecteurs d'écran : descriptions vocales des actions
- Navigation tactile : zones de toucher optimisées (min 44px)

## 9. Performance et contraintes

### Réactivité
- **Lancement instantané** : < 1s pour démarrer un entraînement
- **Mise à jour en temps réel** : Affichage immédiat des changements de valeurs

### Compatibilité
- **Orientation** : Portrait privilégiée, responsive
- **Plateformes** : Android/iOS natif via Flutter
- **Tailles d'écran** : Optimisé pour smartphones (558x1136 de référence)

## 10. Hypothèses et questions ouvertes

### Hypothèses techniques
- **Persistance** : Les préréglages sont sauvegardés localement
- **Audio** : Le contrôle de volume affecte les signaux sonores de l'entraînement
- **Navigation** : Retour possible vers cet écran depuis le timer actif

### Questions ouvertes
- **Limite de préréglages** : Nombre maximum de préréglages autorisés ?
- **Partage** : Fonctionnalité de partage de préréglages entre utilisateurs ?
- **Synchronisation** : Sauvegarde cloud des préréglages ?

## 11. Tokens de design

### Couleurs sémantiques utilisées
- **primary** (#607D8B) : Actions principales, contrôles
- **cta** (#607D8B) : Bouton COMMENCER
- **accent** (#FFC107) : Éléments de mise en évidence
- **surface** (#FFFFFF) : Arrière-plans des cartes
- **textPrimary** (#212121) : Textes principaux
- **textSecondary** (#616161) : Labels et textes secondaires

### Typographie
- **titleLarge** : Titres de section (20px, bold)
- **label** : Labels de champs (12px, medium, uppercase)
- **value** : Valeurs numériques (24px, bold)
- **body** : Textes descriptifs (14px, regular)
