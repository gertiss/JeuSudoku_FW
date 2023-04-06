//
//  Cellule.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation
import Modelisation_FW

public struct Cellule: Codable, Comparable {
    public static func < (lhs: Cellule, rhs: Cellule) -> Bool {
        lhs.indexLigne < rhs.indexLigne ||
        (lhs.indexLigne == rhs.indexLigne  && lhs.indexColonne < rhs.indexColonne)
    }
    
    
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
    var dependantes: Region {
        var ensemble = Region()
            .union(ligne.cellules)
            .union(colonne.cellules)
            .union(carre.cellules)
        ensemble.remove(self)
        assert(ensemble.count == 20)
        return ensemble
    }
    
}

// MARK: - Testable

extension Cellule {
    
    public var description: String {
        "Cellule(\(indexLigne), \(indexColonne))"
    }
}

// MARK: - CodableParNom

public typealias Cellule_ = String

extension Cellule: CodableParNom {
    
    
    /// InstanciableParNom
    /// Exemple :  `Cellule(0, 0)` a pour nom `"Aa"`
    public var nom: String {
        return "\(ligne.nom)\(colonne.nom)"
    }

    /// InstanciableParNom
    /// Exemple `Cellule(nom: "Ac") -> Cellule(0, 2)`
    /// Peut échouer (fatalError)
    public init(nom: String) {
        let message = "Nom de Cellule incorrect: \"\(nom)\""
        
        let ligneColonne = nom.map { String($0) }
        assert(ligneColonne.count == 2, message)
        
        let ligne = ligneColonne[0]
        assert(Ligne.noms.contains(ligne), message)
        
        let colonne = ligneColonne[1]
        assert(Colonne.noms.contains(colonne), message)
        
        let indexLigne = Ligne.noms.firstIndex(of: ligne)!
        let indexColonne = Colonne.noms.firstIndex(of: colonne)!
        self = Cellule(indexLigne, indexColonne)
    }
}

