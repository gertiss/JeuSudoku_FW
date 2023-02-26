#  Jeu doc

Jouer au sudoku consiste à faire évoluer un ensemble de contraintes relatives à un Puzzle donné, jusqu'à obtenir un ensemble équivalent de 81 singletons 1 conformes à la règle du jeu.

## Coup

L'évolution se fait par des *coups*. Un coup consiste en deux étapes : d'abord supprimer certaines contraintes (une ou deux), et ensuite insérer une nouvelle contrainte.


## Découverte dans une zone sans élimination de cellules

### Dernière cellule

Si dans une zone z il ne reste plus qu'une cellule "libre", alors on peut affirmer un singleton avec cette cellule et la dernière valeur possible.

### Deux dernières cellules

Si dans une zone z il ne reste plus que deux cellules "libres", alors on peut affirmer une paire2 avec les deux valeurs restantes.

## Elimination de cellules pour une valeur x dans une zone z

Les procédés d'élimination de cellules sont les suivants :

### Elimination par singleton1 x

Si une contrainte est un singleton1 x, alors toute cellule de la réunion de sa ligne, sa colonne et son carré est impossible pour x. C'est la règle du jeu.

### Elimination par singleton 1 ou 2 ou paire2 ne contenant pas x

Toute cellule d'un singleton 1 ou 2 ou d'une paire2 ne contenant pas x est impossible pour x. C'est une éliminaton "interne".


### Elimination par contrainte alignée contenant x

Si une région forme une contrainte alignée qui contient la valeur x, alors toute cellule de l'alignement en dehors de la région est impossible pour x. C'est une élimination "externe".

C'est vrai en particulier pour une paire1 ou une paire2 si elles sont alignées. Les singletons sont aussi un cas particulier, mais en plus ils éliminent tout leur carré, et ils sont utilisés dans un autre procédé.

## Découverte après élimination

### Singleton

Si après élimination des cellules impossibles pour la valeur x on trouve qu'il ne reste plus qu'une seule cellule c dans la zone z, alors on peut affirmer singleton1(c, x)

### Paire1

Si après élimination des cellules impossibles pour la valeur x on trouve qu'il ne reste plus que deux cellules alignées c et d dans la zone z, alors on peut affirmer paire1(cd, x)

## Réduction après découverte

### paire1 -> Fusion de deux paires 1

### singleton1 -> division d'une paire





