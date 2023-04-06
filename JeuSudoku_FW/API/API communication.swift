//
//  Communication.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 08/03/2023.
//

import Foundation



// MARK: - Cellule

public func indexLigne(cellule: Cellule_) -> Int {
    Cellule(litteral: cellule).indexLigne
}

public func indexColonne(cellule: Cellule_) -> Int {
    Cellule(litteral: cellule).indexColonne
}


// MARK: - Presence

public func valeurs(presence: Presence_) -> [Int] {
    Presence(litteral: presence).valeurs.array.sorted()
}

public func cellules(presence: Presence_) -> [Cellule_] {
    Presence(litteral: presence).region.map { $0.nom }.sorted()
}

// MARK: - Singleton

public func estSingleton(presence: Presence_) -> Bool {
    Presence(litteral: presence).type == .singleton1
}

public func valeur(singleton: Presence_) -> Int {
    Presence(litteral: singleton).valeurs.uniqueElement
}

public func cellule(singleton: Presence_) -> Cellule_ {
    Presence(litteral: singleton).region.map { $0.nom }.uniqueElement
}

// MARK: - Zone

public func type(zone: AnyZone_) -> TypeZone {
    Grille.laZone(litteral: zone).type
}

public func cellules(zone: AnyZone_) -> [Cellule_] {
    Grille.laZone(litteral: zone).cellules.map { $0.litteral }
}


// MARK: - Puzzle

public func valeursDesCellules(puzzle: Puzzle_) -> [Cellule_: Int] {
    var dico = [Cellule_: Int]()
    for singleton in Puzzle(litteral: puzzle).contraintes {
        let singleton_ = singleton.litteral
        dico[cellule(singleton: singleton_)] = valeur(singleton: singleton_)
    }
    return dico
}




