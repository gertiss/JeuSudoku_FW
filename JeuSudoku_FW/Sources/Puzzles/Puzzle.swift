//
//  Puzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Un Puzzle est défini par un ensemble de contraintes et le problème à résoudre est de réduire cet ensemble à un ensemble équivalent de 81 singletons (une valeur, une cellule)
public struct Puzzle: Equatable  {
    
    public var contraintes: [Presence]
    
    public init(contraintes: [Presence] = []) {
        self.contraintes = contraintes
    }
    
}

public extension Puzzle {
    
    func contraintes(_ cellule: Cellule) -> [Presence] {
        contraintes.filter { $0.contient(cellule: cellule) }
    }
}

// MARK: - Codage SudokuExchangeBank

public extension Puzzle {
    
    init(code: String) {
        let codage = CodagePuzzle(code)
        let chiffres = codage.chiffres
        var contraintes = [Presence]()
        var curseur = 0
        for indexLigne in 0...8 {
            for  indexColonne in 0...8 {
                let chiffre = chiffres[curseur]
                if chiffre != 0 {
                    contraintes.append(Presence([chiffre], dans: Region([Cellule(indexLigne, indexColonne)])))
                }
                curseur += 1
            }
        }
        self.contraintes = contraintes
    }
    
    init(chiffres: String) {
        self = Self(code: CodagePuzzle.codeDepuisSaisie(chiffres))
    }
    
    /// Code avec id et niveaux factices
    var code: String {
        let singletons = contraintes.filter { $0.type == .singleton1 }
        var dico = [Cellule: Int]()
        singletons.forEach {
            dico[$0.region.uniqueElement] = $0.valeurs.uniqueElement
        }
        var txtChiffres = ""
        for indexLigne in 0...8 {
            for  indexColonne in 0...8 {
                let cellule = Cellule(indexLigne, indexColonne)
                let valeur = dico[cellule] ?? 0
                txtChiffres += "\(valeur)"
            }
            
        }
        let codeFactice = "012345678901"
        let niveauFactice = "1.0"
        return codeFactice + " " + txtChiffres + "  " + niveauFactice
    }
    
    /// La représentation sous forme de texte formaté figurant un dessin
    var texteDessin: String {
        CodagePuzzle(code).texteDessin
    }
}

