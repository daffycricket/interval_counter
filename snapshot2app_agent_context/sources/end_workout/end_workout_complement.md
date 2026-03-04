# Complements de spécifications au design
Ce document est un complément de règles qui ne sont pas visibles dans le fichier de design end_workout_design.json. 
Ces éléments doivent être pris en compte dans la génération du plan de développement, dans le build et dans les phases de test. 

## Détails sur l'écran
Ecran "Fin de workout". 
Il s'agit de l'écran terminal du workout. Il s'affiche à la fin du tunnel d'étapes du workout, et permet : 
- soit de relancer exactement le même workout
- soit d'arrêter et de retourner à la home

## Interactions 
**Tap sur le bouton "Arrêter"**
Le workout est terminé. L'écran "Fin de workout" se ferme, puis retour sur la home. 

**Tap sur le bouton "Reprendre"**
L'écran "Fin de workout" se ferme, puis le workout se relance et repart à zéro.