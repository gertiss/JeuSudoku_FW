//
//  SingletonEliminateur.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 15/03/2023.
//

import Foundation

/// `singleton` est un singleton présent dans le puzzle. il a un pouvoir éliminateur direct :
/// il élimine toutes les cellules qui sont dans son champ d'élimination : ligne, colonne, carré
struct SingletonEliminateur {
    // Sujet
    let singleton: Presence
}

extension SingletonEliminateur {
    
    /// Tous les singletons éliminateurs de cellules pour la valeur.
    static func instances(valeur: Int, dans puzzle: Puzzle) -> [Self] {
        puzzle.contraintes(chiffre: valeur)
            .filter { $0.type == .singleton1 }
            .map { Self(singleton: $0) }
    }
    
    /// Les singletons éliminateurs de cellules dans la zone pour la valeur.
    static func instances(valeur: Int, zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        Self.instances(valeur: valeur, dans: puzzle)
            .filter { !$0.singleton.region.uniqueElement.dependantes.intersection(zone.cellules).isEmpty }
    }
}
