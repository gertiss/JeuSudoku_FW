//
//  Coup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 21/02/2023.
//

import Foundation

/// Un coup se manifeste graphiquement par l'écriture ou l'effacement d'annotations sur une grille.
/// On commence par effacer éventuellement certaines annotations existantes, puis on ajoute une nouvelle annotation.
struct Coup {
    var suppressions: [Presence]
    var ajout: Presence
}
