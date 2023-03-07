//
//  Combinatoire.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 06/03/2023.
//

import Foundation

/// Les combinaisons de 2 éléments parmi 0...(n - 1).
/// Exemple : combinaisons2(parmi: 4) -> [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]
func combinaisons2(parmi n: Int) -> [(Int, Int)] {
    
    var liste = [(Int, Int)]()
    for i in 0...(n - 2) {
        for j in (i + 1)...(n - 1) {
            liste.append((i, j))
        }
    }
    return liste
}

/// Les combinaisons de 3 éléments parmi 0...(n - 1)
func combinaisons3(parmi n: Int) -> [(Int, Int, Int)] {
    
    var liste = [(Int, Int, Int)]()
    for i in 0...(n - 3) {
        for j in (i + 1)...(n - 2) {
            for k in (j + 1)...(n - 1) {
                liste.append((i, j, k))
            }
        }
    }
    return liste
}




