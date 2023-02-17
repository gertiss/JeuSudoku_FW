# ``JeuSudoku_FW``


Système "expert" de résolution d'un système de contraintes.

La base de "faits" est une base de contraintes, de différents types :

- Présence : telle valeur figure exactement une fois dans tel ensemble de cellules
- Absence : telle valeur ne figure pas dans tel ensemble de cellules
- bijection : tel ensemble de cellules contint exactement telle valeur

Règles :

- Règle de rayons secondaires : quand on a une contrainte d'absence, si le complémentaire de l'absence dans un carré est une région R alignée, alors on peut déduire une nouvelle absence, dans le complémentaire de R dans l'alignement.
- Inclusion d'une bijection dans une autre. On peut réduire la bijection contenante : on lui enlève les cellules et les valeurs de la bijection contenue.
- Inclusion d'une absence dans une bijection.  


Il ne s'agit en gros "que" d'un démonstrateur de théorèmes qui utilise uniquement la théorie des ensembles basique avec union, intersection, complémentaire, bijection, injection, surjection.

Les contraintes et règles sont réifiées par des types Swift déclaratifs et fonctionnels.

Il y a plusieurs aspects informatiques potentiellement combinatoires :

- la recherche d'instances pertinentes pour trouver une règle à appliquer. L'efficacité peut dépendre grandement d'heuristiques et d'indexations compilées. Il s'agit du problème général des requêtes dans une base de données.
- ayant trouvé des instances, appliquer une règle pour créer des déductions n'est pas vraiment combinatoire. C'est fonctionnel.
- la propagation des déductions faites. Etant donné que le raisonnement est monotone (toutes les contraintes trouvées restent définitivement valides, sauf qu'elles sont parfois remplacées pour des questions de minimalité), on peut penser à procéder de manière parallèle asynchrone. Un système réactif comme Combine semble indiqué. Un tableur fonctionne suivant ce genre d'idées.
- la réduction de la base de contraintes. Là-aussi, Combine semble indiqué. Et la réduction peut se faire incrémentalement lors de la phase de propagation.
