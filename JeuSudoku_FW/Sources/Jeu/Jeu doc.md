#  Jeu doc

Jouer au sudoku consiste à faire évoluer un ensemble de contraintes relatives à un Puzzle donné, jusqu'à obtenir un ensemble équivalent de 81 singletons 1 conformes à la règle du jeu.

## Types de contraintes

Il y a une seule sorte de contraintes : les présences. Une présence indique que certaines valeurs doivent être obligatoirement présentes dans une certaine région.

Le raisonnement est monotone : une fois qu'une contrainte a été affirmée, elle reste définitivement vraie.

## Principe de la recherche

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
    
Dans la ligne 8, on peut aller jusqu'à C(8, 3) = 56.
Dans la ligne 9, on peut aller jusqu'à C(9, 2) = 36

Une fois qu'on a trouvé une bijection de cardinal p, on étudie la région complémentaire dans la zone. C'est aussi une bijection, de cardinal n - p. On parcourt les n - p valeurs possibles pour cette zone, et pour chacune d'entre elles on fait émettre tous les rayons possibles de la grille pour éliminer des cellules. Si pour une de ces valeurs on trouve une région restante qui n'a qu'une seule cellule, alors on a réussi à déterminer la valeur qui doit aller dans cette cellule restante.

Exemple : n = 5, p = 2. On se place dans une zone qui a exactement 5 cellules vides, et dans cette zone on cherche les paires2. Il y a C(5, 2) = 10 couples de valeurs à essayer. Quand on trouve un tel couple, avec par exemple les valeurs 1 et 2, on étudie les valeurs complémentaires pour les cellules complémentaires (il y a 3 cellules complémentaires). Par exemple, admettons qu'il s'agisse de 3, 4, 5. Pour chacune de ces valeurs, on émet tous les rayons venant de toute la grille qui éliminent des cellules et on regarde combien de cellules possibles restent dans la région de 3 cellules considérée. Si par exemple on trouve que la cellule Aa est la seule restante pour la valeur 4, alors on a trouvé un singleton Aa_4.

## Faits détectés

    struct EliminationCellule {
        let valeur: Int
        let eliminee: Cellule
        let eliminatrice: Presence
    }
    
    struct SingletonTrouveParElimination {
    	let singleton: Presence
    	let zone: any UneZone
    	let eliminations: [EliminationCellule]
    	let occupees: [Cellule]
    }
    
    struct Paire1TrouveeParElimination {
    	let paire1: Presence
    	let zone: any UneZone
    	let eliminations: [EliminationCellule]
    	let occupees: [Cellule]
    }
    
    struct SingletonTrouveParPaire {
    	let singleton: Presence
    	let zone: any UneZone
    	let eliminations: [EliminationCellule]
    	let occupees: [Cellule]
    	let detectionPaire: Paire2TrouveeParElimination
    }
    
    struct Paire2TrouveeParElimination {
    	let paire2: Presence
    	let zone: any UneZone
    	let eliminations: [EliminationCellule]
    	let occupees: [Cellule]
    }
    
    struct SingletonTrouveParTriplet {
    	let singleton: Presence
    	let zone: any UneZone
    	let eliminations: [EliminationCellule]
    	let occupees: [Cellule]
    	let detectionTriplet: Triplet3TrouveParElimination
    }

    struct Triplet3TrouveParElimination {
    	let triplet3: Presence
    	let zone: any UneZone
    	let eliminations: [EliminationCellule]
    	let occupees: [Cellule]
    }





