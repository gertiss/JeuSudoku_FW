//
//  Exemple.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 03/02/2023.
//

import Foundation

public struct ExempleResolu: Hashable {
    
    public let puzzle: Puzzle
    public let rapport: RapportDeRecherche
    
    public init(puzzle: Puzzle, rapport: RapportDeRecherche) {
        self.puzzle = puzzle
        self.rapport = rapport
    }
    
}

