//
//  Valeurs.swift
//  JeuSudoku_GT
//
//  Created by Gérard Tisseau on 18/02/2023.
//

import Foundation

public typealias Valeurs = Set<Int>

/// Valeurs est déjà automatiquement conforme à Hashable, CustomStringConvertible, Codable
/// et aussi InstanciableParNom par héritage de Set (?)

extension Valeurs {
    
    /// On suppose que chaque caractère du nom est un chiffre
    /// et que les chiffres sont tous distincts
    /// "123" -> [1, 2, 3]
    public init(nom: String) {
        let chiffres = nom.map { Int(String($0))! }.ensemble
        assert(chiffres.count == nom.count)
        self = chiffres
    }
    
    /// [3, 1, 4, 2] -> "1234"
    public var nom: String {
        assert(allSatisfy{ $0 >= 0 && $0 <= 9 })
        return self.array.sorted().map { String($0) }.joined()
    }
    
}
