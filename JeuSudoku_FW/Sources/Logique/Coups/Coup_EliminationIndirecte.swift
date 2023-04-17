//
//  Coup_EliminationIndirecte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 17/03/2023.
//

import Foundation
import Modelisation_FW

/// Le singleton est détecté parce qu'il est la dernière cellule restante dans la zone en dehors des éliminées et des occupées. Certaines éliminations sont indirectes par paire1.
struct Coup_EliminationIndirecte : UnCoup {
    
    let singleton: Presence
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminationsDirectes: [EliminationDirecte]
    let eliminationIndirecte: EliminationIndirecte
}

extension Coup_EliminationIndirecte {
    
    var valeur: Int {
        singleton.valeurs.uniqueElement
    }
    
    var nombreDeCellulesVides: Int {
        9 - occupees.count
    }
    
    var eliminatrices: [Presence] {
        eliminationsDirectes.map { $0.eliminatrice }.ensemble.array.sorted()
    }
    
    var signature: SignatureCoup {
        .init(typeCoup: .eliminationIndirecte, typeZone: zone.type.rawValue, nbDirects: eliminatrices.count, nbIndirects: eliminationIndirecte.eliminatrices.count, nbPaires2: 0, nbTriplets3: 0)
    }
    var typeCoup: TypeCoup { .eliminationIndirecte }

    var typeZone: TypeZone { zone.type }
    
    var indirecte: EliminationIndirecte? {
        eliminationIndirecte
    }
    
    var explication: String {
        """
On joue \(singleton.litteral) dans \(zone.texteLaZone).
En effet :
\(eliminationIndirecte.eliminatrices.map { $0.explication }.joined(separator: "\n"))
Cela élimine \(eliminationIndirecte.eliminees.litteral) pour la valeur \(valeur) dans \(zone.texteLaZone).
De plus on élimine \(eliminationsDirectes.map { $0.eliminee.litteral }) par \(eliminationsDirectes.map { $0.eliminatrice.litteral }.ensemble.array.sorted()).
La seule cellule libre restante pour \(valeur) est \(singleton.region.uniqueElement.litteral).
"""
    }
    
    var rolesCellules: [Cellule_: Coup_.RoleCellule] {
        var dico = [Cellule_: Coup_.RoleCellule]()
        dico[singleton.uniqueCellule.litteral] = .cible
        // Eliminations directes
        for elimineeDirecte in eliminationsDirectes.map({ $0.eliminee }) {
            dico[elimineeDirecte.litteral] = .eliminee
        }
        for eliminatriceDirecte in eliminatrices.map({ $0.uniqueCellule }) {
            dico[eliminatriceDirecte.litteral] = .eliminatrice
        }
        // Eliminations indirectes
        for elimineeIndirecte in eliminationIndirecte.eliminees {
            dico[elimineeIndirecte.litteral] = .eliminee
        }
        let eliminatricesIndirectes = eliminationIndirecte.eliminatrices.flatMap { $0.eliminatrices }
        for e in eliminatricesIndirectes {
            dico[e.litteral] = .eliminatrice
        }
        let auxiliaires = eliminationIndirecte.eliminatrices.flatMap{ $0.paire1.region }
        for auxiliaire in auxiliaires {
            dico[auxiliaire.litteral] = .auxiliaire
        }
        return dico
    }
}

// MARK: - Requêtes

extension Coup_EliminationIndirecte {
    
    /// Trouve tous les coups par élimination indirecte pour la valeur dans la zone.
    /// Un coup au plus.
    static func instances(valeur: Int, zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        
        let eliminationsDirectes = EliminationDirecte.instances(valeur: valeur, zone: zone, dans: puzzle)
        
        let elimineesDirectes = eliminationsDirectes.map { $0.eliminee }.ensemble.array.sorted()
        let eliminationsDirectesSuffisantes = eliminationsDirectes.avecMinimisation(cibles: elimineesDirectes.ensemble, dans: puzzle)
        let paires1 = DetectionPaire1.instances(valeur: valeur, ciblant: zone, dejaEliminees: elimineesDirectes, dans: puzzle)
        if paires1.isEmpty { return [] }
        
        let eliminationsIndirectes = EliminationIndirecte.instances(eliminatrices: paires1, zone: zone, dans: puzzle)
        if eliminationsIndirectes.isEmpty { return [] }
        assert(eliminationsIndirectes.count == 1)
        let eliminationIndirecte = eliminationsIndirectes[0]
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
            eliminationsDirectes: eliminationsDirectesSuffisantes,
            eliminationIndirecte: eliminationIndirecte)
        
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
            elimineesIndirectement: eliminationIndirecte.eliminees.map { $0.nom }.sorted(),
            explicationDesDirectes: eliminationsDirectes.map { $0.litteral }
                .sorted(by: { e1, e2 in
                    e1.eliminee < e2.eliminee
                }),
            explicationDesIndirectes: eliminationIndirecte.litteral
        )
    }
    
    init(litteral: Litteral) {
        self.singleton = Presence(nom: litteral.singleton)
        self.zone = Grille.laZone(nom: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(nom: $0) }
        self.eliminationsDirectes = litteral.explicationDesDirectes.map { EliminationDirecte(litteral: $0) }
        self.eliminationIndirecte = EliminationIndirecte(litteral: litteral.explicationDesIndirectes)
    }

}

public extension Coup_EliminationIndirecte_ {
    var signature: SignatureCoup {
        Coup_EliminationIndirecte(litteral: self).signature
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
    public let explicationDesIndirectes: EliminationIndirecte_
    

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
