//
//  Detection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 26/02/2023.
//

import Foundation

// MARK: - Détection de contraintes

public extension Puzzle {
    
    var contrainteDetectee: Presence? {
        if let contrainte = contrainteDetecteeLocalement {
            return contrainte
        }
        
        return contrainteDetecteeParElimination
    }
    
    var contrainteDetecteeLocalement: Presence? {
        for zone in Grille.zones {
            if let singleton  = singleton1DetecteLocalement(dans: zone) {
                return singleton
            }
            if let paire = paire2DetecteeLocalement(dans: zone) {
                return paire
            }
        }
        return nil
    }
    
    var contrainteDetecteeParElimination: Presence? {
        /// Les valeurs non résolues, les plus prometteuses (les plus présentes) d'abord
        let valeurs = Int.lesChiffres
            .filter { nombreDeSingletons1(pour: $0) < 9 }
            .sorted { chiffre1, chiffre2 in
                nombreDeSingletons1(pour: chiffre1) > nombreDeSingletons1(pour: chiffre2)
            }
        /// Les zones non résolues, les plus prometteuses (les plus remplies) d'abord
        let zones = Grille.zones
            .filter { nombreDeSingletons1(dans: $0) < 9 }
            .sorted { zone1, zone2 in
                nombreDeSingletons1(dans: zone1) > nombreDeSingletons1(dans: zone2)
            }
        for valeur in valeurs {
            for zone in zones {
                if let singleton = singleton1DetecteParElimination(pour: valeur, dans: zone) {
                    return singleton
                }
                if let paire = paire1AligneeDetecteeParElimination(pour: valeur, dans: zone) {
                    return paire
                }
            }
        }
        // On n'a trouvé ni singleton1 ni paire1
        return nil
    }
    
    /// Le nombre de contraintes singleton1 dans lequel apparaît la valeur.
    /// Plus ce nombre est grad, plus la valeur est prometteuse pour la recherche.
    /// Lorsqu'il y en a 9, la valeur est entièrement résolue :  on a trouvé toutes ses cellules.
   func nombreDeSingletons1(pour valeur: Int) -> Int {
        contraintes.filter { $0.type == .singleton1 && $0.valeurs == [valeur] }.count
    }
    
    /// Le nombre de contraintes singleton1 dans la zone.
    /// Plus ce nombre est grand, plus cette zone est prometteuse pour la recherche.
    /// Lorsqu'il y en a 9, la zone est entièrement résolue : toutes ses cellules ont été remplies.
    func nombreDeSingletons1(dans zone: any UneZone) -> Int {
        contraintes.filter { $0.type == .singleton1 && $0.region.estDans(zone) }.count
    }
    
}
