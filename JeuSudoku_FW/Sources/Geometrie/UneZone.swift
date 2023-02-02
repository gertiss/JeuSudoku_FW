//
//  Zone.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public enum TypeZone: String, Testable {
    
    case carre
    case ligne
    case colonne
    
    public var description: String {
        "TypeZone.\(rawValue)"
    }
    
    public var nom: String {
        rawValue
    }

}

/// UneZone est une Ligne ou une Colonne ou un Carre
/// Si on veut une liste de UneZone, il faut écrire `[any UneZone]`
/// Mais `any UneZone` ne peut pas être Equatable ni Hashable
/// bien que UneZone le soit
public protocol UneZone: Testable {
    var cellules: Set<Cellule> { get }
    var type: TypeZone { get }
}

    
    

