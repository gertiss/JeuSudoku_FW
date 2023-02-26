//
//  Region.swift
//  LaboSudoku_FW
//
//  Created by Gérard Tisseau on 17/02/2023.
//

import Foundation

public typealias Region = Set<Cellule>

extension Region: InstanciableParNom, Testable, Comparable {
    
    /// [C(0,0), C(0,1)] -> "AaAb"
    public var nom: String {
        return self.array.map { $0.nom }.sorted().joined()
    }
    

    /// "AaAb" -> [C(0,0), C(0,1)]
    /// On suppose les noms syntaxiquement valides et tous distincts
    public init(nom: String) {
        var cellules = [Cellule]()
        assert(nom.count.isMultiple(of: 2))
        let nbCellules = nom.count / 2
        let caracteres = nom.map { String($0) }
        for index in  0...(nbCellules - 1) {
            let (li, co) = (caracteres[index * 2], caracteres[index * 2 + 1])
            cellules.append(Cellule(nom: li + co))
        }
        let ensemble = cellules.ensemble
        assert(ensemble.count == nbCellules)
        self = ensemble
    }
    

}

public extension Region {
    
    /// Si toutes les cellules appartiennent à une même ligne, on renvoie cette ligne, sinon nil
    var ligne: Ligne?  {
        guard let ligne0 = first?.ligne else {
            return nil
        }
        return allSatisfy { $0.ligne == ligne0 } ? ligne0 : nil
    }
    
    /// Si toutes les cellules appartiennent à une même colonne, on renvoie cette colonne, sinon nil
    var colonne: Colonne?  {
        guard let colonne0 = first?.colonne else {
            return nil
        }
        return allSatisfy { $0.colonne == colonne0 } ? colonne0 : nil
    }
    
    /// Si toutes les cellules appartiennent à un même carré, on renvoie ce carré, sinon nil
    var carre: Carre? {
        guard let carre0 = first?.carre else {
            return nil
        }
        return allSatisfy { $0.carre == carre0 } ? carre0 : nil
    }
    
    /// Si toutes les cellules appartiennent à une même zone du type donné, on renvoie cette zone sinon nil
    func zone(type: TypeZone) ->  (any UneZone)? {
        switch type {
        case .carre:
            return carre
        case .ligne:
            return ligne
        case .colonne:
            return colonne
        }
    }
    
    /// Toutes les zones auxquelles appartient la région self
    var zones: [any UneZone] {
        var liste = [any UneZone]()
        if let ligne { liste.append(ligne) }
        if let colonne { liste.append(colonne) }
        if let carre { liste.append(carre) }
        return liste
    }
    
    var estDansUnAlignement: Bool {
        ligne != nil || colonne != nil
    }
    
    var estDansUnCarre: Bool {
        carre != nil
    }
    var estDansUneZone: Bool {
        ligne != nil || colonne != nil || carre != nil
    }

    /// Un segment est un alignement à l'intérieur d'un carré (3 cellules)
    var estDansUnSegment: Bool {
        estDansUnAlignement && estDansUnCarre
    }
    
    func estDans(_ zone: any UneZone) -> Bool {
        switch zone.type {
        case .carre: return carre == (zone as! Carre)
        case .ligne: return ligne == (zone as! Ligne)
        case .colonne: return colonne == (zone as! Colonne)
        }
    }
    
    var alignement: (any UneZone)? {
        if let ligne { return ligne }
        if let colonne { return colonne }
        return nil
    }
    
    
}

