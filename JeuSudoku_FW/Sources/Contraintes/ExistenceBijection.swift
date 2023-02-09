//
//  Bijection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 01/02/2023.
//

import Foundation

/// Une instance de ce type est une affimation de l'existence d'une bijection entre une région et un ensemble de valeurs dans un puzzle donné
/// On ne précise pas quelle bijection exactement : on ne précise pas la correspondance cellule par cellule.
/// On peut cependant décrire certaines propriétés de la bijection.
/// Cette bijection peut être déjà mémorisée dans le puzzle (propriété contraintes) ou non.
/// Si elle n'est pas encore mémorisée, on affirme qu'elle pourra l'être.
public struct ExistenceBijection: UneContrainte {
    public var type: TypeContrainte { .existenceBijection }
    
    /// Un ensemble de cellules inclus dans une ligne, une colonne ou un carré,
    /// qui constitue le domaine de la bijection.
    public let domaine: Set<Cellule>
    
    public let valeurs: Set<Int>
    
    /// Exemple de nom : `"AaAb_37"`
    public let nom: String
    
    public init(domaine: Set<Cellule>, valeurs: Set<Int>) {
        assert(domaine.count == valeurs.count)
        self.domaine = domaine
        self.valeurs = valeurs

        var calculNom: String {
            let nomsCellules = domaine.map { $0.nom }
                .sorted()
                .joined()
            let nomsValeurs = valeurs.map { $0.description }
                .sorted()
                .joined()
            return "\(nomsCellules)_\(nomsValeurs)"
        }
        self.nom = calculNom
   }
    
}

extension ExistenceBijection {
    
    public var description: String {
        "ExistenceBijection(\(domaine), \(valeurs))"
    }

}

// MARK: - Propriétés de la bijection

extension ExistenceBijection {
    
    var cardinal: Int {
        domaine.count
    }
}




