//
//  RechercheCoup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 05/04/2023.
//

import Foundation

extension Puzzle {
    
    var premierCoup: Coup? {
        let valeurs = valeursClasseesParFrequence
        let zones = zonesClasseesParRemplissage
        
        for valeur in valeurs {
            for zone in zones {
                let coups = Coup_EliminationDirecte.instances(valeur: valeur, zone: zone, dans: self)
                if coups.count == 1 {
                    return .eliminationDirecte(coups[0])
                }
            }
        }
        return nil
    }
}
