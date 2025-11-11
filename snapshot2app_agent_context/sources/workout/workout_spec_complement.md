# Complements de spécifications au design
Ce document est un complément de règles qui ne sont pas visibles dans le fichier de design workout_design.json. 
Ces éléments doivent être pris en compte dans la génération du plan de développement, dans le build et dans les phases de test. 

## Détails sur l'écran
### Ecran "Workout". 
Il s'agit de l'écran qui permet d'exécuter la session d'entrainement sélectionnée dans l'écran "Home", en enchainant les étapes (Préparation, n répétitions de Travail puis Repos, Refoidissement)

**Suite d'étapes de l'écran**
Cet écran passe dans chacune des étapes : 
 - 1. Préparation 
 - 2. n répétitions de :
    - 2.a. Travail
    - 2.b. Repos
 - 3. Refoidissement

**Fonctionnement de l'écran**
Cet écran affiche un chronomètre qui décroit d'une seconde, à chaque seconde.
Dès l'affichage de l'écran ou de l'étape, la durée s'affiche, le chrono se lance et décroit jusqu'à 00:00.
Une fois le temps de l'étape terminé, l'écran passe à l'étape d'après dans le pré-réglage.
Une fois  la session complète terminée, l'écran bascule vers l'écran de fin de session 

***A prendre en compte pour l'implémentation***
A ce stade, l'écran de fin de session n'est pas encore développé. 
Pour le moement, à la fin de la session, basculer ver l'écran Home. La bascule vers l'écran de fin de session sera réalisée lors d'une génération à venir.

## Règles de gestion sur les transitions
**Règles de gestion**
- 1. L'étape "Repos" de la dernière répétition n'est pas exécutée, l'écran passe directement dans l'étape "Refroidissement" s'il y en a une.
- 2. Si une étape est à zéro secondes dans le préréglage, l'étape n'est pas affichée, l'écran passe directement à l'étape d'après.
- 3. **Bips sonores lors des 3 dernières secondes** :
  - Les bips sonores sont joués lors des 3 dernières secondes d'une étape : à 00:02, 00:01, et 00:00.
  - **Règle de timing** : Le bip doit être joué **lorsque** le chronomètre affiche la valeur correspondante, c'est-à-dire **après** que le chronomètre ait décrémenté d'une seconde.
  - **Séquence complète** :
    - Le chronomètre affiche 00:04, puis décrémente d'une seconde → affiche 00:03 (pas de bip)
    - Le chronomètre affiche 00:03, puis décrémente d'une seconde → affiche 00:02 → **bip sonore** (bip à 00:02)
    - Le chronomètre affiche 00:02, puis décrémente d'une seconde → affiche 00:01 → **bip sonore** (bip à 00:01)
    - Le chronomètre affiche 00:01, puis décrémente d'une seconde → affiche 00:00 → **bip sonore** (bip à 00:00)
    - Le chronomètre affiche 00:00, puis décrémente d'une seconde → transition vers l'étape suivante
  - **Important** : Le bip correspond toujours à la valeur **affichée** après la décrémentation, pas à la valeur avant la décrémentation.
