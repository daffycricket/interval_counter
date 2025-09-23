# Spécification fonctionnelle détaillée  
**Écran : Interval Timer – Démarrage rapide & Préréglages**  

---

## 1. Identification
- **Nom de l’écran** : Démarrage rapide & Préréglages  
- **Code technique / ID** : `screen_quick_start_presets` (proposition)  
- **Module / fonctionnalité associée** : Configuration et lancement d’intervalles d’entraînement (HIIT/Tabata/Interval training)  

---

## 2. Description générale
- **Objectif de l’écran** :  
  Permettre à l’utilisateur de configurer rapidement une séance d’entraînement par intervalles (répétitions, temps de travail, temps de repos) et/ou de sélectionner des préréglages sauvegardés pour lancer directement un entraînement.  

- **Type d’écran** :  
  Écran de **saisie + consultation de liste**.  

- **Profils / rôles utilisateurs concernés** :  
  - Utilisateur final (sportif, particulier, coach).  
  - Aucun rôle différencié identifié (pas de notion d’administrateur).  

---

## 3. Structure & contenu
### 3.1 Sections / blocs
1. **Bloc supérieur – Commandes globales**  
   - Volume sonore (icône haut-parleur).  
   - Menu contextuel (icône 3 points).  

2. **Bloc principal – Démarrage rapide**  
   - Paramétrage manuel des répétitions, temps de travail et temps de repos.  
   - Boutons de sauvegarde et lancement.  

3. **Bloc secondaire – Vos préréglages**  
   - Liste des configurations sauvegardées par l’utilisateur.  
   - Actions : ajouter, modifier, partager, lancer.  

---

### 3.2 Champs
| Nom du champ       | Type        | Format / unité | Valeur par défaut | Obligatoire | Remarques |
|--------------------|-------------|----------------|-------------------|-------------|-----------|
| Répétitions        | Numérique   | Entier ≥ 1     | 16 (exemple)      | Oui         | Incrémentation via boutons `-` / `+` |
| Travail            | Durée       | mm:ss          | 00:44             | Oui         | Incrémentation via boutons `-` / `+` |
| Repos              | Durée       | mm:ss          | 00:15             | Oui         | Incrémentation via boutons `-` / `+` |
| Nom du préréglage  | Texte       | Chaîne (50)    | Vide              | Optionnel   | Renseigné si l’utilisateur sauvegarde |

---

### 3.3 Libellés & textes
- `Démarrage rapide` (titre de section)  
- `Répétitions` / `Travail` / `Repos` (libellés champs)  
- Boutons : `Sauvegarder`, `Commencer`, `+ Ajouter`  
- Section : `Vos préréglages`  
- Carte préréglage : nom, heure d’enregistrement, répétitions, travail, repos  

---

### 3.4 Tableaux / listes
- **Liste des préréglages** :  
  - Colonnes implicites (affichage sous forme de cartes) :  
    - Nom du préréglage (texte)  
    - Heure d’enregistrement (hh:mm)  
    - Répétitions (ex. `20x`)  
    - Travail (durée)  
    - Repos (durée)  
  - Règles : tri par **ordre chronologique inverse** (dernier en premier).  
  - Pas de filtres visibles, possibilité de recherche non identifiée.  

---

## 4. Actions utilisateur
- **Icône volume** : régler ou couper le son.  
- **Icône menu (3 points)** : accéder aux paramètres généraux (non visible dans le snapshot).  
- **Bouton `Sauvegarder`** : enregistre la configuration courante comme préréglage.  
- **Bouton `Commencer`** : lance immédiatement le timer avec les valeurs saisies ou sélectionnées.  
- **Bouton `+ Ajouter`** : crée un nouveau préréglage.  
- **Icône crayon (modifier)** : renommer ou éditer la liste des préréglages.  
- **Icône partage** : partager un préréglage via les canaux disponibles (OS).  
- **Icône lecture (`Commencer`)** : lance le préréglage sélectionné.  

---

## 5. Règles fonctionnelles & métier
- **Champs obligatoires** : répétitions, travail, repos.  
- **Validation** :  
  - Répétitions ≥ 1.  
  - Travail et repos ≥ 00:01.  
  - Formats stricts `mm:ss`.  
- **Règles de calcul** :  
  - Durée totale = (Travail + Repos) × Répétitions.  
  - Affichée lors du lancement (non visible dans la maquette, à prévoir).  
- **Conditions d’affichage** :  
  - Bloc préréglages affiché vide si aucun préréglage n’a encore été créé.  
  - Icône partage uniquement disponible si le préréglage existe.  

---

## 6. Navigation & enchaînements
- **Écrans sources possibles** :  
  - Accueil de l’application.  
  - Menu principal.  

- **Écrans cibles** :  
  - Écran de lancement de l’entraînement (timer actif).  
  - Écran d’édition de préréglage (via le crayon).  
  - Écran de paramètres généraux (via les 3 points).  

- **Modalités** :  
  - Retour OS natif (Android/iOS).  
  - Navigation par bouton "back".  

---

## 7. Scénarios d’usage
### Cas nominal
1. L’utilisateur ouvre l’application.  
2. Il choisit de configurer une séance rapide en renseignant répétitions, travail, repos.  
3. Il clique sur `Commencer`.  
4. Le timer se lance.  

### Cas alternatifs
- Sauvegarde de la configuration comme préréglage.  
- Sélection d’un préréglage existant pour lancer immédiatement une séance.  

### Cas exceptionnels
- **Valeur invalide** (ex. travail 00:00) → message d’erreur.  
- **Liste de préréglages vide** → affichage d’un message type :  
  _“Vous n’avez pas encore créé de préréglage. Utilisez + Ajouter pour en créer un.”_  

---

## 8. Contraintes particulières
- **Sécurité** : aucune restriction identifiée (pas de login nécessaire).  
- **Performance** : lancement instantané attendu (moins de 1s).  
- **Accessibilité** :  
  - Contraste suffisant.  
  - Icônes avec libellés textuels accessibles.  
  - Support lecture vocale (screen reader).  
- **Compatibilité** :  
  - Responsive sur smartphones (Android/iOS).  
  - Orientation portrait privilégiée.  

---

## 9. Commentaires & annexes
- **Maquette associée** : `7f91a1fb-b86c-492d-8608-df6fa80ced54.png` (snapshot fourni).  
- **Notes** :  
  - Les écrans semblent provenir d’une application mobile type interval timer.  
  - Prévoir validation UX sur l’ergonomie des boutons et la taille des contrôles.  

---
