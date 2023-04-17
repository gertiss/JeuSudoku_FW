//
//  Probleme.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 10/04/2023.
//

import Foundation
import Modelisation_FW

public struct Probleme: UnLitteral, Identifiable {
    
    public let chiffresPuzzle: String
    public var titre: String = ""
    public var commentaire: String = ""
    public let puzzle: Puzzle_
    public let id: String

    public init(chiffresPuzzle: String, titre: String, commentaire: String = "") {
        self.chiffresPuzzle = chiffresPuzzle
        self.puzzle = try! Puzzle_(chiffres: chiffresPuzzle)
        self.id = chiffresPuzzle
        self.titre = titre
    }
        
    public var codeSwift: String {
        "Probleme(chiffresPuzzle: \(chiffresPuzzle.codeSwift), titre: \(titre.codeSwift), commentaire: \(commentaire.codeSwift)"
    }

}

public extension Probleme {
    
    static var predefinis: [Probleme] {
        [
            Probleme(
                chiffresPuzzle: """
753 601 840
641 080 370
982 007 165

539 760 018
126 008 037
478 000 056

890 000 620
360 800 590
215 006 783
""",
                titre: "JD niveau 5, 2.8, 09/04/23",
                commentaire: "Dans la ligne I, il ne reste que deux cellules Id Ie, donc paire IdIe_49. Donc cela élimine 4 et 9 dans toutes les autres cases du carré Pn, en particulier dans la colonne f, en Gf et Hf. Puis on raisonne pour la valeur 4 dans la colonne f. Gf et Hf sont éliminées par le raisonnement précédent, Bf est éliminée à cause de Bb_4, Ff est éliminée à cause de Fa. Il ne reste plus que Df")
        ]
    }
}


