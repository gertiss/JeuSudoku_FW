//
//  Strategie.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 04/02/2023.
//

import Foundation

public enum Strategie {
    case rechercheDeDomaines(RechercheDeDomaines)
    case rechercheDeValeurs(RechercheDeValeurs)
}

/// On cherche dans le `contexte`, un sous-domaine qui définit une bijection sur l'ensemble des `valeurs` qui a servi de focalisation.
public struct RechercheDeDomaines {
    public var contexte: Domaine
    public var valeurs: Set<Int>
}

extension RechercheDeDomaines {
    
}


/// On cherche  l'ensemble des valeurs possibles pour le `domaine` sur lequel on se focalise
public struct RechercheDeValeurs {
    public var domaine: Domaine
}
