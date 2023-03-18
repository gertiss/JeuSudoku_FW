//
//  InstanciableParNom.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Tout type vérifiant InstanciableParNom peut créer ses instances à partir d'un "nom".
/// Peut échouer si nom incorrect, retourne alors nil.
/// Le nom définit une sorte de langage de sérialisation permettant de lire et écrire la valeur sous forme compacte.
/// C'est un cas particulier de CodableEnLitteral, avec litteral = nom.
public protocol InstanciableParNom: CodableEnLitteral {
    
    var nom: String { get }
    init(nom: String)
}

public extension InstanciableParNom {
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.nom < rhs.nom
    }
    
    var litteral: String {
        nom
    }
    
    init(litteral: String) {
        self = Self(nom: litteral)
    }
    
}

