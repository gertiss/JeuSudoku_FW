//
//  Detection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 26/02/2023.
//

import Foundation

// MARK: - Détection de contraintes par élimination

/// On essaye de trouver des contraintes contenant une valeur dans une zone,
/// après élimination des cellules pour cette valeur.

public extension Puzzle {
    
    /// Une seule cellule restante après élimination directe, sinon nil
    func singleton1DetecteParEliminationDirecte(pour valeur: Int, dans region: Region, zone: any UneZone) -> Presence? {
        let eliminees = cellulesEliminees(pour: valeur)
        let restantes = region.subtracting(eliminees)
        assert(!restantes.contains { celluleEstResolue($0) })
        guard restantes.count == 1 else {
            return nil
        }
        let singleton = Presence([valeur], dans: restantes)
        assert(singleton.type == .singleton1)
        assert(!contraintes.contains(singleton))
        let demonstration = Demonstration(presence: singleton, zone: zone, occupees: cellulesResolues(dans: zone), eliminatrices: [], eliminees: eliminees.array.sorted(), auxiliaires: [])
        let coup = CoupOld(singleton, zone: zone, methode: .direct, demonstration: demonstration)
        var todo = "retourner le coup et pas la présence. Compléter éliminatrices"
        return singleton
    }
 
    /// Deux seules cellules restantes alignées après élimination
    /// Mais on se limite aux paires "utiles", susceptible d'éliminer de nouvelles cellules.
    func paire1AligneeDetecteeParElimination(pour valeur: Int, dans zone: any UneZone) -> Presence? {
        let eliminees = cellulesEliminees(pour: valeur)
        let restantes = zone.cellules.subtracting(eliminees)
        assert(!restantes.contains { celluleEstResolue($0) })
       guard restantes.count == 2 && restantes.estIncluseDansUnAlignement else {
            return nil
        }
        let paire1 = Presence([valeur], dans: restantes)
        assert(paire1.type == .paire1)
        if contraintes.contains(paire1)  {
            return nil
        }
        return paire1
    }
    
    func paires1AligneesDetecteesParElimination(pour valeur: Int) -> [Presence] {
        var liste = [Presence]()
        for zone in Grille.zones {
            if let paire = paire1AligneeDetecteeParElimination(pour: valeur, dans: zone) {
                liste.append(paire)
            }
        }
        return liste.ensemble.array.sorted()
    }
}
