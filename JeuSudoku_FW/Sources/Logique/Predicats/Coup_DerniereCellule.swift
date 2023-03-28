//
//  Coup_DerniereCellule.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 27/03/2023.
//

import Foundation
import Modelisation_FW

/// Le singleton est détecté parce qu'il est la dernière cellule libre en dehors des 8 occupées
struct Coup_DerniereCellule {
    
    let singleton: Presence
    let zone: AnyZone
    let occupees: [Cellule]
}


extension Coup_DerniereCellule: CodableEnLitteral {
    typealias Litteral = Coup_DerniereCellule_

    var litteral: Coup_DerniereCellule_ {
        Coup_DerniereCellule_(singleton: singleton.litteral, zone: zone.litteral, occupees: occupees.litteral)
    }
    
    init(litteral: Coup_DerniereCellule_) {
        singleton = Presence(litteral: litteral.singleton)
        zone = Grille.laZone(litteral: litteral.zone)
        occupees = [Cellule](litteral: litteral.occupees)
    }
}

public struct Coup_DerniereCellule_: UnLitteral {
    
    public let singleton: Presence.Litteral
    public let zone: Zone.Litteral
    public let occupees: [Cellule.Litteral]
    
    public var codeSwift: String {
        "Coup_DerniereCellule_(singleton: \(singleton.codeSwift), zone: \(zone.codeSwift), occupees: \(occupees.codeSwift))"
    }
}

// MARK: - Requêtes

extension Coup_DerniereCellule {
    
    /// Un élément ou zéro
    static func instances(zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        guard let cellule = puzzle.seuleCelluleLibre(dans: zone) else {
            return []
        }
        guard let valeur =  puzzle.seuleValeurAbsente(dans: zone) else {
            return []
        }
        let singleton = Presence([valeur], dans: [cellule])
        let occupees = puzzle.cellulesResolues(dans: zone).sorted()

        return [Self(singleton: singleton, zone: zone, occupees: occupees)]
    }
}
