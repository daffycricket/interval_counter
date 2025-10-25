# Complements de spécifications au design
Ce document est un complément de règles qui ne sont pas visibles dans le fichier de design workout_design.json. 
Ces éléments doivent être pris en compte dans la génération du plan de développement, dans le build et dans les phases de test. 

## Détails sur l'écran
Ecran "Workout". 
Il s'agit de l'écran qui permet d'exécuter la session d'entrainement sélectionné dans l'écran "Home", en enchainant les étapes (Préparation, n répétitions de Travail puis Repos, Refoidissement)

**Suite d'étapes de l'écran**
Cet écran passe dans chacune des étapes : 
 - 1. Préparation 
 - 2. n répétitions de :
    - 2.a. Travail
    - 2.b. Repos
 - 3. Refoidissement

**Fonctionnement de l'écran**
Cet écran affiche un chronomètre qui décroit d'une seconde, à chaque seconde.
Dès l'affichage de l'écran ou de l'étape, le durée s'affiche, le chrono se lance et décroit jusqu'à 00:00.
Une fois le temps terminé, l'écran passe à l'étape d'après dans le pré-réglage.

## Règles de gestion sur les transitions
**Règles de gestion**
- L'étape "Repos" de la dernière répétition n'est pas exécutée, l'écran passe directement dans l'étape "Refroidissement" s'il y en a une.
- Si une étape est à zéro secondes dans le préréglage, l'étape n'est pas affichée, l'écran passe directement à l'étape d'après.
- Lors des 3 dernières secondes d'une étape, l'appli émét un bip sonore à chaque seconde, donc à : 
  - 00:05 => pas de bip sonore
  - 00:04 => pas de bip sonore
  - 00:02 => bip sonore
  - 00:01 => bip sonore
  - 00:00 => bip sonore

**Exemple pour le préréglage suivant : 5/3x(40/20)/10** 
  - 5 secondes de préparation
  - 3 répétitions
    - 40 secondes de travail
    - 20 secondes de repos 
  - 10 secondes de refroidissement

L'écran passe dans les étapes suivantes : 
1. Préparation (5 secondes)
2. Travail (40 secondes) - reste 3 répétitions
3. Repos (20 secondes) - reste 3 répétitions
4. Travail (40 secondes) - reste 2 répétitions
5. Repos (20 secondes) - reste 2 répétitions
6. Travail (40 secondes) - reste 1 répétition
7. Refroidissement (10 secondes)

**Exemple pour le préréglage suivant : 0/3x(40/20)/0** 
  - 0 secondes de préparation
  - 3 répétitions
    - 40 secondes de travail
    - 20 secondes de repos 
  - 0 secondes de refroidissement

L'écran passe dans les étapes suivantes : 
1. Travail (40 secondes) - reste 3 répétitions
2. Repos (20 secondes) - reste 3 répétitions
3. Travail (40 secondes) - reste 2 répétitions
4. Repos (20 secondes) - reste 2 répétitions
5. Travail (40 secondes) - reste 1 répétition

## Règles de gestion visuelles
**Disparation de boutons et d'éléments interactifs"**
Au lancement de l'écran, tous les éléments interactifs - boutons, fab, slider - sont affichés.
Au bout de 1500 ms, les éléments interactifs suivants disparaissent : 
  - le slider de volume, tout en haut de l'écran.
  - la ligne de contrôles : bouton précédent / bouton "Maintenir pour sortir" / bouton suivant.
  - le fab de pause en bas à droite.
Ils ne réapparaissent pas lorsque l'écran change d'étape.
Ils réapparaissent si l'utilisateur tap n'importe où sur l'écran, puis redisparaissent au bout de 1500 ms.

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
- met en pause le chrono de l'étape et la session d'entrainement : tout est figé.
- Le fab "Pause" est remplacé par un fab "Start"

**Tap sur le fab Start**
Un tap sur le Floating Action Button "Start" : 
- rédémarre le chrono et la session continue
- Le fab "Start" est remplacé par le fab "Pause"

**Tap sur bouton suivant**
L'écran passe automatiquement à l'étape suivante, le chrono redémarre avec le temps de l'étape suivante.

**Tap sur bouton précédent**
L'écran revient automatiquement à l'étape précédente, le chrono redémarre avec le temps de l'étape précédente.

**Tap sur le bouton "Maintenir pour sortir"**
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