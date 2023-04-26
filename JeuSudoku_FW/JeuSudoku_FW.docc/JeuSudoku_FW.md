# ``JeuSudoku_FW``


Système "expert" de résolution d'un système de contraintes.

## Base de contraintes

La base de "faits" est une base de contraintes (Presence), de différents types :

- singleton1
- singleton2
- paire1
- paire2


## Règles 

La plupart de ces règles se déclenchent sur apparition d'une contrainte nouvelle. A chaque fois, elles remplacent un certain ensemble de contraintes par un autre. Ce sont des règles de réécriture. L'introduction d'un élément reconfigure tout le système. Il y a peut-être alors des problèmes de concurrence : que se passe-t-il si une règle fait disparaître le nouveau venu ?


### Règles permettant de trouver des absences 

La forme de ces règles est "certaines présences impliquent des absences". Mais ce ne sont pas des règles sur événement. Ce sont des implications logiques statiques. Elles découlent des règles du puzzle.

- Si `singleton1 c_x` dans zone Z alors x est absent de Z - c (si pas encore connu)
- Si `paire1 cd_x` dans zone Z  alors x est absent dans Z - cd 
- Si `paire2 cd_xy` dans zone Z  alors x est absent dans Z - cd, et même chose pour y


Cette dernière règle est déductible de : `paire2 cd_xy => paire1 cd_x et paire1 cd_y`

Il s'agit des "règles d'élimination, directe ou indirecte". On n'essaye pas de les appliquer lorsqu'un événement survient, mais lorsqu'on est à court d'événements. On est dans une situation bloquée qu'il faut débloquer. 

Mode déblocage : on se focalise alors sur une zone, on cherche le premier manquant dans cette zone, on cherche ses contraintes émettrices singleton1, paire1, paire2, on applique les règles d'élimination à ces émetteurs (du moins ceux qui ciblent la zone). Si une de ces règles s'appliquent, on quitte le mode déblocage et on passe en mode propagation. Si on ne trouve rien, on fait la même chose avec une autre zone. Si on n'a rien trouvé après avoir essayé toutes les zones, on est bloqué.


### Règles permettant de trouver des présences

#### Règles utilisant des absences :

- S'il y a des absences de x ou occupation dans 8 cellules d'une zone Z, alors singleton `c_x` avec c la neuvième cellule, et les absences disparaissent
- S'il y a des absences ou occupations dans 7 cellules d'une zone Z, alors paire1 `cd_x ` avec cd les deux cellules restantes, et les absences disparaissent.


### Règles de réduction des présences :

- Fusion de paires 1 :
    `AaAb_1` et `AaAb_2` disparaissent et fusionnent en `AaAb_12`
- Fusion de singletons 2 :
    `Aa_12`et `Ab_12` disparaissent et fusionnent en `AaAb_12`
- Réduction d'une paire1 en un singleton1 :
    si `AaAb_1` connu alors pour x ≠ 1 : Aa_x nouveau -> `Ab_1`, et AaAb_1 disparaît
- Disparition d'un singleton2  :
    si `Aa_1` nouveau alors  `Aa_12` connu disparaît.
- Réduction d'une paire2 en un singleton1 :
    si `Aa_1` nouveau alors `AaAb_12` connu est remplacé par `Ab_2`

### Règles de réduction des absences :

- Si la zone Z contient un singleton1 c_x, alors on peut supprimer toutes les absences concernant x dans Z
- Si la zone Z contient une paire2 cd_xy, alors on peut supprimer toutes les absences concernant x et y dans Z

Les autres absences peuvent être gardées


## Implémentation


Il y a plusieurs aspects informatiques potentiellement combinatoires :

- la recherche d'instances pertinentes pour trouver une règle à appliquer. L'efficacité peut dépendre grandement d'heuristiques et d'indexations compilées. Il s'agit du problème général des requêtes dans une base de données.
- ayant trouvé des instances, appliquer une règle pour créer des déductions n'est pas vraiment combinatoire. C'est fonctionnel.
- la propagation des déductions faites. Etant donné que le raisonnement est monotone (toutes les contraintes trouvées restent définitivement valides, sauf qu'elles sont parfois remplacées pour des questions de minimalité), on peut penser à procéder de manière parallèle asynchrone. Un système réactif comme Combine semble indiqué. Un tableur fonctionne suivant ce genre d'idées.
- la réduction de la base de contraintes. Là-aussi, Combine semble indiqué. Et la réduction peut se faire incrémentalement lors de la phase de propagation.

Eviter les bouclages : il faut se souvenir qu'on a "entièrement exploré" un carré
