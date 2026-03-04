
# Compléments de spécifications
## Écran "Preset Editor" – Vue ADVANCED
## Ces specs ne sont probablement pas parfaites, mais elles déterminent une bonne base d'analyse.

Ce document complète le fichier de design `preset_editor_design_advanced.json`.
Il décrit les règles fonctionnelles associées au paramétrage avancé d’un entraînement.

Cette vue permet de définir librement la structure d’un entraînement, contrairement à la vue SIMPLE qui repose sur un modèle fixe.

Les règles décrites ici ont un impact direct sur le modèle de données des entraînements et sur le comportement de l’écran Workout.

---

# 1. Objectif de la vue ADVANCED

La vue ADVANCED permet de construire un entraînement comme une séquence d’étapes paramétrables.

Chaque étape peut être définie par l’utilisateur.

Une étape possède les propriétés suivantes :

- un nom
- une durée
- une couleur
- un ordre dans la séquence
- éventuellement un nombre de répétitions

L’utilisateur peut donc définir :

- ses propres types d’étapes
- l’ordre exact d’exécution
- les couleurs associées
- la logique de répétition

Le préréglage ainsi défini est ensuite utilisé tel quel par l’écran Workout.

---

# 2. Évolution du modèle de données

## 2.1 Modèle actuel (vue SIMPLE)

Dans la vue SIMPLE, la structure de l’entraînement est figée dans le code.

Structure actuelle :

Preparation  
n x (Work + Rest)  
Cooldown

Les éléments suivants sont codés en dur :

- noms des étapes
- ordre des étapes
- couleurs des étapes
- logique de répétition

Les valeurs sont simplement configurables :

- durée de préparation
- durée de travail
- durée de repos
- durée de refroidissement
- nombre de répétitions

---

## 2.2 Modèle requis pour la vue ADVANCED

La vue ADVANCED nécessite de rendre ces éléments dynamiques.

Un entraînement doit être représenté comme une **liste ordonnée d’étapes**.

Chaque étape doit contenir :

- id
- name
- durationSeconds
- color
- order

Optionnellement :

- repeatCount

Structure conceptuelle :

```
WorkoutPreset
    id
    name
    steps[]
```

```
Step
    id
    name
    durationSeconds
    color
    order
    repeatCount (optionnel)
```

Les étapes sont exécutées dans l’ordre défini par la propriété `order`.

---

# 3. Impact sur l’écran Workout

L’écran Workout ne doit plus dépendre d’un modèle fixe.

Il doit exécuter dynamiquement la séquence définie dans le préréglage.

Le fonctionnement devient :

1. Charger la liste des étapes du preset
2. Trier les étapes selon leur ordre
3. Exécuter les étapes séquentiellement
4. Pour chaque étape :
   - afficher la couleur associée
   - afficher le nom de l’étape
   - lancer le chronomètre avec la durée définie

---

# 4. Gestion des répétitions

Certaines étapes peuvent contenir une propriété `repeatCount`.

Cela permet de répéter une sous‑séquence d’étapes.

Exemple conceptuel :

```
Warmup
Repeat 5 times:
    Work
    Rest
Cooldown
```

Dans ce cas, la séquence exécutée par l’écran Workout est générée dynamiquement.

---

# 5. Règles d’exécution

## Étapes à durée zéro

Si une étape possède une durée de `0` secondes :

- l’étape n’est pas affichée
- l’écran passe directement à l’étape suivante

---

## Couleurs

La couleur définie dans l’étape doit être utilisée :

- comme couleur de fond de l’écran Workout
- comme couleur de référence pour l’étape

---

## Nom de l’étape

Le nom défini dans le preset :

- est affiché sous le chronomètre
- remplace les libellés fixes existants

Exemples possibles :

- Échauffement
- Sprint
- Gainage
- Récupération

---

# 6. Compatibilité avec la vue SIMPLE

Les presets créés via la vue SIMPLE doivent rester compatibles.

La vue SIMPLE doit donc générer en interne une structure équivalente à celle utilisée par la vue ADVANCED.

Exemple de conversion :

Preset SIMPLE :

5 / 3x(40/20) / 10

Structure générée :

Preparation – 5s  
Repeat 3 times:
    Work – 40s  
    Rest – 20s  
Cooldown – 10s

Ainsi, l’écran Workout peut fonctionner avec un **modèle unique basé sur une liste d’étapes**.

---

# 7. Objectif architectural

La vue ADVANCED introduit un modèle d’entraînement générique.

Objectif :

- supprimer toute dépendance à un nombre fixe d’étapes
- permettre la création d’entraînements personnalisés
- rendre l’écran Workout entièrement piloté par les données du preset
