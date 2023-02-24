#  Geometrie doc

`Geometrie` regroupe les définitions nécessaires à la représentation purement géométrique d'une grille de sudoku, sans tenir compte de son contenu. Il s'agit d'une description purement structurelle, ne faisant intervenir que des références de position et des ensembles de cellules.

L'élément de base est la *cellule*. Une cellule est repérée par ses coordonnées (indexLigne, indexColonne), les indices allant de 0 à 8.

Une *région* est un ensemble de cellules.

Certaines régions ont un rôle particulier : ce sont les *zones* (*carrés*, *lignes*, *colonnes*). Lorsqu'on remplit une grille, chaque chiffre de 1 à 9 doit apparaître une fois et une seule dans chaque zone, c'est la règle du jeu.

En plus des zones, on définit les *bandes* horizontales et verticales, qui sont des groupes de 3 lignes (trois bandes horizontales et trois bandes verticales). Chaque bande est repérée par un index de 0 à 2. Les bandes permettent de définir la position des carrés (un carré est l'intersection d'une bande horizontale et d'une bande verticale).

Les types Swift associés sont :

    Cellule, Region, Ligne, Colonne, Carre, TypeZone, UneZone, BandeH, BandeV
    Grille
    
On représente les principales relations topologiques entre tous ces éléments (intersections, réunions, inclusions) sous forme de fonctions d'accès dans chaque type, par exemple `carre.cellules`

Le type `Grille` mémorise de manière centralisée toutes les régions importantes connues (cellules, lignes, colonnes, carrés, bandes, zones). Ce sont les constantes du domaine.

La plupart de ces types vérifient les protocoles `Testable` et `InstanciableParNom` pour faciliter les tests, le debug, la saisie et la lecture-écriture sur fichier.
