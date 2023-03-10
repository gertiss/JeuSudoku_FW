//
//  Communication.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 08/03/2023.
//

import Foundation


// MARK: - Coup

public func singleton(coup: Coup) -> Presence {
    coup.singleton
}

public func zone(coup: Coup) -> String {
    coup.zone.nom
}

public func auxiliaires(coup: Coup) -> [Presence] {
    coup.auxiliaires
}

public func methode(coup: Coup) -> String {
    coup.methode.rawValue
}

// MARK: - Presence

public func valeurs(presence: Presence) -> Set<Int> {
    presence.valeurs
}

public func region(presence: Presence) -> Set<Cellule> {
    presence.region
}

public func type(presence: Presence) -> String {
    presence.type.rawValue
}

public func nom(presence: Presence) -> String {
    presence.nom
}

// MARK: - AnyCellule

public func indexLigne(cellule: Cellule) -> Int {
    cellule.indexLigne
}

public func indexColonne(cellule: Cellule) -> Int {
    cellule.indexColonne
}




