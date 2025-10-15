# Complements de spécifications au design
Ce document est un complément de règles et d'éléments qui ne sont pas visibles dans le fichier de design home_design. 
Ces éléments doivent être pris en compte dans la génération du plan de développement, dans le build et dans les phases de test. 

## Valeurs par défaut
- 1. au premier lancemence de l'app, les valeurs par défaut sont :
 - dans la section "démarrage rapide"
  - 8 répétitions
  - 45 secondes de travail
  - 15 secondes de repos 
 - une preselection déjà présente dans la liste
  - titre "Tabata"
  - 8 répétitions
  - 20 secondes de travail
  - 10 secondes de repos 
- 2. aux démarrages suivants, les valeurs par défaut affichées sont recupérées du stockage local (shared preferences)

## Interactions avec une carte de préréglage dans la liste
**Swipe**
Un swipe vers la droite dans la liste permet de supprimer un préréglage.

## Autres règles
- L'incrément de tous les controles (répétition, travail, repos...) est de 1 seconde
- Format d'affichage du temps : "00 : 44" (avec espaces)