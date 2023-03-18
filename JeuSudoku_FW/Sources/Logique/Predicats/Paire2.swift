//
//  SujetPaire2.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 13/03/2023.
//

import Foundation

/// Il existe une `paire` détectée dans la zone parce qu'il ne reste plus que deux cellules
/// pour 2 valeurs en dehors des occupées et et des éliminées
struct Paire2 {
    // Sujet
    let paire: Presence
    // Parametres
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminees: [Cellule]
    let pairesEliminatrices: [[Presence]]
}

extension Paire2 {
    var valeurs: [Int] {
        paire.valeurs.array.sorted()
    }
    
    var cellules: [Cellule] {
        paire.region.array.sorted()
    }
}

extension Paire2 {
    
    /// Les paires (une ou zéro) dans la zone pour le couple de valeurs.
    static func instances(zone: AnyZone, pour valeurs: (Int, Int), dans puzzle: Puzzle) -> [Self] {
        let eliminations = eliminations(zone: zone, pour: valeurs, dans: puzzle)
        let eliminees = eliminees(zone: zone, par: eliminations, dans: puzzle)
        let tripletsEliminateurs = pairesEliminatrices(pour: valeurs, eliminations: eliminations, eliminees: eliminees, dans: puzzle)
        let occupees = zone.cellules.filter { puzzle.celluleEstResolue($0) }
        
        guard let paire2 = paire2(zone: zone, valeurs: valeurs, eliminees: eliminees, occupees: occupees.array) else {
            return []
        }
        
        return [Paire2(paire: paire2, zone: zone, occupees: occupees.array.sorted(), eliminees: eliminees.sorted(), pairesEliminatrices: tripletsEliminateurs)]
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
    
    /// Les triplets de singletons présents qui éliminent les 3 valeurs à la fois.
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
