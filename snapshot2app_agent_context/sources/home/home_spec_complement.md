# Complements de spécifications au design
Ce document est un complément de règles qui ne sont pas visibles dans le fichier de design home_design.json. 
Ces éléments doivent être pris en compte dans la génération du plan de développement, dans le build et dans les phases de test. 

## Détails sur l'écran
Ecran "Home". 
Il s'agit de l'écran principal de l'app.

## Valeurs par défaut au premier lancement de l'écran

**1. Dans la section "Démarrage rapide"**
  - 10 répétitions
  - 40 secondes de travail
  - 20 secondes de repos 

**2. Dans la section de préréglages**
  - Aucun préréglage déjà présent 

## Interactions 
**Swipe sur une carte de préréglage dans la liste**
Un swipe dans la liste permet de supprimer un préréglage.

**Ajout d'un préréglage**
Quand on veut ajoute un préréglage, l'app doit afficher une boite de dialogue permettant la saisie du nom du préréglage.


## Autres règles
- L'incrément de tous les controles (répétition, travail, repos...) est de 1 seconde
- Le format d'affichage du temps est "00 : 44" (avec espaces)