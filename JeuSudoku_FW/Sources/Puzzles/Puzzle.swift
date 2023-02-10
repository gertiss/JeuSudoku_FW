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
public struct Puzzle: Testable {
    
    public let contraintes: [PresenceValeurs]
    
    public init(contraintes: [PresenceValeurs]) {
        self.contraintes = contraintes
    }
    
    public var description: String {
        "Puzzle(code: \(code))"
    }
}

public extension Puzzle {
    
    
    /// Les 27 contraintes de bijection toujours associées implicitement aux zones
    var contraintesBijectionZone: [PresenceValeurs]  {
        Grille.zones.map { zone in
            PresenceValeurs([1, 2, 3, 4, 5, 6, 7, 8, 9],
                            dans: zone.cellules
                )
        }
    }
    
    var singletons: [PresenceValeurs] {
        contraintes.filter { $0.region.count == 1 && $0.valeurs.count == 1 }
            .sorted()
    }
    
    var paires: [PresenceValeurs] {
        contraintes.filter { $0.region.count == 2 && $0.valeurs.count == 2  }
            .sorted()
    }
    
    var triplets: [PresenceValeurs] {
        contraintes.filter { $0.region.count == 3 && $0.valeurs.count == 3  }
            .sorted()
    }
    
    /// L'unique bijection dont l'ensemble de cellules est le singleton [cellule]
    /// Peut échouer, retourne alors nil.
    func leSingleton(cellule: Cellule) -> PresenceValeurs? {
        singletons.filter{ $0.region.contains(cellule) }.first
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
    init(code: String) {
        let codage = CodagePuzzle(code)
        let chiffres = codage.chiffres
        var listeContraintes = [PresenceValeurs]()
        
        let puzzle = Puzzle(contraintes: [])
        for indexLigne in 0...8 {
            for indexColonne in 0...8 {
                let chiffre = chiffres[indexLigne * 9 + indexColonne]
                if chiffre == 0 { continue }
                listeContraintes.append(
                    PresenceValeurs(
                        [chiffre],
                        dans: [Cellule(indexLigne, indexColonne)]))}
        }
        self = Self(contraintes: listeContraintes + puzzle.contraintesBijectionZone)
    }
    
    init(chiffres: String) {
        let chiffresCompacts = chiffres
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: " ", with: "")
        let code = "012345678901" + " " + chiffresCompacts + "  " + "1.0"
        self = Self(code: code)
    }
    
    /// On peut recréer le Puzzle par Puzzle(chiffres: chiffres)
    var chiffres: String {
        singletons.map { $0.valeurs.first!.description}
            .joined()
    }
    
    /// On peut recréer le Puzzle par Puzzle(code: code)
    var code: String {
        "012345678901" + " " + chiffres + "  " + "1.0"
    }
    
    var chiffresAvecPresentation: String {
        var lignes = [String]()
        var flux = chiffres.map { String($0) }
        for _ in 0...9 {
            let ligne = flux.prefix(9).map{$0}.joined()
            print(ligne)
            flux = flux.suffix(flux.count - 9)
            lignes.append(ligne)
        }
        return lignes.joined(separator: "\n")
    }
    
}

public extension CodagePuzzle {
    
    /// Le puzzle créé à partir du code. On oublie id et niveau.
    /// On suppose le code correct.
    var puzzle: Puzzle {
        Puzzle(code: code)
    }

}
