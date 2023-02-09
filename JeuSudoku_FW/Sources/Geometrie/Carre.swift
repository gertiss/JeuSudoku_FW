//
//  Carre.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Carre {
    
    // Un carré est l'intersection d'une bande horizontale et d'une bande verticale
    
    public let indexBandeH: Int // de 0 à 2
    public let indexBandeV: Int // de 0 à 2
    
    /// Peut échouer si données incohérentes. fatalError dans ce cas.
    public init(_ indexBandeH: Int, _ indexBandeV: Int) {
        assert(indexBandeH >= 0 && indexBandeH <= 2)
        assert(indexBandeV >= 0 && indexBandeV <= 2)
        self.indexBandeH = indexBandeH
        self.indexBandeV = indexBandeV
    }
}

// MARK: - UneZone

extension Carre: UneZone {
    public var type: TypeZone { .carre }
    
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
}

// MARK: - Geometrie

public extension Carre {

    /// L'unique bande horizontale qui contient le carré
    var bandeH: BandeH {
        BandeH(indexBandeH)
    }
    
    /// L'unique bande verticale qui contient le carré
    var bandeV: BandeV {
        BandeV(indexBandeV)
    }
    
}

// MARK: - Testable

extension Carre: Testable {
    
    public var description: String {
        "Carre(\(indexBandeH), \(indexBandeV))"
    }
}

// MARK: - InstanciableParNom

extension Carre: InstanciableParNom {
    
    /// InstanciableParNom
    /// Le nom du carré, qui sert d'id pour  le protocole Identifiable
    public var nom: String {
        return "le carré \(bandeH.nom)\(bandeV.nom)"
    }

    /// InstanciableParNom
    /// Exemple : `Carre(nom: "Mn") -> Carre(0, 1)`.
    /// Peut échouer, fatalError
    public init(nom: String) {
        let bandeHV = nom.map { String($0) }
        if bandeHV.count != 2 { fatalError() }
        let nomBandeH = bandeHV[0]
        let nomBandeV = bandeHV[1]
        if !BandeH.noms.contains(nomBandeH) { fatalError() }
        if !BandeV.noms.contains(nomBandeV) { fatalError() }
        let indexBandeH = BandeH.noms.firstIndex(of: nomBandeH)!
        let indexBandeV = BandeV.noms.firstIndex(of: nomBandeV)!
        self = Carre(indexBandeH, indexBandeV)
    }

}
