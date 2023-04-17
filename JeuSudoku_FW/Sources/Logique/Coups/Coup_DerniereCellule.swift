//
//  Coup_DerniereCellule.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 27/03/2023.
//

import Foundation
import Modelisation_FW

/// Le singleton est détecté parce qu'il est la dernière cellule libre en dehors des 8 occupées
struct Coup_DerniereCellule: Equatable, UnCoup {
    
    let singleton: Presence
    let zone: AnyZone
    let occupees: [Cellule]
    
    static func == (lhs: Coup_DerniereCellule, rhs: Coup_DerniereCellule) -> Bool {
        lhs.litteral == rhs.litteral
    }
    
    
}

extension Coup_DerniereCellule {
    
    var signature: SignatureCoup {
        .init(typeCoup: .derniereCellule, typeZone: zone.type.rawValue, nbDirects: 0, nbIndirects: 0, nbPaires2: 0, nbTriplets3: 0)
    }
    
    var typeCoup: TypeCoup { .derniereCellule }
    
    var typeZone: TypeZone {
        zone.type
    }
    
    var eliminatrices: [Presence] {
        []
    }
    
    var indirecte: EliminationIndirecte? { nil }
    
    var explication: String {
        """
On joue \(singleton.litteral) dans \(zone.texteLaZone).
C'est la dernière cellule libre.
"""
    }

    var rolesCellules: [Cellule_: Coup_.RoleCellule] {
        [singleton.region.uniqueElement.litteral: .cible]
    }

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

public struct Coup_DerniereCellule_: UnLitteral, Equatable {
    
    public let singleton: Presence_ // Presence
    public let zone: AnyZone_ // Zone
    public let occupees: [Cellule_] // [Cellule]
    
    public var codeSwift: String {
        "Coup_DerniereCellule_(singleton: \(singleton.codeSwift), zone: \(zone.codeSwift), occupees: \(occupees.codeSwift))"
    }
}

public extension Coup_DerniereCellule_ {
    var signature: SignatureCoup {
        Coup_DerniereCellule(litteral: self).signature
    }
    
    var explication: String {
        Coup_DerniereCellule(litteral: self).explication
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
