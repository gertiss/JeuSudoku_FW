//
//  SingletonEliminateur.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 15/03/2023.
//

import Foundation
import Modelisation_FW

/// `singleton` est un singleton présent dans le puzzle. il a un pouvoir éliminateur direct :
/// il élimine toutes les cellules qui sont dans son champ d'élimination : ligne, colonne, carré
/// C'est une réficiation du concept de Singleton qui spécialise Presence
struct SingletonEliminateur {
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

struct SingletonEliminateur_: UnLitteral {
    
    let singleton: Presence.Litteral
    
    var codeSwift: String {
        "SingletonEliminateur_(singleton: \(singleton.codeSwift))"
    }
}

extension SingletonEliminateur: CodableEnLitteral {
    typealias Litteral = SingletonEliminateur_
    
    var litteral: SingletonEliminateur_ {
        SingletonEliminateur_(singleton: singleton.litteral)
    }
    
    init(litteral: SingletonEliminateur_) {
        self.singleton = Presence(litteral: litteral.singleton)
    }
}
