//
//  Puzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Un Puzzle est défini par un ensemble de contraintes et le problème à résoudre est de réduire cet ensemble à un ensemble équivalent de singletons.
/// Les contraintes sont des affirmations d'existence de bijections.
/// Ces bijections incluent les 27 bijections sur les zones.
public struct Puzzle {
    
    public let contraintes: [any UneContrainte]
    
    public init(contraintes: [any UneContrainte]) {
        self.contraintes = contraintes
    }
    
}

public extension Puzzle {
    
    var contraintesExistenceBijection: [ExistenceBijection] {
        contraintes.filter { $0.type == .existenceBijection }.map { $0 as! ExistenceBijection }
    }
    
    /// Les 27 contraintes de bijection toujours associées implicitement aux zones
    var contraintesBijectionZone: [ExistenceBijection]  {
        Grille.zones.map { zone in
            ExistenceBijection(puzzle: self, zone.cellules, (1...9).map { $0 }.ensemble)
        }
    }
    
    var singletons: [ExistenceBijection] {
        contraintesExistenceBijection.filter { $0.cardinal == 1 }
    }
    
    var paires: [ExistenceBijection] {
        contraintesExistenceBijection.filter { $0.cardinal == 2 }
    }
    
    var triplets: [ExistenceBijection] {
        contraintesExistenceBijection.filter { $0.cardinal == 3 }
    }
    
    /// L'unique bijection dont l'ensemble de cellules est le singleton [cellule]
    /// Peut échouer, retourne alors nil.
    func leSingleton(cellule: Cellule) -> ExistenceBijection? {
        singletons.filter{ $0.domaine.contains(cellule) }.first
    }
    
    /// La valeur de cellule si on peut la déduire directement d'une contrainte singleton
    func valeur(cellule: Cellule) -> Int? {
        return leSingleton(cellule: cellule)?.valeurs.uniqueValeur
    }

}

// MARK: - Codage
public extension Puzzle {
    
    /// Le code est une ligne de la banque de grilles
    /// publiée sur Sudoku Exchange "Puzzle Bank"
    /// https://sudokuexchange.com
    /// Format : id (12)  espace (1) chiffres (81) espace (2) niveau (3)
    init(_ code: String) {
        let codage = CodagePuzzle(code)
        let chiffres = codage.chiffres
        var listeContraintes = [ExistenceBijection]()
        
        let puzzle = Puzzle(contraintes: [])
        for indexLigne in 0...8 {
            for indexColonne in 0...8 {
                let chiffre = chiffres[indexLigne * 9 + indexColonne]
                if chiffre != 0 { listeContraintes.append(ExistenceBijection(puzzle: puzzle, [Cellule(indexLigne, indexColonne)], [chiffre]))}
            }
        }
        self = Self(contraintes: listeContraintes + puzzle.contraintesBijectionZone)
    }
    
}

public extension CodagePuzzle {
    
    /// Le puzzle créé à partir du code. On oublie id et niveau.
    /// On suppose le code correct.
    var puzzle: Puzzle {
        Puzzle(code)
    }

}