- 4. **Compteur de répétitions restantes** :
  - Le compteur affiche le nombre de répétitions complètes restantes (couple travail/repos).
  - **Règle de décrémentation** : Le compteur est décrémenté uniquement lors de la transition `rest → work` (début d'une nouvelle répétition).
  - **Règle d'affichage** : Pour une même répétition, les étapes `work` et `rest` affichent la même valeur de compteur.
  - **Cas spécial** : Lors de la dernière répétition, après `work`, on passe directement à `cooldown` sans `rest`. Dans ce cas, le compteur reste à 1 pendant toute la dernière étape `work`.
- 5. A la fin de la session, retour à l'écran Home

**Exemple pour le préréglage suivant : 5/3x(40/20)/10** 
  - 5 secondes de préparation
  - 3 répétitions
    - 40 secondes de travail
    - 20 secondes de repos 
  - 10 secondes de refroidissement

=> L'écran passe dans les étapes suivantes : 
1. Préparation (5 secondes) - pas de compteur
2. Répétition 1 (couple travail/repos n°1):
  2.1. Travail (40 secondes) - **compteur = 3** (3 répétitions restantes)
  2.2. Repos (20 secondes) - **compteur = 3** (même valeur que travail de la répétition 1)
  → Transition rest → work : **décrémentation** (3 → 2)
3. Répétition 2 (couple travail/repos n°2):
  3.1. Travail (40 secondes) - **compteur = 2** (2 répétitions restantes)
  3.2. Repos (20 secondes) - **compteur = 2** (même valeur que travail de la répétition 2)
  → Transition rest → work : **décrémentation** (2 → 1)
4. Répétition 3 (couple travail/repos n°3 - pas de repos car dernière répétition):
  4.1. Travail (40 secondes) - **compteur = 1** (1 répétition restante)
  → Transition work → cooldown : **pas de décrémentation** (reste à 1)
5. Refroidissement (10 secondes) - pas de compteur

**Exemple pour le préréglage suivant : 0/3x(40/20)/0** 
  - 0 secondes de préparation
  - 3 répétitions
    - 40 secondes de travail
    - 20 secondes de repos 
  - 0 secondes de refroidissement

=> L'écran passe dans les étapes suivantes : 
1. Répétition 1 (couple travail/repos n°1):
  1.1. Travail (40 secondes) - **compteur = 3** (3 répétitions restantes)
  1.2. Repos (20 secondes) - **compteur = 3** (même valeur que travail de la répétition 1)
  → Transition rest → work : **décrémentation** (3 → 2)
2. Répétition 2 (couple travail/repos n°2):
  2.1. Travail (40 secondes) - **compteur = 2** (2 répétitions restantes)
  2.2. Repos (20 secondes) - **compteur = 2** (même valeur que travail de la répétition 2)
  → Transition rest → work : **décrémentation** (2 → 1)
3. Répétition 3 (couple travail/repos n°3 - pas de repos car dernière répétition):
  3.1. Travail (40 secondes) - **compteur = 1** (1 répétition restante)
  → Transition work → cooldown : **pas de décrémentation** (reste à 1)

## Règles de gestion visuelles
**Disparation et apparition de boutons et d'éléments interactifs"**
1. Au lancement de l'écran, tous les éléments interactifs - boutons, fab, slider - sont affichés.
2. Au bout de 1500 ms, les éléments interactifs suivants disparaissent : 
  - le slider de volume, tout en haut de l'écran.
  - la ligne de contrôles : bouton précédent / bouton "Maintenir pour sortir" / bouton suivant.
  - le fab de pause en bas à droite.
3. Ils ne réapparaissent pas lorsque l'écran change d'étape.
4. Ils réapparaissent si l'utilisateur tap n'importe où sur l'écran, puis redisparaissent au bout de 1500 ms.
5. Si la session est mise en pause, les boutons restent visibles, puis disparaissent à nouveau lorsque la session est redémarrée.

**Slider de volume**
Le composant slider de volume de cet écran est le même que celui de l'écran Home :
  - Visuellement, c'est le même, mais le menu à droite avec les 3 boutons n'est pas visible.
  - Le widget existant doit être réutilisé, et adapté si nécessaire (menu droite visible ou non visible)
  - Les données stockées en SharedPreferences doivent être partagées:
    - La valeur du slider stockée sur l'écran Home, doit être récupérée sur l'écran Workout ; et inversement. 
    - Attention à bien réutiliser les mêmes clés de stockage et de récupération entre les deux écrans.

**Détails visuels généraux**
- Chaque étape a une couleur de fond distincte.
- Le chrono est affiché au centre de l'écran.
- Le nombre au-dessus du chrono indique le compteur de répétitions restantes.
- Le libellé sous le chrono indique l'étape en cours.

**Détails visuels de l'étape "Préparation"**
- Fond jaune
- Libellé "PRÉPARER" (en majuscules)
- Aucun compteur de répétition au-dessus du chrono

**Détails visuels de l'étape "Travail"**
- Fond vert / Color(0xFF4CD27E)
- Libellé "TRAVAIL" (en majuscules)
- Compteur de répétition présent au-dessus du chrono

**Détails visuels de l'étape "Repos"**
- Fond bleu
- Libellé "REPOS" (en majuscules)
- Compteur de répétition présent au-dessus du chrono

**Détails visuels de l'étape "Refroidissement"**
- Fond violet
- Libellé "REFROIDIR" (en majuscules)
- Aucun compteur de répétition au-dessus du chrono

## Interactions 
**Tap sur le fab Pause**
Un tap sur le Floating Action Button "Pause" : 
- Met en pause le chrono de l'étape et la session d'entrainement : tout est figé.
- Les boutons interactifs restent affichés.
- Le fab "Pause" est remplacé par un fab "Start"

**Tap sur le fab Start**
Un tap sur le Floating Action Button "Start" : 
- Rédémarre le chrono et la session continue
- Au bout de 1500 ms, les boutons interactifs restent affichés.
- Le fab "Start" est remplacé par le fab "Pause"

**Tap sur bouton suivant**
L'écran passe automatiquement à l'étape suivante, le chrono redémarre avec le temps de l'étape suivante.

**Tap sur bouton précédent**
L'écran revient automatiquement à l'étape précédente, le chrono redémarre avec le temps de l'étape précédente.

**Long tap sur le bouton "Maintenir pour sortir"**
Un tap long (1 seconde) sur le bouton back ferme l'écran, la home se réaffiche.

**Utilisation du slider sonore**
Le slider contrôle le volume du bip sonore : 
  - si le slider est à zéro il n'y a pas de son.
  - si le slider est à fond, le son du bip est à fond.
  - entre les min et max, le volume est proportionnel à la valeur du slider.

**Tap sur bouton back**
Le tap sur le bouton back ferme l'écran instantanément, la home se réaffiche.

## Compléments techniques pour la génération

### Couleurs à utiliser pour les 
  workColor = Color(0xFF4CD27E); // Vert pour Travail
  restColor = Color(0xFF2196F3); // Bleu pour Repos
  prepareColor = Color(0xFFFFCC00); // Jaune pour Préparation
  cooldownColor = Color.fromARGB(255, 203, 128, 216); // Violet pour Refroidissement