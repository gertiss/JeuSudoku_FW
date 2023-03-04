//
//  Detection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 26/02/2023.
//

import Foundation



// MARK: - Primitives de recherche

public extension Puzzle {
    
    /// Toutes les zones de la grille, les plus remplies d'abord, et les carrés d'abord.
    var zonesClasseesParRemplissage: [any UneZone] {
        Grille.zones
            .filter { nombreDeSingletons1(dans: $0) < 9 }
            .sorted { zone1, zone2 in
                zone1.type.visibilite > zone2.type.visibilite &&
                nombreDeSingletons1(dans: zone1) > nombreDeSingletons1(dans: zone2)
            }
    }
    
    var valeursClasseesParFrequence: [Int] {
        Int.lesChiffres
            .filter { nombreDeSingletons1(pour: $0) < 9 }
            .sorted { chiffre1, chiffre2 in
                nombreDeSingletons1(pour: chiffre1) > nombreDeSingletons1(pour: chiffre2)
            }
    }
    
    func indicesCombinaisons2(parmi n: Int) -> [(Int, Int)] {
        switch n {
        case 2: return [(0, 1)]
        case 3: return [(0, 1), (0, 2), (1, 2)]
        case 4: return [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]
        case 5: return [(0, 1), (0, 2), (0, 3), (0, 4), (1, 2), (1, 3), (1, 4), (2, 3), (2, 4), (3, 4)]
        case 6: return [(0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (1, 2), (1, 3), (1, 4), (1, 5), (2, 3), (2, 4), (2, 5), (3, 4), (3, 5), (4, 5)]
        default: fatalError("Nombre de combinaisons2 trop grand : \((n * (n - 1))/2)")
        }
    }
    
    func indicesCombinaisons3(parmi n: Int) -> [(Int, Int, Int)] {
        switch n {
        case 3: return [(0, 1, 2)]
        case 4: return [(0, 1, 2), (0, 1, 3), (0, 2, 3), (1, 2, 3)]
        case 5: return [(0, 1, 2), (0, 1, 3), (0, 1, 4), (0, 2, 3), (0, 2, 4), (0, 3, 4), (1, 2, 3), (1, 2, 4), (1, 3, 4), (2, 3, 4)]
        case 6: return [
            (0, 1, 2), (0, 1, 3), (0, 1, 4), (0, 1, 5),
            (0, 2, 3), (0, 2, 4), (0, 2, 5),
            (0, 3, 4), (0, 3, 5),
            (0, 4, 5),
            (1, 2, 3), (1, 2, 4), (1, 2, 5),
            (1, 3, 4), (1, 3, 5),
            (1, 4, 5),
            (2, 3, 4), (2, 3, 5),
            (2, 4, 5),
            (3, 4, 5)
        ]
        default: fatalError("Nombre de combinaisons2 trop grand : \((n * (n - 1) * (n - 2))/6)")
        }

    }
    
    /// Le nombre de contraintes singleton1 dans laquelle apparaît la valeur, dans toute la grille.
    /// C'est-à-dire : le nombre de cellules remplies par la valeur.
    /// Plus ce nombre est grand, plus la valeur est prometteuse pour la recherche.
    /// Lorsqu'il y en a 9, la valeur est entièrement résolue :  on a trouvé toutes ses cellules.
    func nombreDeSingletons1(pour valeur: Int) -> Int {
        contraintes.filter { $0.type == .singleton1 && $0.valeurs == [valeur] }.count
    }
    
    /// Le nombre de contraintes singleton1 dans la zone (c'est-à-dire le nombre de cellules remplies).
    /// Plus ce nombre est grand, plus cette zone est prometteuse pour la recherche.
    /// Lorsqu'il y en a 9, la zone est entièrement résolue : toutes ses cellules ont été remplies.
    func nombreDeSingletons1(dans zone: any UneZone) -> Int {
        contraintes.filter { $0.type == .singleton1 && $0.region.estIncluseDans(zone) }.count
    }
    
    /// Le nombre de cellules remplies dans toute la grille, c'est-à-dire le nombre de singletons 1.
    var cellulesResolues: Region {
        Grille.cellules.filter { celluleEstResolue($0) }
    }

}


// MARK: - Niveau 1.0. Dernière cellule vide.

public extension Puzzle {
    
