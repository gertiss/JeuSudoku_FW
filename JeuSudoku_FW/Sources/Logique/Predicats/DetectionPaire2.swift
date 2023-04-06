//
//  SujetPaire2.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 13/03/2023.
//

import Foundation
import Modelisation_FW

/// Il existe une `paire` détectée dans la zone parce qu'il ne reste plus que deux cellules
/// pour 2 valeurs en dehors des occupées et et des éliminées.
/// Les éliminations sont provoquées par les paires éliminatrices.
struct DetectionPaire2 {
    // Sujet
    let paire2: Presence
    // Parametres
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminees: [Cellule]
    let pairesEliminatrices: [[Presence]] // ensemble de couples de singletons
}

extension DetectionPaire2 {
    var valeurs: [Int] {
        paire2.valeurs.array.sorted()
    }
    
    var cellules: [Cellule] {
        paire2.region.array.sorted()
    }
}

extension DetectionPaire2 {
    
    /// Les paires (une ou zéro) dans la zone pour le couple de valeurs.
    static func instances(zone: AnyZone, pour valeurs: (Int, Int), dans puzzle: Puzzle) -> [Self] {
        let eliminations = eliminations(zone: zone, pour: valeurs, dans: puzzle)
        let eliminees = eliminees(zone: zone, par: eliminations, dans: puzzle)
        let pairesEliminatrices = pairesEliminatrices(pour: valeurs, eliminations: eliminations, eliminees: eliminees, dans: puzzle).ensemble.array
        let occupees = zone.cellules.filter { puzzle.celluleEstResolue($0) }
        
        guard let paire2 = paire2(zone: zone, valeurs: valeurs, eliminees: eliminees, occupees: occupees.array) else {
            return []
        }
        
        return [DetectionPaire2(paire2: paire2, zone: zone, occupees: occupees.array.sorted(), eliminees: eliminees.sorted(), pairesEliminatrices: pairesEliminatrices)]
    }
    
    // MARK: Utilitaires pour requêtes
    
    static func eliminations(zone: AnyZone, pour valeurs: (Int, Int), dans puzzle: Puzzle) -> [Int: [EliminationDirecte]] {
        let (x1, x2) = valeurs
        
        let elimination1 = EliminationDirecte.instances(valeur: x1, zone: zone, dans: puzzle)
        let elimination2 = EliminationDirecte.instances(valeur: x2, zone: zone, dans: puzzle)
        return [x1: elimination1, x2: elimination2]
    }
    
    /// les cellules de la zone qui sont éliminées pour les 3 valeurs à la fois
    /// On donne un dico : valeur -> éliminations (celluleEliminee, singletonEliminateur) trouvées pour cette valeur
    /// Remarque : même code que dans Triplet3, à factoriser
    static func eliminees(zone: AnyZone, par eliminations: [Int: [EliminationDirecte]], dans puzzle: Puzzle) -> [Cellule] {
        
        var ensemble = zone.cellules
        for (_, celluleEliminee) in eliminations {
            let eliminees = celluleEliminee.map { $0.eliminee }.ensemble
            ensemble = ensemble.intersection(eliminees)
        }
        return  ensemble.array.sorted()
    }
    
    /// Les couples de singletons présents qui éliminent les 2 valeurs à la fois.
    /// Remarque : c'est presque le même code que pour Triplet3. A factoriser.
    static func pairesEliminatrices(pour valeurs: (Int, Int), eliminations: [Int: [EliminationDirecte]], eliminees: [Cellule], dans puzzle: Puzzle) -> [[Presence]] {
        let (x1, x2) = valeurs
        let (elimination1, elimination2) = (eliminations[x1]!, eliminations[x2]!)
        
        var pairesEliminatrices = [[Presence]]()
        for eliminee in eliminees {
            let e1 = elimination1.filter { $0.eliminee == eliminee }.map { $0.eliminatrice.region.uniqueElement }[0]
            let e2 = elimination2.filter { $0.eliminee == eliminee }.map { $0.eliminatrice.region.uniqueElement }[0]
            let paireEliminatrice = [Presence([x1], dans: [e1]), Presence([x2], dans: [e2])]
            pairesEliminatrices.append(paireEliminatrice)
        }
        return pairesEliminatrices
    }
    
    /// La paire2 bijective découverte
    /// Remarque : c'est presque le même code que pour Triplet3. A factoriser.
    static func paire2(zone: AnyZone, valeurs: (Int, Int), eliminees: [Cellule], occupees: [Cellule]) -> Presence? {
        let (x1, x2) = valeurs
        let cellulesRestantes = zone.cellules.subtracting(eliminees.ensemble.union(occupees))
        if cellulesRestantes.count != 2 {
            return nil
        }
        return Presence([x1, x2], dans: cellulesRestantes)
    }
    
}

extension DetectionPaire2: CodableEnLitteral {
    typealias Litteral = DetectionPaire2_
    
    var litteral: Self.Litteral {
        Self.Litteral(paire2: paire2.litteral, zone: zone.litteral, occupees: occupees.map { $0.litteral }, eliminees: eliminees.map { $0.litteral }, pairesEliminatrices: pairesEliminatrices.map { $0.map { $0.litteral }} )
    }
    
    init(litteral: Self.Litteral) {
        self.paire2 = Presence(litteral: litteral.paire2)
        self.zone = Grille.laZone(litteral: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(litteral: $0) }
        self.eliminees = litteral.eliminees.map { Cellule(litteral: $0) }
        self.pairesEliminatrices = litteral.pairesEliminatrices.map { $0.map { Presence(litteral: $0)} }
    }

}

public struct DetectionPaire2_: UnLitteral, Equatable {
    public let paire2: Presence_
    public let zone: AnyZone_
    public let occupees: [Cellule_]
    public let eliminees: [Cellule_]
    public let pairesEliminatrices: [[Presence_]]
    
    public var codeSwift: String {
        """
DetectionPaire2_(
paire2: \(paire2.codeSwift),
zone: \(zone.codeSwift),
occupees: \(occupees.codeSwift),
eliminees: \(eliminees.codeSwift),
pairesEliminatrices: \(pairesEliminatrices.codeSwift))
"""
    }
}
