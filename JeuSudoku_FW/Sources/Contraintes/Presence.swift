//
//  PresenceValeur.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 09/02/2023.
//

import Foundation

/// Une Presence est une contrainte qui affirme que les `valeurs` doivent être obligatoirement présentes dans la `region`
/// Voir les protocoles pour les méthodes par défaut
public struct Presence: UneContrainte, Testable, InstanciableParNom {
    
    public let valeurs: Valeurs
    public let region: Region
    public let type: TypeContrainte
    
    /// `PresenceValeurs([1, 2], dans: [Cellule(0,0), Cellule(0, 1)])`
    public init(_ valeurs: Valeurs, dans region: Region) {
        switch (region.count, valeurs.count) {
        case (1, 1): type = .singleton1
        case (1, 2): type = .singleton2
        case (2, 1): type = .paire1
        case (2, 2): type = .paire2
        case (3, 3): type = .triplet3
        default: fatalError("Une contrainte ne peut avoir que 1 ou 2 cellules et 1 ou 2 valeurs")
        }
        self.valeurs  = valeurs
        self.region = region
    }
    
    public var description: String {
        "Presence(\(valeurs), dans: \(region))"
    }
    
    /// Redéfinition de l'opérateur `<` défini par défaut dans InstanciableParNom.
    /// On ordonne alphabétiquement suivant les noms des régions PUIS suivant les valeurs.
    /// Reste compatible avec la définition par défaut : définition locale => définition par défaut.
    public static func < (lhs: Presence, rhs: Presence) -> Bool {
        lhs.region.nom < rhs.region.nom && rhs.valeurs.nom < lhs.valeurs.nom
    }
    
    /// `"AaAb_12"`
    public var nom: String {
        "\(region.nom)_\(valeurs.nom)"
    }
    
    /// `Presence(nom: "AaAb_12")`
    public init(nom: String) {
        let champs = nom.components(separatedBy: "_")
        assert(champs.count == 2)
        let (nomRegion, nomValeurs) = (champs[0], champs[1])
        let region = Region(nom: nomRegion)
        let valeurs = Valeurs(nom: nomValeurs)
        self = Self(valeurs, dans: region)
    }
    
}

