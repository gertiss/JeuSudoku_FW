//
//  Carre.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Carre: UneZone {
    
    public let type: TypeZone
    
    // Un carré est l'intersection d'une bande horizontale et d'une bande verticale
    
    public let indexBandeH: Int // de 0 à 2
    public let indexBandeV: Int // de 0 à 2
    
    public init(_ indexBandeH: Int, _ indexBandeV: Int) {
        self.type = .carre
        assert(indexBandeH >= 0 && indexBandeH <= 2)
        assert(indexBandeV >= 0 && indexBandeV <= 2)
        self.indexBandeH = indexBandeH
        self.indexBandeV = indexBandeV
    }
}

extension Carre {
    
    /// Le nom du carré, qui sert d'id pour  le protocole Identifiable
    public var nom: String {
        return "le carré \(bandeH.nom)\(bandeV.nom)"
    }
    
    public var description: String {
        "Carre(\(indexBandeH), \(indexBandeV))"
    }
    
    /// Les 9 cellules du carré
    public var cellules: Set<Cellule> {
        var ensemble = Set<Cellule>()
        for dl in 0...2 {
            for dc in 0...2 {
                ensemble.insert(Cellule(indexBandeH * 3 + dl, indexBandeV * 3 + dc))
            }
        }
        assert(ensemble.count == 9)
        return ensemble
    }

    /// L'unique bande horizontale qui contient le carré
    var bandeH: BandeH {
        BandeH(indexBandeH)
    }
    
    /// L'unique bande verticale qui contient le carré
    var bandeV: BandeV {
        BandeV(indexBandeV)
    }
    

}
