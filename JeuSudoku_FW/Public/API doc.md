#  API doc

Une application communique avec le framework par une API publique utilisant des données représentées par des String conformes à un certain langage, sans rien supposer de la représentation en Swift.

Ce langage décrit une liste de coups au Sudoku ou une liste de contraintes, sous forme d'une suite de lignes, ayant chacune une forme comme l'exemple suivant :

    Cf_9 Cg_8 - CfCg_98  // Commentaire
    
C'est-à-dire : une liste de contraintes de présence séparées par des espaces, suivi éventuellement d'un signe "-" puis d'une liste de contraintes séparées par des espaces, puis éventuellement d'un commentaire précédé de //


Suivant les fonctions, l'ordre des lignes est sémantiquement significatif ou non.
