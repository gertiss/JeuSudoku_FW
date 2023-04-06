//
//  Coup_EliminationDirecte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 26/03/2023.
//

import Foundation
import Modelisation_FW

/// Le singleton est détecté parce qu'il est la dernière cellule restante dans la zone en dehors des éliminées et des occupées
struct Coup_EliminationDirecte {
    // affirmation
    let singleton: Presence
    // explication niveau 0
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminees: [Cellule]
    // explication niveau 1
    let eliminatrices: [Presence]
}

extension Coup_EliminationDirecte {
    
    var valeur: Int {
        singleton.valeurs.uniqueElement
    }
}

// MARK: - Requêtes

extension Coup_EliminationDirecte {

    /// Trouve tous les coups par élimination directe pour la valeur dans la zone.
    /// Un coup au plus.
    /// Explication : il ne reste plus qu'une cellule possible en dehors des éliminées directes et des occupées.
    static func instances(valeur: Int, zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        
        // On cherche la liste des (eliminee, eliminatrice)
        let eliminationsDirectes = EliminationDirecte.instances(valeur: valeur, zone: zone, dans: puzzle)
        // On trouve un coup s'il n'y a plus qu'une cellule restante
        let elimineesDirectes = eliminationsDirectes
            .map { $0.eliminee }.ensemble.array.sorted()
        let occupees = zone.cellules.filter { puzzle.celluleEstResolue($0) }
        let interdites = occupees.union(elimineesDirectes)
        let restantes = zone.cellules.subtracting(interdites)
        guard restantes.cardinal == 1 else { return [] }
        let eliminatrices = eliminationsDirectes
            .map { $0.eliminatrice }.ensemble.array.sorted()

        let singleton = Presence([valeur], dans: [restantes.uniqueElement])
        let fait = Self (
            singleton: singleton,
            zone: zone,
            occupees: occupees.sorted(),
            eliminees: elimineesDirectes,
            eliminatrices: eliminatrices
        )
        
        return [fait]
    }
}

// MARK: - Litteral

extension Coup_EliminationDirecte: CodableEnLitteral {
    typealias Litteral = Coup_EliminationDirecte_
    
    public var litteral: Litteral {
        Litteral(
            singleton: singleton.litteral,
            zone: zone.litteral,
            occupees: occupees.map { $0.litteral }.sorted(),
            eliminees: eliminees.map { $0.litteral }.sorted(),
            eliminatrices: eliminatrices.map { $0.litteral }.sorted()
        )
    }
    
    init(litteral: Litteral) {
        self.singleton = Presence(nom: litteral.singleton)
        self.zone = Grille.laZone(nom: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(nom: $0) }
        self.eliminees = litteral.eliminees.map { Cellule(nom: $0) }
        self.eliminatrices = litteral.eliminatrices.map { Presence(nom: $0) }
    }
}

public struct Coup_EliminationDirecte_: UnLitteral, Equatable {
    public let singleton: Presence_
    public let zone: AnyZone_
    public let occupees: [Cellule_]
    public let eliminees: [Cellule_]
    public let eliminatrices: [Presence_] 

    public var codeSwift: String {
        """
Coup_EliminationDirecte_ (
singleton: \(singleton.codeSwift),
zone: \(zone.codeSwift),
occupees: \(occupees.codeSwift),
eliminees: \(eliminees.codeSwift),
eliminatrices: \(eliminatrices.codeSwift)
)
"""
    }
}


