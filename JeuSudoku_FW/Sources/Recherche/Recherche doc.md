#  Recherche doc

Jouer au sudoku consiste à faire évoluer un ensemble de contraintes relatives à un Puzzle donné, jusqu'à obtenir un ensemble équivalent de 81 singletons 1 conformes à la règle du jeu.

Cette évolution se produit pas à pas : on cherche un coup, puis on le joue. La difficulté consiste à trouver les coups possibles et à choisir à chaque pas le premier qui soit "le plus facile", ou "le plus visible".

## Types de contraintes

Une présence indique que certaines valeurs doivent être obligatoirement présentes dans une certaine région incluse dans une zone.

Une absence indique que certaines valeurs doivent être obligatoirement absentes dans une certaine région incluse dans une zone.

Présences et absences sont complémentaires : si une valeur est obligatoirement présente dans une région d'une zone, alors elle est obligatoirement absente dans le complémentaire de cette région dans la zone.

Le raisonnement est monotone : une fois qu'une contrainte a été affirmée, elle reste définitivement vraie, en particulier dans la solution finale.

## Recherche à partir d'une bijection

On cherche une bijection de cardinal p dans une région de cardinal n, incluse dans une zone.

D'après le triangle de Pascal :

    0: 1
    1: 1  1
    2: 1  2  1
    3: 1  3  3  1
    4: 1  4  6  4  1
    5: 1  5  10 10 5  1
    6: 1  6  15 20 15 6  1
    7: 1  7  21 35 35 21  7  1
    8: 1  8  28 56 70 56  28 8 1
    9: 1  9  36 84 126 126 84  36 9  1
    
Pour limiter la combinatoire, on se restreint à certains couples (n, p) :

dans la ligne n = 8, on peut aller jusqu'à p = 3 : C(8, 3) = 56.
dans la ligne n = 9, on peut aller jusqu'à p = 2 : C(9, 2) = 36

Ensuite il y a deux façons principales d'exploiter une bijection :

### Elimination dans le complémentaire dans la même zone

Une bijection avec p valeurs définit une présence (les p valeurs doivent être dans la région) et une absence (les autres valeurs sont obligatoirement absentes de la région). Ces absences peuvent faciliter la recherche d'éliminations dans la zone.

Cela peut produire la stratégie suivante : une fois qu'on a trouvé une bijection de cardinal p, on étudie la région complémentaire dans la zone. C'est aussi une bijection, de cardinal n - p. On parcourt les n - p valeurs possibles pour cette zone, et pour chacune d'entre elles on fait émettre tous les rayons possibles de la grille pour éliminer des cellules. Si pour une de ces valeurs on trouve une région restante qui n'a qu'une seule cellule, alors on a réussi à déterminer la valeur qui doit aller dans cette cellule restante.


### Elimination d'une des valeurs da la région

Une bijection avec p valeurs définit une présence (les p valeurs doivent être dans la région) et une ou plusieurs absences : les p valeurs doivent être absentes du complémentaire de la région dans toute zone qui contient la région.

Cela peut produire la stratégie suivante : une fois qu'on a trouvé une bijection de cardinal p, on effectue toutes les éliminations pour les p valeurs, puis on cherche à compléter ces éliminations dans d'autres zones pour finalement trouver une seule cellule possible pour une certaine valeur. C'est un peu comme l'élimination indirecte par une paire1.
