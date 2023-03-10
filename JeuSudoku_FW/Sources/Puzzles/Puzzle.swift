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


// MARK: - Etat

// Différentes requêtes permettant de décrire l'état de résolution du puzzle

public extension Puzzle {
    
    /// La valeur de la cellule si elle est résolue, nil sinon.
    func valeur(_ cellule: Cellule) -> Int? {
        let singletons = contraintes(cellule: cellule).filter { $0.type == .singleton1 }
        return singletons.ensemble.uniqueValeur?.valeurs.uniqueElement
    }
    
    /// Indique s'il existe au moins une cellule remplie avec le chiffre.
    func contient(chiffre: Int) -> Bool {
        contraintes.contains(where: {$0.type == .singleton1 && $0.valeurs.uniqueElement == chiffre})
    }

    /// Les contraintes dont la région contient la cellule.
    func contraintes(cellule: Cellule) -> [Presence] {
        contraintes.filter { $0.region.contains(cellule) }
    }
    
    /// Les contraintes dont la valeur contient le chiffre.
    func contraintes(chiffre: Int) -> [Presence] {
        contraintes.filter { $0.valeurs.contains(chiffre) }
    }
    
    func celluleEstResolue(_ cellule: Cellule) -> Bool {
        contraintes(cellule: cellule).contains { $0.type == .singleton1 }
    }

    func cellulesResolues(dans zone: any UneZone) -> [Cellule] {
        zone.cellules.filter { celluleEstResolue($0) }.ensemble.array.sorted()
    }
    
    func cellulesNonResolues(dans zone: any UneZone) -> [Cellule] {
        zone.cellules.filter { !celluleEstResolue($0) }.ensemble.array.sorted()
    }
    
    func valeursResolues(dans zone: any UneZone) -> [Int] {
        cellulesResolues(dans: zone).map { valeur($0)! }.ensemble.array.sorted()
    }

    func valeursAbsentes(dans zone: any UneZone) -> [Int] {
        Int.lesChiffres.subtracting(valeursResolues(dans: zone))
            .array.sorted()
    }
    
    
    func estSingleton1Valide(_ singleton: Presence) -> Bool {
        guard singleton.type == .singleton1 else {
            return false
        }
        let  celluleSingleton = singleton.region.uniqueElement
        let valeurSingleton = singleton.valeurs.uniqueElement
        return celluleSingleton.dependantes.allSatisfy { cellule in
                valeur(cellule) != valeurSingleton
            }
    }
    
    /// Toutes les contraintes singleton1 sont valides
    var estValide: Bool {
        contraintes.allSatisfy { singleton1 in
            estSingleton1Valide(singleton1)
        }
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
        let codeFactice = "012345678901"
        let niveauFactice = "1.0"
        return codeFactice + " " + codeChiffres + "  " + niveauFactice
    }
    
    var codeChiffres: String {
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
        return txtChiffres
    }
    
    /// La représentation sous forme de texte formaté figurant un dessin
    var texteDessin: String {
        CodagePuzzle(code).texteDessin
    }
}
