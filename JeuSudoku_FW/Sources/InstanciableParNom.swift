//
//  InstanciableParNom.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Tout type vérifiant InstanciableParNom peut créer ses instances à partir d'un nom.
/// Peut échouer si nom incorrect, retourne alors nil.
/// Le nom définit une sorte de langage de sérialisation.
public protocol InstanciableParNom {
    
    init?(nom: String)
}
