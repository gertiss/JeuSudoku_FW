//
//  EliminationIndirecte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 16/03/2023.
//

import Foundation
import Modelisation_FW

/// Les `eliminees` sont des cellules vides  éliminées indirectement par les `eliminatrices` dans la zone.
/// Les éliminatrices sont des paires1 de même valeur.
struct EliminationIndirecte {
    let eliminees: [Cellule]
    let zone: AnyZone
    let eliminatrices: [DetectionPaire1]
    
    var valeur: Int {
        assert(eliminatrices.count > 0)
        let valeurs = eliminatrices.map { $0.valeur }.ensemble
        assert(valeurs.count == 1)
        return valeurs.array[0]
    }
}


// MARK: - Requêtes

extension EliminationIndirecte {
    
    /// Trouve toutes les cellules vides éliminées dans la zone par les paires1 éliminatrices (au moins une)
    /// Les paires1 doivent avoir la même valeur.
    /// Résultat : une seule instance au plus.
    /// L'appel est fait avec les paires1 connues. Il faut les chercher avant, avec Paire1 :
    /// `Paire1.instances(valeur: valeur, zone: zone, dans: puzzle)`
    static func instances(eliminatrices: [DetectionPaire1], zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        let valeurs = eliminatrices.map { $0.valeur }.ensemble
        guard valeurs.count == 1 else {
            return []
        }
        var eliminees = Set<Cellule>()
        for p in eliminatrices {
            let elims = puzzle
                .cellulesExternesEliminees(par: p.paire1, pour: p.paire1.valeurs.uniqueElement)
                .intersection(zone.cellules)
                .filter { puzzle.celluleEstVide($0) }
            eliminees = eliminees.union(elims)
        }
        return [Self(eliminees: eliminees.array.sorted(), zone: zone, eliminatrices: eliminatrices)]
    }
}

// MARK: - Litteral


extension EliminationIndirecte: CodableEnLitteral {
    typealias Litteral = EliminationIndirecte_
    
    public var litteral: Litteral {
        Self.Litteral(eliminees: eliminees.map {$0.nom}, zone: zone.nom, eliminatrices: eliminatrices.map { $0.litteral })
    }
    
    init(litteral: Litteral) {
        self.eliminees = litteral.eliminees.map { Cellule(nom: $0) }
        self.zone = Grille.laZone(nom: litteral.zone)
        self.eliminatrices = litteral.eliminatrices.map { DetectionPaire1(litteral: $0) }
    }
}

public struct EliminationIndirecte_: UnLitteral, Equatable {
    public let eliminees: [Cellule_]
    public let zone: AnyZone_
    public let eliminatrices: [DetectionPaire1_]
    
    public var codeSwift: String {
        "EliminationIndirecte_(eliminees: \(eliminees.codeSwift), zone: \(zone.codeSwift), eliminatrices: \(eliminatrices.codeSwift))"
    }
}
