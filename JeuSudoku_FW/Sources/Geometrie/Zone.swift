//
//  Zone.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 16/03/2023.
//

import Foundation
import Modelisation_FW

/// POurrait permettre de remplacer any UneZone
enum Zone: UneZone, InstanciableParNom, CodableEnJson {
    
    case carre(Carre)
    case ligne(Ligne)
    case colonne(Colonne)
}

extension Zone {
    
    var type: TypeZone {
        switch self {
        case .carre(_):
            return .carre
        case .ligne(_):
            return .ligne
        case .colonne(_):
            return .colonne
        }
    }
    
    var cellules: Region {
        switch self {
        case .carre(let carre):
            return carre.cellules
        case .ligne(let ligne):
            return ligne.cellules
        case .colonne(let colonne):
            return colonne.cellules
        }
    }

    init(nom: String) {
        if Ligne.noms.contains(nom) {
            self = .ligne(Ligne(nom: nom))
        }
        if Colonne.noms.contains(nom) {
            self = .colonne(Colonne(nom: nom))
        }
        if Carre.noms.contains(nom) {
            self = .carre(Carre(nom: nom))
        }
        fatalError("Nom incorrect pour une Zone : \(nom)")
   }

    var nom: String {
        switch self {
        case .carre(let carre):
            return carre.nom
        case .ligne(let ligne):
            return ligne.nom
        case .colonne(let colonne):
            return colonne.nom
        }
    }
    
    var description: String {
        switch self {
        case .carre(let carre):
            return carre.description
        case .ligne(let ligne):
            return ligne.description
        case .colonne(let colonne):
            return colonne.description
        }
    }
}
