# Spécification fonctionnelle - Écran Interval Timer

**Écran** : Démarrage rapide & Préréglages  
**ID technique** : `quick_start_timer`  
**Version** : 1.0

---

## 1. Identification
- **Nom de l'écran** : Démarrage rapide & Préréglages  
- **Code technique** : `quick_start_timer`  
- **Module** : Configuration et lancement d'intervalles d'entraînement  

---

## 2. Description et type
- **Objectif** : Permettre à l'utilisateur de configurer rapidement une séance d'entraînement par intervalles ou de sélectionner des préréglages sauvegardés
- **Type d'écran** : Écran de saisie + consultation de liste  
- **Utilisateurs cibles** : Sportifs, particuliers, coaches  

---

## 3. Structure et sections

### 3.1 Header avec contrôles globaux
- Slider de volume avec icônes (volume_up + slider + circle)
- Menu contextuel (more_vert)

### 3.2 Section Démarrage rapide (Card principale)
- **Titre** : "Démarrage rapide"
- **Champs configurables** :
  - Répétitions : valeur numérique avec boutons +/-
  - Travail : durée au format mm:ss avec boutons +/-  
  - Repos : durée au format mm:ss avec boutons +/-
- **Actions** : Bouton "SAUVEGARDER" (ghost), Bouton "COMMENCER" (primary avec icône bolt)

### 3.3 Section Préréglages  
- **Header** : "VOS PRÉRÉGLAGES" avec bouton d'ajout (+)
- **Liste** : Cards de préréglages sauvegardés

---

## 4. Actions utilisateur

### Actions principales
| Action | Élément | Comportement attendu |
|--------|---------|---------------------|
| Régler volume | Slider header | Ajuste le volume sonore des notifications |
| Diminuer répétitions | IconButton minus | Décrémente la valeur (minimum 1) |
| Augmenter répétitions | IconButton plus | Incrémente la valeur |
| Diminuer travail | IconButton minus | Décrémente par pas de 1 seconde (minimum 00:01) |
| Augmenter travail | IconButton plus | Incrémente par pas de 1 seconde |
| Diminuer repos | IconButton minus | Décrémente par pas de 1 seconde (minimum 00:01) |
| Augmenter repos | IconButton plus | Incrémente par pas de 1 seconde |
| Sauvegarder | Button SAUVEGARDER | Sauvegarde la configuration actuelle comme préréglage |
| Commencer | Button COMMENCER | Lance le timer avec la configuration actuelle |
| Ajouter préréglage | IconButton plus | Ouvre l'interface de création de préréglage |
| Menu | IconButton more_vert | Ouvre le menu des paramètres |

---

## 5. Règles de validation

### Champs obligatoires
- Répétitions : ≥ 1 (valeur entière)
- Travail : ≥ 00:01 (format mm:ss strict)
- Repos : ≥ 00:01 (format mm:ss strict)

### Règles métier
- Durée totale calculée = (Travail + Repos) × Répétitions
- Format de temps strict : mm:ss (00:00 à 99:59)
- Répétitions maximum suggéré : 999

### Messages d'erreur
- "Les répétitions doivent être supérieures à 0"
- "Le temps de travail doit être d'au moins 1 seconde"
- "Le temps de repos doit être d'au moins 1 seconde"
- "Format de temps invalide (utilisez mm:ss)"

---

## 6. Navigation

### Écrans sources
- Accueil de l'application
- Menu principal

### Écrans cibles  
- Écran timer actif (après "COMMENCER")
- Écran d'édition de préréglage
- Écran paramètres généraux (via menu)

### Transitions
- "COMMENCER" → Transition vers écran timer avec animation
- Retour système natif (Android/iOS back button)

---

## 7. Scénarios d'usage

### Scénario nominal : Configuration rapide
1. Utilisateur ouvre l'écran
2. Ajuste répétitions (ex: 16 → 20)  
3. Modifie temps de travail (ex: 00:44 → 01:00)
4. Ajuste temps de repos (ex: 00:15 → 00:20)
5. Appuie sur "COMMENCER"
6. Timer se lance avec configuration choisie

### Scénario alternatif : Sauvegarde
1. Utilisateur configure les paramètres
2. Appuie sur "SAUVEGARDER" 
3. Saisit un nom pour le préréglage
4. Confirme la sauvegarde
5. Le préréglage apparaît dans la liste

### Scénario alternatif : Utilisation d'un préréglage
1. Utilisateur consulte la liste "VOS PRÉRÉGLAGES"
2. Sélectionne un préréglage (ex: "gainage")  
3. Les valeurs se chargent automatiquement
4. Appuie sur "COMMENCER"
5. Timer se lance avec le préréglage

### Scénarios d'exception
- **Valeur invalide** : Message d'erreur + focus sur le champ
- **Aucun préréglage** : Message informatif "Créez votre premier préréglage"
- **Erreur de sauvegarde** : "Impossible de sauvegarder, réessayez"

---

## 8. Contraintes d'accessibilité

### Labels obligatoires
- Tous les IconButtons ont des labels sémantiques :
  - "volume" (contrôle volume)
  - "diminuer répétitions", "augmenter répétitions"  
  - "diminuer travail", "augmenter travail"
  - "diminuer repos", "augmenter repos"
  - "sauvegarder", "commencer"
  - "ajouter préréglage", "menu"

### Support écran lecteur
- Annonce du contenu des valeurs lors des modifications
- Navigation au clavier/gestuelle supportée
- Contraste suffisant (ratio 4.5:1 minimum)

---

## 9. Contraintes de performance

- **Lancement instantané** : < 1 seconde
- **Réactivité des contrôles** : feedback immédiat (< 100ms)
- **Sauvegarde** : < 500ms
- **Chargement des préréglages** : < 300ms

---

## 10. Assumptions et questions ouvertes

### Assumptions
- Interface en français (texts fournis)
- Orientation portrait privilégiée
- Pas d'authentification requise
- Stockage local des préréglages

### Questions ouvertes pour développement
- Stratégie de persistance des préréglages (SQLite, SharedPreferences ?)
- Gestion des sons/vibrations selon les préférences système
- Comportement en arrière-plan lors du timer actif
- Partage de préréglages entre appareils (future feature ?)
