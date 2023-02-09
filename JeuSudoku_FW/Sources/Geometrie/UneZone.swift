//
//  Zone.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public enum TypeZone: Hashable, Codable {
    case carre
    case ligne
    case colonne
}

/// UneZone est une Ligne ou une Colonne ou un Carre
/// Si on veut une collection de UneZone, il faut écrire `[any UneZone]`,
/// car `Set<UneZone>` est impossible à résoudre pour l'inférence de types.
public protocol UneZone: Testable {
    var cellules: Set<Cellule> { get }
    var type: TypeZone { get }
    
    var nom: String { get }
}

