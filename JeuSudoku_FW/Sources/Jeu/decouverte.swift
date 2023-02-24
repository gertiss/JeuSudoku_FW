//
//  decouverte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 24/02/2023.
//

import Foundation

extension Puzzle {
    
    /// Les contraintes qui contiennent au moins une des cellules de la zone.
    /// Liste sans doublon, classée par nom.
    func contraintes(dans zone: any UneZone) -> [Presence] {
        var liste = [Presence]()
        for cellule in zone.cellules {
            for contrainte in contraintes {
                if contrainte.contient(cellule: cellule) {
                    liste.append(contrainte)
                }
            }
        }
        return liste.ensemble.array.sorted()
    }
    
    /// Les cellules de la zone qui n'ont aucune contrainte bijective associée.
    /// Liste sans doublon, classée par nom.
    func cellulesSansContrainteBijective(dans zone: any UneZone) -> [Cellule] {
        zone.cellules
            .filter { cellule in
                contraintes(dans: zone)
                    .filter { contrainte in
                        contrainte.contient(cellule: cellule)
                        && contrainte.estUneBijection
                    }
                    .isEmpty
            }
            .ensemble.array.sorted()
    }
}
