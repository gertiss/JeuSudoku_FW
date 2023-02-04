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
public struct Puzzle: Hashable, Codable {
    
    public let contraintes: Set<ExistenceBijection>
    
    public init(contraintes: Set<ExistenceBijection>) {
        self.contraintes = contraintes
    }
    
}

public extension Puzzle {
    
    /// Les 27 contraintes toujours associées implicitement aux zones
    static var contraintesZones: Set<ExistenceBijection> {
        Grille.zones.map { zone in
            ExistenceBijection(zone.cellules, (1...9).map { $0 }.ensemble)
        }.ensemble
    }
    
    var singletons: Set<ExistenceBijection> {
        contraintes.filter { $0.cardinal == 1 }.ensemble
    }
    
    var paires: Set<ExistenceBijection> {
        contraintes.filter { $0.cardinal == 2 }.ensemble
    }
    
    var triplets: Set<ExistenceBijection> {
        contraintes.filter { $0.cardinal == 3 }.ensemble
    }
    
    /// L'unique bijection dont l'ensemble de cellules est le singleton [cellule]
    /// Peut échouer, retourne alors nil.
    func leSingleton(cellule: Cellule) -> ExistenceBijection? {
        singletons.filter { singleton in singleton.domaine.contains(cellule) }
            .uniqueValeur
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
        var ensembleContraintes = Set<ExistenceBijection>()
        for indexLigne in 0...8 {
            for indexColonne in 0...8 {
                let chiffre = chiffres[indexLigne * 9 + indexColonne]
                if chiffre != 0 { ensembleContraintes.insert(ExistenceBijection([Cellule(indexLigne, indexColonne)], [chiffre]))}
            }
        }
        self = Self(contraintes: ensembleContraintes.union(Puzzle.contraintesZones))
    }
    
}

