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
    let singleton: Presence
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminees: [Cellule]
    let eliminatrices: [Presence]
    /*
     Mémoriser eliminationsDirectes n'est pas la meilleure chose à faire.
     L'explication doit minimiser à la fois la liste des cellules éliminées et la liste des cellules éliminatrices
     let eliminees = [Cellule]
     let eliminatrices = [Cellule]
     */
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

public struct Coup_EliminationDirecte_: UnLitteral {
    public let singleton: String
    public let zone: String
    public let occupees: [String]
    public let eliminees: [String]
    public let eliminatrices: [String]

    public var codeSwift: String {
        """
Coup_EliminationDirecte_ (
singleton: \(singleton.debugDescription),
zone: \(zone.debugDescription),
occupees: \(occupees),
eliminees: \(eliminees),
eliminatrices: \(eliminatrices)
)
"""
    }
}