    /// Niveau 1.0
    /// On peut éventuellement hirarchiser le niveau : carré, puis alignement.
    /// Une dernière cellule dans un carré peut être plus visible que dans un alignement.
    var singleton1VisibleDetecte: Presence? {
        for zone in Grille.zones {
            if let singleton  = singleton1DetecteLocalement(dans: zone) {
                return singleton
            }
        }
        return nil
    }
}

// MARK: - Niveau 1.2, 1.5. Elimination directe sans paires

public extension Puzzle {
    
    /// Niveau 1.2 (dans carré) ou 1.5 (dans alignement)
    var singletonDetecteParEliminationDirecte: Presence? {
        
        let valeurs = valeursClasseesParFrequence
        let zones = zonesClasseesParRemplissage
        
        for valeur in valeurs {
            for zone in zones {
                if let singleton = singleton1DetecteParEliminationDirecte(pour: valeur, dans: zone.cellules) {
                    assert(!contraintes.contains(singleton))
                    return singleton
                }
            }
        }
        return nil
    }
}

// MARK: - Niveau 1.7. Elimination indirecte avec paire1

public extension Puzzle {
    
    /// Niveau 1.7. On utilise les paires1 temporairement.
    var singletonDetecteParEliminationIndirecte: Presence? {
        // Ordre de parcours des valeurs
        let valeurs = Int.lesChiffres
            .filter { nombreDeSingletons1(pour: $0) < 9 }
            .sorted { chiffre1, chiffre2 in
                nombreDeSingletons1(pour: chiffre1) > nombreDeSingletons1(pour: chiffre2)
            }
        for valeur in valeurs {
            // On cherche toutes les paires1 pour cette valeur
            let paires1 = paires1AligneesDetecteesParElimination(pour: valeur).ensemble
            // On fait la recherche dans un puzzle temporaire
            // avec les paires1
            let nouvellesContraintes = (contraintes + paires1).ensemble.array.sorted()
            let nouveauPuzzle = Puzzle(contraintes: nouvellesContraintes)
            if let singleton1 = nouveauPuzzle.singletonDetecteParEliminationDirecte {
                return singleton1
            }
        }
        return nil
    }

}

// MARK: - Elimination indirecte avec paire2

public extension Puzzle {
    
    func coupApresPaire2(parmi nombreCellulesVides: Int) -> Presence? {
        assert(nombreCellulesVides <= 6)
        
        let zonesInteressantes = zonesClasseesParRemplissage.filter {
            cellulesNonResolues(dans: $0).ensemble.count == nombreCellulesVides
        }
        
        for zone in zonesInteressantes {
            let cellulesVides = cellulesNonResolues(dans: zone).ensemble
            let valeursAbsentes = valeursNonResolues(dans: zone)

            // Vérifications paranoïaques
            assert(cellulesVides.count == nombreCellulesVides)
            assert(valeursAbsentes.ensemble.count == nombreCellulesVides)
            
            // Recherche d'une paire2
            let combinaisonsValeurs = indicesCombinaisons2(parmi: nombreCellulesVides)
                .map { i, j in (valeursAbsentes[i], valeursAbsentes[j]) }
            
            var paires = [Presence]()
            for (x1, x2) in combinaisonsValeurs {
                let eliminees = cellulesEliminees(pour: x1)
                    .intersection(cellulesEliminees(pour: x2))
                let cellulesRestantes = zone.cellules.subtracting(eliminees)
                if cellulesRestantes.count != 2 { continue }
                let paire2 = Presence([x1, x2], dans: cellulesRestantes)
                paires.append(paire2)
                
                // On a trouvé une paire2.
                // On étudie la présence complémentaire sur n - 2 cellules :
                // on recherche un singleton par élimination.
                let cellulesComplementaires = cellulesVides.subtracting(paire2.region)
                let valeursComplementaires =
                valeursAbsentes.ensemble.subtracting(paire2.valeurs)
                // Pour chaque valeur, on cherche les cellules éliminées,
                // puis un singleton1 par élimination directe.
                for valeur in valeursComplementaires {
                    if let singleton = singleton1DetecteParEliminationDirecte(pour: valeur, dans: cellulesComplementaires) {
                        return singleton
                    }
                }
            }
            // On retourne la première paire trouvée s'il y en a une
            // et si elle n'est pas déjà mémorisée dans le puzzle
           if let premierePaire = paires.first  {
                if !contraintes.contains(premierePaire) {
                    return premierePaire
                }
            }
        }
        return nil
    }
    
