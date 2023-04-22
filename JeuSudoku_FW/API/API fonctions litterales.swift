//
//  Communication.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 08/03/2023.
//

import Foundation

/// Fonctions dont les paramètres et la valeur de retour sont des littéraux
///
///
public  extension API {
    
    // MARK: Geometrie
    
    static func nomColonne(index: Int) -> String {
        Colonne(index).nom
    }
 
    static func nomLigne(index: Int) -> String {
        Ligne(index).nom
    }

    // MARK: - Cellule
    
    static func indexLigne(cellule: Cellule_) -> Int {
        Cellule(litteral: cellule).indexLigne
    }
    
    static func indexColonne(cellule: Cellule_) -> Int {
        Cellule(litteral: cellule).indexColonne
    }
    
    
    // MARK: - Presence
    
    static func valeurs(presence: Presence_) -> [Int] {
        Presence(litteral: presence).valeurs.array.sorted()
    }
    
    static func cellules(presence: Presence_) -> [Cellule_] {
        Presence(litteral: presence).region.map { $0.nom }.sorted()
    }
    
    // MARK: - Singleton
    
    static func estSingleton(presence: Presence_) -> Bool {
        Presence(litteral: presence).type == .singleton1
    }
    
    static func valeur(singleton: Presence_) -> Int {
        Presence(litteral: singleton).valeurs.uniqueElement
    }
    
    static func cellule(singleton: Presence_) -> Cellule_ {
        Presence(litteral: singleton).region.map { $0.nom }.uniqueElement
    }
    
    // MARK: - Zone
    
    static func type(zone: AnyZone_) -> TypeZone {
        Grille.laZone(litteral: zone).type
    }
    
    static func cellules(zone: AnyZone_) -> [Cellule_] {
        Grille.laZone(litteral: zone).cellules.map { $0.litteral }
    }
    
    static func cellule_(ligne: Int, colonne: Int) -> Cellule_ {
        Cellule(ligne, colonne).litteral
    }
    
    
    // MARK: - Puzzle
    
    static func valeursDesCellules(puzzle: Puzzle_) -> [Cellule_: Int] {
        var dico = [Cellule_: Int]()
        for singleton in Puzzle(litteral: puzzle).contraintes {
            let singleton_ = singleton.litteral
            dico[cellule(singleton: singleton_)] = valeur(singleton: singleton_)
        }
        return dico
    }
    
    
}

