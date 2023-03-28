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
    
    /// Les chiffres classés suivant leurs nombres d'occurrences dans la grille.
    /// Sauf ceux qui ont 9 occurrences, qui sont déjà entièrement résolus.
    var valeursClasseesParFrequence: [Int] {
        Int.lesChiffres1a9
            .filter { nombreDeSingletons1(pour: $0) < 9 }
            .sorted { chiffre1, chiffre2 in
                nombreDeSingletons1(pour: chiffre1) > nombreDeSingletons1(pour: chiffre2)
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
    /// On peut éventuellement hiérarchiser le niveau : carré, puis alignement.
    /// Une dernière cellule dans un carré peut être plus visible que dans un alignement.
    var coupDerniereCellule: CoupOld? {
        for zone in Grille.zones {
            if let singleton  = singleton1DetecteLocalement(dans: zone), estNouveauSingletonValide(singleton) {
                // Provisoire !
                var provisoire = "refactoriser la démonstration"
                let demonstration = Demonstration(presence: singleton, zone: zone, occupees: [], eliminatrices: [], eliminees: [], auxiliaires: [])
                return CoupOld(singleton, zone: zone, methode: .derniereCellule, demonstration: demonstration)
            }
        }
        return nil
    }
}

// MARK: - Niveau 1.2, 1.5. Elimination directe sans paires

public extension Puzzle {
    
    /// Niveau 1.2 (dans carré) ou 1.5 (dans alignement)
    var coupParEliminationDirecte: CoupOld? {
        
        let valeurs = valeursClasseesParFrequence
        let zones = zonesClasseesParRemplissage
        
        for valeur in valeurs {
            for zone in zones {
                if let singleton = singleton1DetecteParEliminationDirecte(pour: valeur, dans: zone.cellules, zone: zone), estNouveauSingletonValide(singleton) {
                    // Provisoire !
                    var provisoire = "refactoriser la démonstration"
                    let demonstration = Demonstration(presence: singleton, zone: zone, occupees: [], eliminatrices: [], eliminees: [], auxiliaires: [])
                    return CoupOld(singleton, zone: zone, methode: .direct, demonstration: demonstration)
                }
            }
        }
        return nil
    }
}

// MARK: - Niveau 1.7. Elimination indirecte avec paire1

public extension Puzzle {
    
    /// Niveau 1.7. On utilise les paires1 temporairement.
    var coupParEliminationIndirecte: CoupOld? {
        // Ordre de parcours des valeurs
        let valeurs = Int.lesChiffres1a9
            .filter { nombreDeSingletons1(pour: $0) < 9 }
            .sorted { chiffre1, chiffre2 in
                nombreDeSingletons1(pour: chiffre1) > nombreDeSingletons1(pour: chiffre2)
            }
        for valeur in valeurs {
            // On cherche toutes les paires1 pour cette valeur
            let paires1 = paires1AligneesDetecteesParElimination(pour: valeur).ensemble
            // On ne retient que les paires1 utiles
            // c'est-à-dire qui éliminent au moins une cellule non déjà éliminée directement
            let elimineesDirectement = cellulesEliminees(pour: valeur)
            let paires1Utiles = paires1.filter { paire1EstUtile($0, cellulesElimineesDirectement: elimineesDirectement)}
            // On fait la recherche dans un puzzle temporaire
            // avec les paires1 utiles
            let nouvellesContraintes = (contraintes + paires1Utiles).ensemble.array.sorted()
            let nouveauPuzzle = Puzzle(contraintes: nouvellesContraintes)
            if let coup = nouveauPuzzle.coupParEliminationDirecte {
                /// Les paires détectrices sont celles qui ont permis le coup.
                /// Elles ont la valeur du coup et envoient des rayons dans la zone du coup.
                let paires1Detectrices = paires1Utiles.filter { paire1 in
                    let valeurCoup = coup.singleton.valeurs.uniqueElement
                    let valeurPaire1 = paire1.valeurs.uniqueElement
                    let cellulesAlignement = paire1.alignement!.cellules
                    return valeurPaire1 == valeurCoup
                    && !cellulesAlignement.intersection(coup.zone.cellules).isEmpty
                }
                let demonstration = Demonstration(presence: coup.singleton, zone: coup.zone, occupees: [], eliminatrices: [], eliminees: [], auxiliaires: [])
                
                return CoupOld(coup.singleton, zone: coup.zone, auxiliaires: paires1Detectrices.array, methode: .indirect, demonstration: demonstration)
            }
        }
        return nil
    }
    
}

// MARK: - Elimination indirecte avec paire2

public extension Puzzle {
    
    func coupApresPaire(parmi nombreCellulesVides: Int) -> CoupOld? {
        assert(nombreCellulesVides <= 9)
        
        let zonesInteressantes = zonesClasseesParRemplissage.filter {
            cellulesNonResolues(dans: $0).ensemble.count == nombreCellulesVides
        }
        
        for zone in zonesInteressantes {
            let cellulesVides = cellulesNonResolues(dans: zone).ensemble
            let valeursAbsentes = valeursAbsentes(dans: zone)
            
            // Vérifications paranoïaques
            assert(cellulesVides.count == nombreCellulesVides)
            assert(valeursAbsentes.ensemble.count == nombreCellulesVides)
            
            // Recherche d'une paire2
            let combinaisonsValeurs = combinaisons2(parmi: nombreCellulesVides)
                .map { i, j in (valeursAbsentes[i], valeursAbsentes[j]) }
            
            for (x1, x2) in combinaisonsValeurs {
                let eliminees = cellulesEliminees(pour: x1)
                    .intersection(cellulesEliminees(pour: x2))
                let cellulesRestantes = zone.cellules.subtracting(eliminees)
                if cellulesRestantes.count != 2 { continue }
                let paire2 = Presence([x1, x2], dans: cellulesRestantes)
                
                // On a trouvé une paire2.
                // On étudie la présence complémentaire sur n - 2 cellules :
                // on recherche un singleton par élimination.
                let cellulesComplementaires = cellulesVides.subtracting(paire2.region)
                let valeursComplementaires =
                valeursAbsentes.ensemble.subtracting(paire2.valeurs)
                // Pour chaque valeur, on cherche les cellules éliminées,
                // puis un singleton1 par élimination directe.
                for valeur in valeursComplementaires {
                    if let singleton = singleton1DetecteParEliminationDirecte(pour: valeur, dans: cellulesComplementaires, zone: zone), estNouveauSingletonValide(singleton) {
                        // on peut inclure dans le compte rendu :
                        // eliminees (par x1 et x2)
                        // singleton rapporte ausssi un compte rendu
                        // Provisoire !
                        var provisoire = "refactoriser la démonstration"
                        let demonstration = Demonstration(presence: singleton, zone: zone, occupees: [], eliminatrices: [], eliminees: [], auxiliaires: [])
                        return CoupOld(singleton, zone: zone, auxiliaires: [paire2], methode: .indirect, demonstration: demonstration)
                    }
                }
            }
        }
        return nil
    }
    
}

// MARK: - Elimination indirecte avec triplet3

extension Puzzle {
    
    func coupApresTriplet(parmi nombreCellulesVides: Int) -> CoupOld? {
        assert(nombreCellulesVides <= 9)
        
        let zonesInteressantes = zonesClasseesParRemplissage.filter {
            cellulesNonResolues(dans: $0).ensemble.count == nombreCellulesVides
        }
        
        for zone in zonesInteressantes {
            let cellulesVides = cellulesNonResolues(dans: zone).ensemble
            let valeursAbsentes = valeursAbsentes(dans: zone)
            
            // Vérifications paranoïaques
            assert(cellulesVides.count == nombreCellulesVides)
            assert(valeursAbsentes.ensemble.count == nombreCellulesVides)
            
            // Recherche d'un triplet3
            let combinaisonsValeurs = combinaisons3(parmi: nombreCellulesVides)
                .map { i, j, k in (valeursAbsentes[i], valeursAbsentes[j], valeursAbsentes[k]) }
            
            for (x1, x2, x3) in combinaisonsValeurs {
                let eliminees = cellulesEliminees(pour: x1)
                    .intersection(cellulesEliminees(pour: x2))
                    .intersection(cellulesEliminees(pour: x3))
                let cellulesRestantes = zone.cellules.subtracting(eliminees)
                if cellulesRestantes.count != 3 { continue }
                let triplet3 = Presence([x1, x2, x3], dans: cellulesRestantes)
                
                // On a trouvé un triplet3.
                // On étudie la présence complémentaire sur n - 3 cellules :
                // on recherche un singleton par élimination.
                let cellulesComplementaires = cellulesVides.subtracting(triplet3.region)
                let valeursComplementaires =
                valeursAbsentes.ensemble.subtracting(triplet3.valeurs)
                // Pour chaque valeur, on cherche les cellules éliminées,
                // puis un singleton1 par élimination directe.
                for valeur in valeursComplementaires {
                    if let singleton = singleton1DetecteParEliminationDirecte(pour: valeur, dans: cellulesComplementaires, zone: zone), estNouveauSingletonValide(singleton) {
                        // Provisoire !
                        let demonstration = Demonstration(presence: singleton, zone: zone, occupees: cellulesResolues(dans: zone), eliminatrices: [], eliminees: [], auxiliaires: [])
                        return CoupOld(singleton, zone: zone, auxiliaires: [triplet3], methode: .indirect, demonstration: demonstration)
                    }
                }
            }
        }
        return nil
    }
    
}

// MARK: - Combinatoire globale

public extension Puzzle {
    
    /// On examine chaque cellule pour déteminer ses valeurs candidates.
    /// On retourne une contrainte sur cette cellule s'il y a 1 seule valeur candidate.
    /// Très combinatoire (en gros 81x20)
    var coupUniqueValeurCandidate: CoupOld? {
        for cellule in Grille.cellules {
            let valeursCiblantes = cellule.dependantes.compactMap { valeur($0) }.ensemble
            if valeursCiblantes.count == 8 {
                let valeursRestantes = Int.lesChiffres1a9.subtracting(valeursCiblantes)
                let singleton =  Presence(valeursRestantes, dans: [cellule])
                if let  valide = nouveauSingletonValide(singleton) {
                    // Provisoire !
                    var provisoire = "refactoriser la démonstration"
                    let demonstration = Demonstration(presence: singleton, zone: cellule.carre, occupees: [], eliminatrices: [], eliminees: [], auxiliaires: [])
                    return CoupOld(valide, zone: cellule.carre, methode: .uniqueValeur, demonstration: demonstration)
                }
            }
        }
        return nil
    }
}
