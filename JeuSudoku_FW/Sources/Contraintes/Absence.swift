//
//  AbsenceValeurs.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 10/02/2023.
//

import Foundation

/// Une contrainte qui affirme que les `valeurs`sont obligatoirement absentes de la `region`.
/// Cette affirmation est définitive une fois qu'elle est démontrée. Mais elle peut être précisée par la suite.

public struct Absence: Testable, InstanciableParNom {
    
    public let valeurs: Valeurs
    public let region: Region
    
    /// `AbsenceValeurs([1, 2], dans: [Cellule(0,0), Cellule(0, 1)])`
    public init(_ valeurs: Valeurs, dans region: Region) {
        assert(valeurs.count <= region.count)
        self.valeurs  = valeurs
        self.region = region
    }
    public var description: String {
        "AbsenceValeurs(\(valeurs), dans: \(region))"
    }
        
    /// `"¬AaAb_12"`
    public var nom: String {
        "¬\(region.nom)_\(valeurs.nom)"
    }
    
    /// `AbsenceValeurs(nom: "¬AaAb_12")`
    public init(nom: String) {
        assert(nom.hasPrefix("¬"))
        let info = String(nom.dropFirst())
        let champs = info.components(separatedBy: "_")
        assert(champs.count == 2)
        let (nomRegion, nomValeurs) = (champs[0], champs[1])
        let region = Region(nom: nomRegion)
        let valeurs = Valeurs(nom: nomValeurs)
        self = Self(valeurs, dans: region)
    }
    
    /// Redéfinition de l'opérateur `<` défini par défaut dans InstanciableParNom.
    /// On ordonne alphabétiquement suivant les noms des régions PUIS suivant les valeurs.
    /// Reste compatible avec la définition par défaut : définition locale => définition par défaut.
    public static func < (lhs: Absence, rhs: Absence) -> Bool {
        lhs.region.nom < rhs.region.nom && rhs.valeurs.nom < lhs.valeurs.nom
    }

}
