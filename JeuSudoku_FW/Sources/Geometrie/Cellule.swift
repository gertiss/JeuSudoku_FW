//
//  Cellule.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Cellule {
    
    public let indexLigne: Int // de 0 à 8
    public let indexColonne: Int // de 0 à 8
    
    public init(_ indexLigne: Int, _ indexColonne: Int) {
        assert(indexLigne >= 0 && indexLigne <= 8)
        assert(indexColonne >= 0 && indexColonne <= 8)
        self.indexLigne = indexLigne
        self.indexColonne = indexColonne
    }
}

// MARK: - Geometrie

public extension Cellule {
    
    /// L'unique Ligne à laquelle la cellule self appartient
    var ligne: Ligne {
        Ligne(indexLigne)
    }
    
    /// L'unique Colonne à laquelle la cellule self appartient
    var colonne: Colonne {
        Colonne(indexColonne)
    }
    
    /// L'unique Carre auquel la cellule self appartient
    var carre: Carre {
        Carre(indexLigne / 3, indexColonne / 3)
    }
    
    /// L'unique bande horizontale à laquelle la cellule self appartient
    var bandeH: BandeH {
        ligne.bande
    }
    
    /// L'unique bande verticale à laquelle la cellule self appartient
    var bandeV: BandeV {
        colonne.bande
    }
    
    /// L'ensemble des 20 cases "dépendantes" de self
    /// Ce sont les 20 cases qui sont dans le champ de vision de la cellule : ligne, colonne, carré
    /// Toute valeur présente dans ce champ interdit cette valeur dans self si self est vide.
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

// MARK: - Testable

extension Cellule: Testable {
    
    public var description: String {
        "Cellule(\(indexLigne), \(indexColonne))"
    }
}

// MARK: - InstanciableParNom

extension Cellule: InstanciableParNom {
    
    /// InstanciableParNom
    /// Exemple :  `Cellule(0, 0)` a pour nom `"Aa"`
    public var nom: String {
        return "\(ligne.nom)\(colonne.nom)"
    }

    /// InstanciableParNom
    /// Exemple `Cellule(nom: "Ac") -> Cellule(0, 2)`
    /// Peut échouer (fatalError)
    public init(nom: String) {
        let ligneColonne = nom.map { String($0) }
        if ligneColonne.count != 2 { fatalError() }
        let ligne = ligneColonne[0]
        let colonne = ligneColonne[1]
        if !Ligne.noms.contains(ligne) { fatalError() }
        if !Colonne.noms.contains(colonne) { fatalError() }
        let indexLigne = Ligne.noms.firstIndex(of: ligne)!
        let indexColonne = Colonne.noms.firstIndex(of: colonne)!
        self = Cellule(indexLigne, indexColonne)
    }
}

