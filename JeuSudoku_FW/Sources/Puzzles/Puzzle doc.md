#  Puzzle doc

Un *puzzle* est défini par les connaissances sur la structure de la grille, les règles du jeu du sudoku et la donnée d'un ensemble de contraintes de présence de type singleton1 sur une grille de sudoku (les cellules pré-remplies au démarrage).

Ces connaissances constituent les axiomes d'un système formel logique. On le suppose cohérent.

Le but du jeu est de déduire de ces axiomes un ensemble de 81 contraintes de type singleton1 donnant les valeurs de toutes les cellules de la grille.

On suppose que le système permet effectivement de déduire un ensemble unique de telles contraintes.

Un Puzzle peut être codé suivant la syntaxe SudokuExchangeBank, permettant la lecture sur fichier. Le format est le suivant, sur 99 caractères : id (12 caractères) + 1 espace + 81 chiffres + 2 espaces + niveau (3 caractères)

