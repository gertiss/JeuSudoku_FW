//
//  UnDomaine.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 04/02/2023.
//

import Foundation

/// Une région est un ensemble de cellules
public protocol UnDomaine {
    var cellules: Set<Cellule> { get }
    var estUnDomaine: Bool { get }
}

public typealias Domaine = Set<Cellule>