    func coupApresTriplet3(parmi nombreCellulesVides: Int) -> Presence? {
        assert(nombreCellulesVides <= 6)
        
        let zonesInteressantes = zonesClasseesParRemplissage.filter {
            cellulesNonResolues(dans: $0).ensemble.count == nombreCellulesVides
        }
        
        for zone in zonesInteressantes {
            let cellulesVides = cellulesNonResolues(dans: zone).ensemble
            let valeursAbsentes = valeursNonResolues(dans: zone)

            // Vérifications paranoïaques
            assert(cellulesVides.count == nombreCellulesVides)
            assert(valeursAbsentes.ensemble.count == nombreCellulesVides)
            
            // Recherche d'un triplet3
            let combinaisonsValeurs = indicesCombinaisons3(parmi: nombreCellulesVides)
                .map { i, j, k in (valeursAbsentes[i], valeursAbsentes[j], valeursAbsentes[k]) }
            
            var triplets = [Presence]()
            for (x1, x2, x3) in combinaisonsValeurs {
                let eliminees = cellulesEliminees(pour: x1)
                    .intersection(cellulesEliminees(pour: x2))
                    .intersection(cellulesEliminees(pour: x3))
                let cellulesRestantes = zone.cellules.subtracting(eliminees)
                if cellulesRestantes.count != 3 { continue }
                let triplet3 = Presence([x1, x2, x3], dans: cellulesRestantes)
                triplets.append(triplet3)
                
                // On a trouvé un triplet3.
                // On étudie la présence complémentaire sur n - 3 cellules :
                // on recherche un singleton par élimination.
                let cellulesComplementaires = cellulesVides.subtracting(triplet3.region)
                let valeursComplementaires =
                valeursAbsentes.ensemble.subtracting(triplet3.valeurs)
                // Pour chaque valeur, on cherche les cellules éliminées,
                // puis un singleton1 par élimination directe.
                for valeur in valeursComplementaires {
                    if let singleton = singleton1DetecteParEliminationDirecte(pour: valeur, dans: cellulesComplementaires) {
                        return singleton
                    }
                }
            }
            // On retourne le premier triplet trouvé s'il y en a une
            // et s'il n'est pas déjà mémorisé dans le puzzle
            if let premiereTriplet = triplets.first  {
                if !contraintes.contains(premiereTriplet) {
                    return premiereTriplet
                }
            }
        }
        return nil
    }
    
}

// MARK: - Combinatoire

public extension Puzzle {
    
    /// On examine chaque cellule pour déteminer ses valeurs candidates.
    /// On retourne une contrainte sur cette cellule s'il y a 1 seule valeur candidate.
    /// Très combinatoire (en gros 81x20)
    var absenceInvisibleDetectee: Presence? {
        for cellule in Grille.cellules {
            let valeursCiblantes = cellule.dependantes.compactMap { valeur($0) }.ensemble
            if valeursCiblantes.count == 8 {
                let valeursRestantes = Int.lesChiffres.subtracting(valeursCiblantes)
                let presence =  Presence(valeursRestantes, dans: [cellule])
                if !contraintes.contains(presence) {
                    return presence
                }
            }
        }
        return nil
    }
}
