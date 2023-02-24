//
//  Exemples bootstrap.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 18/02/2023.
//

import Foundation

public extension Puzzle {
    
    static let bootstrap1 = Puzzle(
        contraintes: [
            Presence(nom: "Aa_1"),
            Presence(nom: "Ab_23"),
            Presence(nom: "BaBb_4"),
            Presence(nom: "CaCb_56")
        ])

}
