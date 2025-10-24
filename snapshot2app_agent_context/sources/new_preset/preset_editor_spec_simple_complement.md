# Complements de spécifications au design
Ce document est un complément de règles qui ne sont pas visibles dans le fichier de design preset_editor_design_simple.json. 
Ces éléments doivent être pris en compte dans la génération du plan de développement, dans le build et dans les phases de test. 

## Détails sur l'écran
Ecran "Preset". 
Il s'agit de l'écran qui permet de créer et modifier des pré-réglages.
Cet écran a deux vues différentes : 
 - une version "SIMPLE" 
 - une version "ADVANCED", qui permet de saisir des réglages de manière plus complexe.

Le fichier de design preset_editor_design_simple.json et cette spécification se concentrent sur la vue SIMPLE. Le complément de la vue ADVANCED sera traitée plus tard.

## Valeurs par défaut 
**Au lancement de l'écran en mode création**
  - 5 secondes de préparation
  - 10 répétitions
  - 40 secondes de travail
  - 20 secondes de repos 
  - 30 secondes de refroidissement
**Au lancement de l'écran en mode modification d'un pré-réglage**
Valorisées avec les données du pré-réglage sélectionne sur l'écran Home.

## Interactions 
**Tap sur SIMPLE / ADVANCED**
Un tap sur le bouton ADVANCED dans la barre de menu affiche la vue ADVANCED, soit un écran vide.
Un tap sur le bouton SIMPLE dans la barre de menu ré-affiche la vue SIMPLE

**Tap sur l'icone d'enregistrement**
Le pré-réglage est sauvegardé, l'écran se ferme, la home se réaffiche, le nouveau pré-réglage est visible dans la liste.

**Tap sur bouton back**
Le tap sur le bouton back ferme l'écran, le pré-réglage n'est pas sauvegardé, la home se réaffiche, la liste n'a pas changé.
