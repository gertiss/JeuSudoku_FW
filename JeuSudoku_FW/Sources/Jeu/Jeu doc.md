#  Jeu doc

Jouer au sudoku consiste à faire évoluer un ensemble de contraintes relatives à un Puzzle donné, jusqu'à obtenir un ensemble équivalent de 81 singletons 1 conformes à la règle du jeu.

## Coup

L'évolution se fait par des *coups*. Un coup consiste en deux étapes : d'abord supprimer certaines contraintes (une ou deux), et ensuite insérer une nouvelle contrainte.

Chaque coup est assorti d'une explication indiquant dans quel processus de recherche ce coup a été trouvé, le principe qui a permis de le trouver, avec les informations qui ont été nécessaires.

La découverte d'un coup se place souvent dans un processus de recherche par élimination : on se focalise sur une valeur x et sur une zone z, et on se pose la question "quelles sont les cellules vides possibles pour x dans z, après élimination par tel procédé d'élimination ?"

## Découverte dans une zone sans élimination de cellules

### Dernière cellule

Si dans une zone z il ne reste plus qu'une cellule "libre", alors on peut affirmer un singleton avec cette cellule et la dernière valeur possible.

### Deux dernières cellules

Si dans une zone z il ne reste plus que deux cellules "libres", alors on peut affirmer une paire2 avec les deux valeurs restantes.

## Elimination de cellules pour une valeur x dans une zone z

Les procédés d'élimination de cellules sont les suivants :

### Elimination par singleton non x

Toute cellule singleton de valeur différente de x est impossible pour x

### Elimination par singleton x

Si une contrainte est un singleton x, alors toute cellule de la réunion de sa ligne, sa colonne et son carré est impossible pour x.

### Elimination par contrainte alignée

Si une région forme une contrainte alignée qui contient la valeur x, alors toute cellule de l'alignement en dehors de la région est impossible pour x.

C'est vrai en particulier pour une paire1 ou une paire2. Les singletons sont aussi un cas particulier, mais en plus ils éliminent tout leur carré, et ils sont utilisés dans un autre procédé.

## Découverte après élimination

### Singleton

Si après élimination des cellules impossibles pour la valeur x on trouve qu'il ne reste plus qu'une seule cellule c dans la zone z, alors on peut affirmer singleton1(c, x)

### Paire1

Si après élimination des cellules impossibles pour la valeur x on trouve qu'il ne reste plus que deux cellules alignées c et d dans la zone z, alors on peut affirmer paire1(cd, x)

## Réduction après découverte

### paire1 -> Fusion de deux paires 1

### singleton1 -> division d'une paire





