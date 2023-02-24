#  Contraintes doc

Contraintes regroupe les définitions nécessaires à la représentation du concept de *contrainte* dans le jeu du sudoku.

Une contrainte met en relation la grille de sudoku avec les chiffres de 1 à 9.

Le vocabulaire correspond à l'idée qu'une cellule peut "contenir" un chiffre, et pas plus d'un chiffre. Les contraintes résultent de la structure de la grille, des règles du jeu et d'un ensemble de contraintes données initialement comme axiomes sous la forme : telle cellule contient tel chiffre.

Mathématiquement : il y a une application de l'ensemble des cellules dans l'ensemble des chiffres, et les 27 restrictions de cette application aux zones sont bijectives. Une contrainte parle d'une restriction de cette application à une région incluse dans une zone. Donc dans cette région, l'application est injective.

Il y a deux types de contraintes : les *présences* et les *absences*.

Une `Presence` affirme que telle région incluse dans une zone doit contenir (au moins) telles valeurs : l'ensemble image de la région contient les valeurs.

Une `Absence` affirme que telle région incluse dans une zone ne doit contenir aucune des valeurs données : l'ensemble image de la région doit être disjoint de l'ensemble des valeurs.

Le concept de `Presence`est très général, mais on se limite à certains cas particuliers : une ou deux cellules, une ou deux valeurs.

Les types Swift associés sont :

	Valeurs, UneContrainte, TypeContrainte, Presence, Absence

