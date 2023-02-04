//
//  Bijection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 01/02/2023.
//

import Foundation

/// L'affirmation de l'existence d'une bijection entre un domaine et un ensemble de valeurs.
/// On ne précise pas quelle bijection exactement. On ne précise pas la correspondance cellule par cellule.
/// On peut cependant décrire certaines propriétés de la bijection
public struct ExistenceBijection {
    
    /// Un ensemble de cellules inclus dans une ligne, une colonne ou un carré
    public let domaine: Domaine
    
    public let valeurs: Set<Int>
    public let nom: String
    
    public init(_ domaine: Domaine, _ valeurs: Set<Int>) {
        assert(domaine.estUnDomaine)
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

extension ExistenceBijection: Testable {
    
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




