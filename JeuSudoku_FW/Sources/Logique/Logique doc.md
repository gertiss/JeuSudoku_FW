#  Logique doc

On décrit ici les bases du raisonnement logique sur le sudoku.

## Prédicats 

### Prédicats concernant la solution finale

Ces prédicats peuvent être vérifiés directement dans la solution finale.

- *La cellule c contient la valeur x*
- *La cellule c ne contient pas la valeur x*
- *Dans la zone Z, la région R est en bijection avec l'ensemble de valeurs V*
- *Dans la zone Z, la valeur x ne peut aller que dans la région R*. Cela signifie : la région R contient x et la région complémentaire da R dans la zone ne contient pas x.

### Prédicats concernant l'état actuel

"Etat actuel" fait référence aux cellules qu'on a déjà résolues, c'est-à-dire à une grille partielllement remplie.

Il s'agit ici de raisonnement méta sur ce qu'on a prouvé ou pas, en utilisant un certain système formel d'un certain "niveau". Ce raisonnement peut inclure des méta-faits comme "tel fait est indécidable". Dans ce raisonnement, il y a une certaine base de faits évolutive.

- *La cellule c est résolue*. C'est-à-dire : on a prouvé que c contenait x pour un certain x.
- *La cellule c n'est pas résolue*. C'est-à-dire : on n'a pas prouvé que c contenait x pour un certain x.
- *La valeur x est présente dans la zone z*. C'est-à-dire : il existe une cellule résolue de z qui contient x.
- *La valeur x est absente de la zone z*. C'est-à-dire : il n'existe aucune cellule résolue de z qui contienne x.
- *La valeur x est candidate pour la cellule c*. C'est-à-dire : on n'a pas encore prouvé que c ne contenait pas x. 


## Règles

### Règles de base

#### Règles d'élimination

Une règle d'élimination a une conclusion de type "c ne contient pas x"

- Si c contient x et d est dans la même ligne que c avec d ≠ c, alors d ne contient pas x
- Si c contient x et d est dans la même colonne que c avec d ≠ c, alors d ne contient pas x
- Si c contient x et d est dans le même carré que c avec d ≠ c, alors d ne contient pas x

#### Règles de résolution de cellule

Une règle de résolution de cellule a une conclusion de type "c contient x"

- Si une zone contient 8 cellules résolues, alors la dernière cellule non résolue de la zone contient la seule valeur restante ne figurant pas dans les 8 cellules résolues
- Si une zone contient 8 cellules ne contenant pas x, alors alors la dernière cellule restante contient x.
- Si une bijection est de cardinal 1, alors sa cellule contient sa valeur.

### Règles de bijection

Une règle de bijection a une conclusion de type "la région R est en bijection avec l'ensemble de valeurs V".

- Si dans une zone il existe une région R et et un ensemble V de valeurs, avec R et V de même cardinal, tels qu'aucune des cellules complémentaires de R ne contient aucune des valeurs de V, alors R est en bijection avec V.
- Si une région R d'une zone est en bijection avec un ensemble de valeurs V, alors l'ensemble des cellules du complémentaire de R dans la zone qui ne sont pas résolues est en bijection avec le complémentaire de l'ensemble (valeurs de la bijection U valeurs présentes dans la zone). C'est une sorte de réciproque de la règle précédente.

### Règles de présence

Une règle de présence a une conclusion de type "les cellules de R sont les seules de la zone où la valeur x est candidate", ce qui peut se traduire par "x ne peut aller que dans R". Lorsqu'on est dans cette situation, aucune cellule du complémentaire de R dans la zone ne contient x et pour aucune des cellules de R on n'a pu prouver "c ne contient pas x".

- Si une région R d'une zone est une bijection et que x est une de ses valeurs, alors x ne peut aller que dans R.
- Si une région R d'une zone ne contient aucune cellule résolue, si aucune des cellules du complémentaire de R ne contient x, et si pour aucune des cellules de R on n'a pu prouver "c ne contient pas x", alors x ne peut aller que dans R.
