//
//  Decouverte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 03/02/2023.
//

import Foundation

/// Un compte rendu de recherche de contraintes
public struct RapportDeRecherche {
    var decouvertes: [DecouverteDeContrainte]
}

public struct DecouverteDeContrainte {
    public var contrainte: ExistenceBijection
    public var strategie: Strategie
}

