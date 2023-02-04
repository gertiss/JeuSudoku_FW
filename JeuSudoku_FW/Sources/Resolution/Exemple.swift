//
//  Exemple.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 03/02/2023.
//

import Foundation

struct Exemple {
    var etapes: [Etape]
}

/// "Je suis parti d'un Puzzle et voici ce que j'ai trouvé"
struct Etape {
    var puzzle: Puzzle
    var rapport: RapportDeRecherche
}
