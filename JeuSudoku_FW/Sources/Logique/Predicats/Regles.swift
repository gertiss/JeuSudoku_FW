//
//  Regles.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 11/03/2023.
//

import Foundation


// MARK: - Prédicats pour recherche d'un coup


/// Le singleton est détecté parce qu'il est la dernière cellule libre en dehors des occupées
struct Coup_DerniereCellule {
    // Sujet
    let singleton: Presence
    // Parametres
    let zone: AnyZone
    let occupees: [Cellule]
}

/// Le singleton est détecté parce qu'il est dans le champ d'élimination de 8 valeurs distinctes.
struct Singleton_DerniereValeur {
    // Sujet
    let singleton: Presence
    // Parametres
    let eliminations: [EliminationDirecte]
}



