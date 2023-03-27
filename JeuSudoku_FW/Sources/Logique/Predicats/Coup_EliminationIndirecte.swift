//
//  Coup_EliminationIndirecte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 17/03/2023.
//

import Foundation
import Modelisation_FW

/// Le singleton est détecté parce qu'il est la dernière cellule restante dans la zone en dehors des éliminées et des occupées. Certaines éliminations sont indirectes par paire1.
struct Coup_EliminationIndirecte {
    let singleton: Presence
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminationsDirectes: [EliminationDirecte]
    let eliminationsIndirectes: [EliminationIndirecte]
}

extension Coup_EliminationIndirecte {
    
    var valeur: Int {
        singleton.valeurs.uniqueElement
    }
}

// MARK: - Requêtes

extension Coup_EliminationIndirecte {
    
    /// Trouve tous les coups par élimination indirecte pour la valeur dans la zone.
    /// Un coup au plus.
    static func instances(valeur: Int, zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        
        let eliminationsDirectes = EliminationDirecte.instances(valeur: valeur, zone: zone, dans: puzzle)
        let elimineesDirectes = eliminationsDirectes.map { $0.eliminee }.sorted()
        
        let paires1 = DetectionPaire1.instances(valeur: valeur, ciblant: zone, dejaEliminees: elimineesDirectes, dans: puzzle).sorted()
        if paires1.isEmpty { return [] }
        
        let eliminationsIndirectes = EliminationIndirecte.instances(eliminatrices: paires1, zone: zone, dans: puzzle).sorted()
        if eliminationsIndirectes.isEmpty { return [] }
        assert(eliminationsIndirectes.cardinal == 1)
        let occupees = zone.cellules.filter { puzzle.celluleEstResolue($0) }

        let elimineesIndirectes = eliminationsIndirectes.flatMap { $0.eliminees }.sorted()
        let interdites = occupees.union(elimineesDirectes).union(elimineesIndirectes)
        let restantes = zone.cellules.subtracting(interdites)
        guard restantes.cardinal == 1 else { return [] }
        
        let singleton = Presence([valeur], dans: [restantes.uniqueElement])
        let fait = Self (
            singleton: singleton,
            zone: zone,
            occupees: occupees.sorted(),
            eliminationsDirectes: eliminationsDirectes.sorted(),
            eliminationsIndirectes: eliminationsIndirectes.sorted())
        
        return [fait]
    }
}

extension Coup_EliminationIndirecte: CodableEnLitteral {
    typealias Litteral = Coup_EliminationIndirecte_
    
    public var litteral: Self.Litteral {
        Litteral(
            singleton: singleton.nom,
            zone: zone.nom,
            occupees: occupees.map { $0.nom }.sorted(),
            elimineesDirectement: eliminationsDirectes.map { $0.eliminee.nom }.sorted(),
            elimineesIndirectement: eliminationsIndirectes.flatMap { $0.eliminees }.map { $0.nom }.sorted(),
            explicationDesDirectes: eliminationsDirectes.map { $0.litteral }.sorted(),
            explicationDesIndirectes: eliminationsIndirectes.map { $0.litteral}.sorted()
        )
    }
    
    init(litteral: Litteral) {
        self.singleton = Presence(nom: litteral.singleton)
        self.zone = Grille.laZone(nom: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(nom: $0) }
        self.eliminationsDirectes = litteral.explicationDesDirectes.map { EliminationDirecte(litteral: $0) }
        self.eliminationsIndirectes = litteral.explicationDesIndirectes.map { EliminationIndirecte(litteral: $0) }
    }

}

public struct Coup_EliminationIndirecte_: UnLitteral {
    
    public let singleton: String
    public let zone: String
    public let occupees: [String]
    public let elimineesDirectement: [String]
    public let elimineesIndirectement: [String]
    
    public let explicationDesDirectes: [EliminationDirecte_]
    public let explicationDesIndirectes: [EliminationIndirecte_]
    

    public var codeSwift: String {
        """
Coup_EliminationIndirecte_ (
singleton: \(singleton),
zone: \(zone),
occupees: \(occupees),
elimineesDirectement: \(elimineesDirectement),
elimineesIndirectement: \(elimineesIndirectement),
explicationDesDirectes: \(explicationDesDirectes),
explicationDesIndirectes: \(explicationDesIndirectes))
"""
    }
}
