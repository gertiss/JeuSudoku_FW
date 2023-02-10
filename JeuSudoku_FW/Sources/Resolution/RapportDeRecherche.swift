//
//  Decouverte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 03/02/2023.
//

import Foundation

/// Un compte rendu de recherche de contraintes qui a réussi.
/// Quelle découverte a-t-on faite à l'issue de cette recherche ?
/// Pour cette découverte, quelle contrainte a-t-on découverte et par quelle stratégie ?
public struct RapportDeRecherche {
    public var decouverte: DecouverteDeContrainte
}

/// Equivalent à "J'ai découvert telle contrainte en utilisant telle stratégie"
public struct DecouverteDeContrainte {
    public var contrainte: PresenceValeurs
    public var strategie: Strategie
}

