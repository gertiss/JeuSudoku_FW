//
//  Puzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation
import Modelisation_FW

/// Un Puzzle est défini par un ensemble de contraintes et le problème à résoudre est de réduire cet ensemble à un ensemble équivalent de 81 singletons (une valeur, une cellule)
struct Puzzle: Equatable  {
    
    var contraintes: [Presence]
    
    init(contraintes: [Presence] = []) {
        self.contraintes = contraintes
    }
    
}


// MARK: - Etat

// Différentes requêtes permettant de décrire l'état de résolution du puzzle

extension Puzzle {
    
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

    func celluleEstVide(_ cellule: Cellule) -> Bool {
        !celluleEstResolue(cellule)
    }

    func cellulesResolues(dans zone: any UneZone) -> [Cellule] {
        zone.cellules.filter { celluleEstResolue($0) }
    }
    
    func cellulesNonResolues(dans zone: any UneZone) -> [Cellule] {
        zone.cellules.filter { !celluleEstResolue($0) }
    }
    
    func valeursResolues(dans zone: any UneZone) -> [Int] {
        cellulesResolues(dans: zone).map { valeur($0)! }.ensemble.array.sorted()
    }

    func valeursAbsentes(dans zone: any UneZone) -> [Int] {
        Int.lesChiffres1a9.subtracting(valeursResolues(dans: zone))
            .array.sorted()
    }
    
    /// singleton est bien une cellule - une valeur
    /// il n'est interdit par aucune autre cellule
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
    
    var estResolu: Bool {
        estValide && contraintes.count == 81
    }

}

// MARK: - Codage SudokuExchangeBank

extension Puzzle {
    
    /// Le code pris dans la base SudokuExchange
    /// On suppose que le code est valide s'il provient de la base
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
    
    init(chiffres: String) throws {
        self = Self(code: try CodagePuzzle.codeDepuisSaisie(chiffres))
    }
    
    /// Code avec id et niveaux factices
    var code: String {
        let codeFactice = "012345678901"
        let niveauFactice = "1.0"
        return codeFactice + " " + codeChiffres + "  " + niveauFactice
    }
    
    /// Les 81 chiffres
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
    
    var nbCellulesVidesRestantes: Int {
        81 - contraintes.count
    }
}



extension Puzzle: CodableEnLitteral {
    public typealias Litteral = Puzzle_
    
    public var litteral: Puzzle_ {
        Puzzle_(contraintes: contraintes.map { $0.litteral })
    }
    
    public init(litteral: Puzzle_) {
        self.contraintes = litteral.contraintes.map { Presence(litteral: $0) }
    }
}

// MARK: - Litteral

public struct Puzzle_: UnLitteral, Equatable {
    
    public let contraintes: [Presence_]
}

public extension Puzzle_ {
    
    var chiffres: String {
        Puzzle(litteral: self).codeChiffres
    }
    
    init(chiffres: String) throws {
        let puzzle = try Puzzle(chiffres: chiffres)
        contraintes = puzzle.contraintes.map { $0.litteral }
    }
        
    var codeSwift: String {
        "Puzzle_(contraintes: \(contraintes))"
    }
    
    var texteDessin: String {
        Puzzle(litteral: self).texteDessin
    }
    
    func premierCoup() -> Coup_? {
        Puzzle(litteral: self).premierCoup?.litteral
    }
    
    func plus(_ singleton: Presence_) -> Puzzle_ {
        let singleton = Presence(litteral: singleton)
        return Puzzle(litteral: self).plus(singleton).litteral
    }
    
    func valeur(cellule: Cellule_) -> Int? {
        Puzzle(litteral: self).valeur(Cellule(litteral: cellule))
    }

    var estResolu: Bool {
        Puzzle(litteral: self).estResolu
    }
    
    var nbCellulesVidesRestantes: Int {
        Puzzle(litteral: self).nbCellulesVidesRestantes
    }
    
    var estValide: Bool {
        Puzzle(litteral: self).estValide
    }

    
}

// MARK: - Exemples

public extension Puzzle_ {
    
    static let moyensA = Puzzle.moyensA.map { $0.litteral }
    static let moyensB = Puzzle.moyensB.map { $0.litteral }
    static let moyensC = Puzzle.moyensC.map { $0.litteral }
    static let moyensD = Puzzle.moyensD.map { $0.litteral }
    
    static let difficilesA = Puzzle.difficilesA.map { $0.litteral }
    static let difficilesB = Puzzle.difficilesB.map { $0.litteral }
    static let difficilesC = Puzzle.difficilesC.map { $0.litteral }
    static let difficilesD = Puzzle.difficilesD.map { $0.litteral }
}





