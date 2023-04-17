//
//  Detection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 26/02/2023.
//

import Foundation


// MARK: - Méthodes de grille

/// Ces méthodes ne sont pas liées à une zone particulière.
/// Elles font des recherches globales dans toute la grille.

extension Puzzle {
    
    /// Toutes les zones de la grille, les plus remplies d'abord, et les carrés d'abord.
    /// Utilisé par `Coup_Paire_2` et `Coup_Triplet_3`
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
    /// Utilisé par `premierCoup()`
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
    
    
    /// Le nombre de cellules remplies dans toute la grille, c'est-à-dire le nombre de singletons 1.
    var cellulesResolues: Region {
        Grille.cellules.filter { celluleEstResolue($0) }
    }
    
}


