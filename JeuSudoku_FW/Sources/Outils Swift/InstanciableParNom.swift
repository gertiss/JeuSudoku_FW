//
//  InstanciableParNom.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Tout type vérifiant InstanciableParNom peut créer ses instances à partir d'un "nom".
/// Ce nom est un id au sens de Identifiable, il sert d'identificateur unique pour la valeur.
/// Peut échouer si nom incorrect, retourne alors nil.
/// Le nom définit une sorte de langage de sérialisation permettant de lire et écrire la valeur sous forme compacte.
public protocol InstanciableParNom: Comparable {
    
    var nom: String { get }
    init(nom: String)
}

public extension InstanciableParNom {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.nom < rhs.nom
    }
}

