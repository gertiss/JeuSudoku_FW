//
//  Region.swift
//  LaboSudoku_FW
//
//  Created by Gérard Tisseau on 17/02/2023.
//

import Foundation
import Modelisation_FW

public typealias Region = Set<Cellule>


extension Region: InstanciableParNom, AvecLangage, CodableEnLitteral, Comparable, CodableEnJson {
    
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
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.litteral < rhs.litteral
    }

}

public extension Region {
    
    /// Si toutes les cellules appartiennent à une même ligne, on renvoie cette ligne, sinon nil
    var ligne: Ligne?  {
        // ligne de la première cellule
        guard let ligne0 = first?.ligne else {
            return nil
        }
        return allSatisfy { $0.ligne == ligne0 } ? ligne0 : nil
    }
    
    /// Si toutes les cellules appartiennent à une même colonne, on renvoie cette colonne, sinon nil
    var colonne: Colonne?  {
        // colonne de la première cellule
        guard let colonne0 = first?.colonne else {
            return nil
        }
        return allSatisfy { $0.colonne == colonne0 } ? colonne0 : nil
    }
    
    /// Si toutes les cellules appartiennent à un même carré, on renvoie ce carré, sinon nil
    var carre: Carre? {
        // carré de la première cellule
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
    
    var estIncluseDansUnAlignement: Bool {
        ligne != nil || colonne != nil
    }
    
    var estIncluseDansUnCarre: Bool {
        carre != nil
    }
    var estIncluseDansUneZone: Bool {
        ligne != nil || colonne != nil || carre != nil
    }

    /// Un segment est un alignement à l'intérieur d'un carré (3 cellules)
    var estIncluseDansUnSegment: Bool {
        estIncluseDansUnAlignement && estIncluseDansUnCarre
    }
    
    /// On utilise les fonctions carre, ligne, colonne qui donnent le carré, la ligne ou la colonne qui contient la région si existe.
    func estIncluseDans(_ zone: any UneZone) -> Bool {
        switch zone.type {
        case .carre: return self.carre == (zone as! Carre)
        case .ligne: return self.ligne == (zone as! Ligne)
        case .colonne: return self.colonne == (zone as! Colonne)
        }
    }
    
    func intersecte(_ zone: any UneZone) -> Bool {
        !self.intersection(zone.cellules).isEmpty
    }
    
    var alignement: (any UneZone)? {
        if let ligne { return ligne }
        if let colonne { return colonne }
        return nil
    }
    
    
    var cellulesDependantes: Region {
        if let singleton = uniqueValeur {
            return singleton.dependantes
        }
        if let alignement, let carre {
            return alignement.cellules.subtracting(self)
                .union(carre.cellules.subtracting(self))
        }
        if let alignement {
            return alignement.cellules.subtracting(self)
        }
        if let carre {
            return carre.cellules.subtracting(self)
        }
        return []
    }
    
    
}

