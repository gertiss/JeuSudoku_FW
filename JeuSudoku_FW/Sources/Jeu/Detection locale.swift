//
//  Detection locale.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 24/02/2023.
//

import Foundation

// MARK: - Détection locale dans une zone

/// Ces propriétés se détectent "visuellement", localement, en observant seulement la zone.
/// Elles n'utilisent pas les rayons venant des autres zones.
/// On peut détecter un singleton1 ou une paire2

extension Puzzle {
 
    /// Singleton1 détecté localement dans la zone : seule cellule libre, seule valeur absente.
    /// On peut "remplir" la cellule par la valeur.
    /// C'est lorsqu'il ne reste plus qu'une case libre dans une zone.
    func singleton1DetecteLocalement(dans zone: any UneZone) -> Presence? {
        guard let cellule = seuleCelluleLibre(dans: zone) else {
            return nil
        }
        guard let valeur =  seuleValeurAbsente(dans: zone) else {
            return nil
        }
        let contrainte = Presence([valeur], dans: [cellule])
        assert(contrainte.estUneBijection)
        assert(contrainte.type == .singleton1)
        return contrainte
    }
    
    /// Paire2 détectée localement dans la zone : deux  cellules libres, deux valeurs absentes.
    /// Mais on ne retient que les alignements.
    /// Les paires2 obliques ont provoqué des bugs.
    func paire2DetecteeLocalement(dans zone: any UneZone) -> Presence? {
        guard let deuxCellules = deuxSeulesCellulesLibres(dans: zone) else {
            return nil
        }
        guard let deuxValeurs = deuxSeulesValeurAbsentes(dans: zone) else {
            return nil
        }
        let contrainte = Presence(deuxValeurs.ensemble, dans: deuxCellules.ensemble)
        guard contrainte.region.estIncluseDansUnAlignement else {
            return nil
        }
        assert(contrainte.estUneBijection)
        assert(contrainte.type == .paire2)
        return contrainte
    }

    /// Les contraintes dont la région intersecte la zone.
    /// Liste sans doublon, classée par nom.
    func contraintes(intersectant zone: any UneZone) -> [Presence] {
        contraintes.filter { $0.region.intersecte(zone) }
            .ensemble.array.sorted()
    }
    
    func contraintesBijectivesIntersectant(_ zone: any UneZone) -> [Presence] {
        contraintes(intersectant: zone).filter { $0.estUneBijection }
    }
    
    func contraintesBijectivesIncluses(dans zone: any UneZone) -> [Presence] {
        contraintesBijectivesIntersectant(zone).filter { $0.region.isSubset(of: zone.cellules) }
    }
    
    /// Les valeurs qui apparaissent dans les contraintes bijectives incluses dans la zone.
    /// Liste sans doublon, classée par valeur.
    /// Plus le cardinal de cette valeur est élevé, plus la zone est "prometteuse" pour découvrir une contrainte
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
    func seuleCelluleLibre(dans zone: any UneZone) -> Cellule? {
        let libres = cellulesSansContrainteBijective(dans: zone)
        return libres.count == 1 ? libres[0] : nil
    }
    
    /// "libre" = sans contrainte bijective dans la zone
    func deuxSeulesCellulesLibres(dans zone: any UneZone) -> [Cellule]? {
        let libres = cellulesSansContrainteBijective(dans: zone)
        return libres.count == 2 ? libres.sorted() : nil
    }
    
    /// "absente" = sans contrainte bijective dans la zone.
    /// Lorsque la réponse est non nil, on peut noter un singleton1 avec cette valeur.
    func seuleValeurAbsente(dans zone: any UneZone) -> Int? {
        let absentes = Int.lesChiffres.subtracting(valeursPresentes(dans: zone))
        return absentes.count == 1 ? absentes.first! : nil
    }
    
    /// "absentes" = sans contrainte bijective dans la zone.
    /// Liste de deux valeurs ordonnées ou nil.
    /// Lorsque la réponse est non nil, on peut noter une paire2 avec cette valeur.
    func deuxSeulesValeurAbsentes(dans zone: any UneZone) -> [Int]? {
        let absentes = Int.lesChiffres.subtracting(valeursPresentes(dans: zone))
        return absentes.count == 2 ? absentes.array.sorted() : nil
    }
}
