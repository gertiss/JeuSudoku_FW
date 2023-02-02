//
//  Cellule.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Cellule: Testable {
    
    public let indexLigne: Int // de 0 à 8
    public let indexColonne: Int // de 0 à 8
    
    public init(_ indexLigne: Int, _ indexColonne: Int) {
        assert(indexLigne >= 0 && indexLigne <= 8)
        assert(indexColonne >= 0 && indexColonne <= 8)
        self.indexLigne = indexLigne
        self.indexColonne = indexColonne
    }
    
    public var description: String {
        "Cellule(\(indexLigne), \(indexColonne))"
    }
    
    /// Exemple :  Cellule(0, 0) a pour nom "Aa"
    public var nom: String {
        return "\(ligne.nom)\(colonne.nom)"
    }
}

public extension Cellule {
    
    /// L'unique Ligne à laquelle self appartient
    var ligne: Ligne {
        Ligne(indexLigne)
    }
    
    /// L'unique Colonne à laquelle self appartient
    var colonne: Colonne {
        Colonne(indexColonne)
    }
    
    /// L'unique Carre auquel self appartient
    var carre: Carre {
        Carre(indexLigne / 3, indexColonne / 3)
    }
    
    /// L'unique bande horizontale à laquelle appartient self
    var bandeH: BandeH {
        ligne.bande
    }
    
    /// L'unique bande verticale à laquelle appartient self
    var bandeV: BandeV {
        colonne.bande
    }
    
    /// L'ensemble des 20 cases "dépendantes" de self
    /// Ce sont les 20 cases qui sont dans le champ de vision de la cellule : ligne, colonne, carré
    /// Toute valeur présente dans ce champ interdit la valeur dans self.
    var dependantes: Set<Cellule> {
        var ensemble = Set<Cellule>()
        ensemble = ensemble.union(ligne.cellules)
        ensemble = ensemble.union(colonne.cellules)
        ensemble = ensemble.union(carre.cellules)
        ensemble.remove(self)
        assert(ensemble.count == 20)
        return ensemble
    }
    
    
}
