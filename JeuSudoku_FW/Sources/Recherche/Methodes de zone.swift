//
//  Detection locale.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 24/02/2023.
//

import Foundation

// MARK: - Méthodes de zone

/// Ces propriétés se détectent "visuellement", localement, en observant seulement la zone.
/// Elles n'utilisent pas les rayons venant des autres zones.
/// Elles ont un unique paramètre : `zone`.

extension Puzzle {
 
    /// Les contraintes dont la région intersecte la zone.
    /// Liste sans doublon, classée par nom.
    /// Utilisé par `Coup_DerniereCellule`
    func contraintes(intersectant zone: any UneZone) -> [Presence] {
        contraintes.filter { $0.region.intersecte(zone) }
            .ensemble.array.sorted()
    }
    
    /// Utilisé par `Coup_DerniereCellule`
    func contraintesBijectivesIntersectant(_ zone: any UneZone) -> [Presence] {
        contraintes(intersectant: zone).filter { $0.estUneBijection }
    }
    
    /// Utilisé par `Coup_DerniereCellule`
    func contraintesBijectivesIncluses(dans zone: any UneZone) -> [Presence] {
        contraintesBijectivesIntersectant(zone).filter { $0.region.isSubset(of: zone.cellules) }
    }
    
    /// Les valeurs qui apparaissent dans les contraintes bijectives incluses dans la zone.
    /// Liste sans doublon, classée par valeur.
    /// Plus le cardinal de cette valeur est élevé, plus la zone est "prometteuse" pour découvrir une contrainte
    /// Utilisé par `Coup_DerniereCellule`
   func valeursPresentes(dans zone: any UneZone) -> [Int] {
        var ensemble = Set<Int>()
       for contrainte in contraintesBijectivesIncluses(dans: zone) {
                ensemble = ensemble.union(contrainte.valeurs)
        }
        return ensemble.array.sorted()
    }
    
    /// Les cellules de la zone qui n'ont aucune contrainte bijective associée incluse dans la zone.
    /// Liste sans doublon, classée par nom.
    /// Remarque : une cellule peut aussi appartenir à une contrainte bijective d'une autre zone.
    /// Il faudra alors faire l'intersection des bijections
    /// Utilisé par `Coup_DerniereCellule`
    func cellulesSansContrainteBijective(dans zone: any UneZone) -> [Cellule] {
        zone.cellules
            .filter { cellule in
                contraintesBijectivesIntersectant(zone)
                    .filter { $0.contient(cellule: cellule) }
                    .isEmpty
            }
        // sans doublon, classement par nom
            .ensemble.array.sorted()
    }
    
    /// "libre" = sans contrainte bijective dans la zone
    /// Utilisé par `Coup_DerniereCellule`
    func seuleCelluleLibre(dans zone: any UneZone) -> Cellule? {
        let libres = cellulesSansContrainteBijective(dans: zone)
        return libres.count == 1 ? libres[0] : nil
    }
    
    
    /// "absente" = sans contrainte bijective dans la zone.
    /// Lorsque la réponse est non nil, on peut noter un singleton1 avec cette valeur.
    /// Utilisé par `Coup_DerniereCellule`
    func seuleValeurAbsente(dans zone: any UneZone) -> Int? {
        let absentes = Int.lesChiffres1a9.subtracting(valeursPresentes(dans: zone))
        return absentes.count == 1 ? absentes.first! : nil
    }
    
    /// Le nombre de contraintes singleton1 dans la zone (c'est-à-dire le nombre de cellules remplies).
    /// Plus ce nombre est grand, plus cette zone est prometteuse pour la recherche.
    /// Lorsqu'il y en a 9, la zone est entièrement résolue : toutes ses cellules ont été remplies.
    func nombreDeSingletons1(dans zone: any UneZone) -> Int {
        contraintes.filter { $0.type == .singleton1 && $0.region.estIncluseDans(zone) }.count
    }

    
}
