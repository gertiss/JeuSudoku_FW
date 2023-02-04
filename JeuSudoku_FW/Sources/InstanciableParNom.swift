//
//  InstanciableParNom.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Tout type vérifiant InstanciableParNom peut créer ses instances à partir d'un nom.
/// Ce nom est un id au sens de Identifiable
/// Peut échouer si nom incorrect, retourne alors nil.
/// Le nom définit une sorte de langage de sérialisation.
public protocol InstanciableParNom: Identifiable {
    
    var nom: String { get }
    init(nom: String)
}

public extension InstanciableParNom {
    var id: String { nom }
}

