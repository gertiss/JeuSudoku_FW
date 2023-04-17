//
//  RechercheCoup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 05/04/2023.
//

import Foundation

extension Puzzle {
    
    /// La stratégie de recherche globale de plus haut niveau :
    /// quel est le premier coup nouveau qu'on peut trouver à partir de l'état actuel ?
    /// Toutes les fonctions de recherche utilisées retournent un coup ou nil.
    /// On garantit que le coup découvre un singleton valide qui ne figure pas dans l'état actuel.
    /// Ordre des essais : la méthode la moins combinatoire d'abord.
    var premierCoup: Coup? {
        
        // Niveau 1.0 : dernière cellule vide dans une zone, valeur obligée.
        // complexité 1
        if let coup = coupDerniereCellule {
            return coup
        }
        // Dernière cellule libre après élimination directe.
        // Niveau 1.2 dans un carré, 1.5 dans une ligne ou une colonne.
        // complexité 1
        if let coup = coupParEliminationDirecte {
            return coup
        }
        // Dernière cellule libre après élimination directe et indirecte.
        // Utilise une ou plusieurs paire1 auxiliaires.
        // Niveau 1.7
        // complexité ?
        if let coup = coupParEliminationIndirecte {
            return coup
        }
        // Paire2 dans une zone avec 3 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 3
        if let coup = coupApresPaire(parmi: 3) {
            return coup
        }

        // Triplet3 dans une zone avec 4 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 4
        if let coup = coupApresTriplet(parmi: 4) {
            return coup
        }
        // Paire2 dans une zone avec 4 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 6
        if let coup = coupApresPaire(parmi: 4) {
            return coup
        }
        // Paire2 dans une zone avec 5 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Niveau 2.0. Complexité 10
        if let coup = coupApresPaire(parmi: 5) {
            return coup
        }
        // Triplet3 dans une zone avec 5 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 10
        if let coup = coupApresTriplet(parmi: 5) {
            return coup
        }
        // Paire2 dans une zone avec 6 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Niveau 2.6. Complexité 15
        if let coup = coupApresPaire(parmi: 6) {
            return coup
        }
        // Triplet3 dans une zone avec 6 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 20
        if let coup = coupApresTriplet(parmi: 6) {
            return coup
        }
        // Paire2 dans une zone avec 7 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 21
        if let coup = coupApresPaire(parmi: 7) {
            return coup
        }
        // Paire2 dans une zone avec 8 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 28
        if let coup = coupApresPaire(parmi: 8) {
            return coup
        }
        // Triplet3 dans une zone avec 7 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 35
        if let coup = coupApresTriplet(parmi: 7) {
            return coup
        }
        // Paire2 dans une zone avec 9 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 36
        if let coup = coupApresPaire(parmi: 9) {
            return coup
        }
        //
        // Triplet3 dans une zone avec 8 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 56
        if let coup = coupApresTriplet(parmi: 8) {
            return coup
        }

        
        // Cellule n'ayant plus qu'un seul candidat,
        // qu'on ne peut pas voir par élimination directe.
        // Recherche combinatoire globale ne correspondant pas à une perception humaine.
        // C'est un coup "joker" quand on ne trouve rien d'autre.
//        if let coup = coupUniqueValeurCandidate {
//            print(codeChiffres)
//            print("unique valeur \(coup.singleton)")
//            return coup
//        }
        
        return nil
    }
    
}


// MARK: - Niveau 1.0. Dernière cellule vide.

extension Puzzle {
    
    /// Niveau 1.0
    /// On peut éventuellement hiérarchiser le niveau : carré, puis alignement.
    /// Une dernière cellule dans un carré peut être plus visible que dans un alignement.
    var coupDerniereCellule: Coup? {
        for zone in zonesClasseesParRemplissage {
            if let coup = Coup_DerniereCellule.instances(zone: zone, dans: self).uniqueValeur {
                return .derniereCellule(coup)
            }
        }
        return nil
    }
}

// MARK: - Niveau 1.2, 1.5. Elimination directe sans paires

extension Puzzle {
    
    /// Niveau 1.2 (dans carré) ou 1.5 (dans alignement)
    var coupParEliminationDirecte: Coup? {
        
        for valeur in valeursClasseesParFrequence {
            for zone in zonesClasseesParRemplissage {
                if let coup = Coup_EliminationDirecte.instances(valeur: valeur, zone: zone, dans: self).uniqueValeur {
                    return .eliminationDirecte(coup)
                }
            }
        }
        return nil
    }
}
    

// MARK: - Niveau 1.7. Elimination indirecte avec paire1

extension Puzzle {
    
    /// Niveau 1.7. On utilise les paires1 temporairement.
    var coupParEliminationIndirecte: Coup? {
        for valeur in valeursClasseesParFrequence {
            // On cherche toutes les paires1 pour cette valeur
            for zone in zonesClasseesParRemplissage {
                if let coup = Coup_EliminationIndirecte.instances(valeur: valeur, zone: zone, dans: self).uniqueValeur {
                    return .eliminationIndirecte(coup)
                }
            }
        }
        return nil
    }
}

// MARK: - Coups avec bijection auxiliaire

extension Puzzle {
    
    /// Une seule cellule restante après élimination directe, sinon nil
    /// Utilisé par `Coup_Paire2` et `Coup_Triplet3`
    /// Inconvénient : ne retourne pas d'explication.
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
        return singleton
    }
    
}


// MARK: - Elimination indirecte avec paire2

extension Puzzle {
    
    func coupApresPaire(parmi nombreCellulesVides: Int) -> Coup? {
        assert(nombreCellulesVides <= 9)
        for zone in Grille.zones {
            if let coup = Coup_Paire2.instances(zone: zone, parmi: nombreCellulesVides, dans: self).uniqueValeur {
                return .paire2(coup)
            }
        }
        return nil
    }
    
}

// MARK: - Elimination indirecte avec triplet3

extension Puzzle {
    
    func coupApresTriplet(parmi nombreCellulesVides: Int) -> Coup? {
        assert(nombreCellulesVides <= 9)
        for zone in Grille.zones {
            if let coup = Coup_Triplet3.instances(zone: zone, parmi: nombreCellulesVides, dans: self).uniqueValeur {
                return .triplet3(coup)
            }
        }
        return nil
    }
}

// MARK: - Combinatoire globale

extension Puzzle {
    
    /// On examine chaque cellule pour déteminer ses valeurs candidates.
    /// On retourne une contrainte sur cette cellule s'il y a 1 seule valeur candidate.
    /// Très combinatoire (en gros 81x20)
//    var coupUniqueValeurCandidate: CoupOld? {
//        for zone in zonesClasseesParRemplissage {
//            for cellule in zone.cellules {
//                let valeursCiblantes = cellule.dependantes.compactMap { valeur($0) }.ensemble
//                if valeursCiblantes.count == 8 {
//                    let valeursRestantes = Int.lesChiffres1a9.subtracting(valeursCiblantes)
//                    let singleton =  Presence(valeursRestantes, dans: [cellule])
//                    if let  valide = nouveauSingletonValide(singleton) {
//                        let demonstration = Demonstration(presence: singleton, zone: cellule.carre, occupees: [], eliminatrices: [], eliminees: [], auxiliaires: [])
//                        return CoupOld(valide, zone: cellule.carre, methode: .uniqueValeur, demonstration: demonstration)
//                    }
//                }
//            }
//        }
//        return nil
//    }
}

