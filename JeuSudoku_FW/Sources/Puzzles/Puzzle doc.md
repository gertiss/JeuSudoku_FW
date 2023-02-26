#  Puzzle doc

Un *puzzle* est défini par les connaissances sur la structure de la grille, les règles du jeu du sudoku et la donnée d'un ensemble de contraintes de présence de type singleton1 sur une grille de sudoku (les cellules pré-remplies au démarrage).

Ces connaissances constituent les axiomes d'un système formel logique. On le suppose cohérent.

Le but du jeu est de déduire de ces axiomes un ensemble de 81 contraintes de type singleton1 donnant les valeurs de toutes les cellules de la grille.

On suppose que le système permet effectivement de déduire un ensemble unique de telles contraintes.

Un Puzzle peut être codé suivant la syntaxe SudokuExchangeBank, permettant la lecture sur fichier. Le format est le suivant, sur 99 caractères : id (12 caractères) + 1 espace + 81 chiffres + 2 espaces + niveau (3 caractères)

## Base de données

L'implémentation du type Puzzle est vue comme une base de données, les données stockées étant les contraintes. Cette base sert de point de départ pour différentes fonctions :

- les fonctions d'accès aux éléments des données.
- les requêtes et filtrages pour chercher et extraire des informations vérifiant certaines conditions.
- les transformations permettant d'obtenir un nouvel état (par exemple ajout ou suppression de contraintes)

On retrouve différents aspects des bases de données objet, relationnelles (SQL), déductives (Datalog).

On peut considérer que les "tables" SQL sont les ensembles des instances d'un type. Ici il n'y a qu'un seul type dont les instances sont stockées  : `Presence`. Mais les requêtes peuvent faire apparaître des "tables virtuelles non stockées" : ensembles de valeurs, de cellules, de zones.

Exemples de requêtes `select` purement structurelles : toutes les valeurs des contraintes, toutes les régions des contraintes, tous les types des contraintes, tous les couples (type, région), etc. Fonctionnellement, c'est map.

Exemples de requêtes `select where` : toutes les contraintes d'une zone, toutes les contraintes bijectives d'une zone, toutes les valeurs présentes dans une zone, toutes les cellules libres dans une zone. Fonctionnellement, c'est équivalent à une combinaison de filter et de map. Et cela peut utiliser des connaissances spécifiques du domaine qui ne sont pas dans la base (Geometrie, règles du jeu).

On peut aussi avoir des requêtes qui imposent des conditions sur l'ensemble des résultats d'une requête, unicité en particulier : la seule cellule libre dans une zone, la seule valeur absente dans une zone.

La composition de plusieurs requêtes peut être vue comme une règle Datalog,  une jointure SQL ou un pipe-line fonctionnel.

Les transformations peuvent être : ajouter une contrainte, supprimer une contrainte, remplacer un ensemble de contraintes par un autre.

## Règles

Une règle condition-action est en gros de la forme : effectuer une requête ("condition") puis, si cette requête réussit, exécuter une certaine transformation  de la base ("action") à partir des données du résultat.

Une règle peut être implémentée comme une fonction retournant une transformation à exécuter. Une telle transformation est un "coup".

