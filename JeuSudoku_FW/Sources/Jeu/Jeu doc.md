#  Jeu doc

Jouer au sudoku consiste à faire évoluer un ensemble de contraintes relatives à un Puzzle donné, jusqu'à obtenir un ensemble équivalent de 81 singletons 1 conformes à la règle du jeu.

## Types de contraintes

Il y a une seule sorte de contraintes : les présences. Une présence indique que certaines valeurs doivent être obligatoirement présentes dans une certaine région.

Le raisonnement est monotone : une fois qu'une contrainte a été affirmée, elle reste définitivement vraie.

## Principe de la recherche

On cherche une bijection de cardinal p dans une région de cardinal n, incluse dans une zone.
n ≤ 6, p ≤ n, p ≤ 3.

D'après le triangle de Pascal :

    1
    1  1
    1  2  1
    1  3  3  1
    1  4  6  4  1
    1  5  10 10 5  1
    1  6  15 20 15 6  1
    
le nombre d'essais de p-uplets pour trouver une bijection de cardinal p parmi n ne dépasse pas 20.

Une fois qu'on a trouvé une bijection de cardinal p, on étudie la région complémentaire dans la zone. C'est aussi une bijection, de cardinal n - p. On parcourt les n - p valeurs possibles pour cette zone, et pour chacune d'entre elles on fait émettre tous les rayons possibles de la grille pour éliminer des cellules. Si pour une de ces valeurs on trouve une région restante qui n'a qu'une seule cellule, alors on a réussi à déterminer la valeur qui doit aller dans cette cellule restante.

Exemple : n = 5, p = 2. On se place dans une zone qui a exactement 5 cellules vides, et dans cette zone on cherche les paires2. Il y a C(5, 2) = 10 couples de valeurs à essayer. Quand on trouve un tel couple, avec par exemple les valeurs 1 et 2, on étudie les valeurs complémentaires pour les cellules complémentaires (il y a 3 cellules complémentaires). Par exemple, admettons qu'il s'agisse de 3, 4, 5. Pour chacune de ces valeurs, on émet tous les rayons venant de toute la grille qui éliminent des cellules et on regarde combien de cellules possibles restent dans la région de 3 cellules considérée. Si par exemple on trouve que la cellule Aa est la seule restante pour la valeur 4, alors on a trouvé un singleton Aa_4.

