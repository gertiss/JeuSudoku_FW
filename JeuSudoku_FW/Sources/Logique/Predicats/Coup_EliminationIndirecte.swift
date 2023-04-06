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
        
        let paires1 = DetectionPaire1.instances(valeur: valeur, ciblant: zone, dejaEliminees: elimineesDirectes, dans: puzzle)
        if paires1.isEmpty { return [] }
        
        let eliminationsIndirectes = EliminationIndirecte.instances(eliminatrices: paires1, zone: zone, dans: puzzle)
        if eliminationsIndirectes.isEmpty { return [] }
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
            eliminationsDirectes: eliminationsDirectes,
            eliminationsIndirectes: eliminationsIndirectes)
        
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
            explicationDesDirectes: eliminationsDirectes.map { $0.litteral },
            explicationDesIndirectes: eliminationsIndirectes.map { $0.litteral}
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

// MARK: - Litteral

public struct Coup_EliminationIndirecte_: UnLitteral, Equatable {
    
    public let singleton: Presence_
    public let zone: AnyZone_
    public let occupees: [Cellule_]
    public let elimineesDirectement: [Cellule_]
    public let elimineesIndirectement: [Cellule_] 
    
    public let explicationDesDirectes: [EliminationDirecte_]
    public let explicationDesIndirectes: [EliminationIndirecte_]
    

    public var codeSwift: String {
        """
Coup_EliminationIndirecte_ (
singleton: \(singleton.codeSwift),
zone: \(zone.codeSwift),
occupees: \(occupees.codeSwift),
elimineesDirectement: \(elimineesDirectement.codeSwift),
elimineesIndirectement: \(elimineesIndirectement.codeSwift),
explicationDesDirectes: \(explicationDesDirectes.codeSwift),
explicationDesIndirectes: \(explicationDesIndirectes.codeSwift))
"""
    }
}
