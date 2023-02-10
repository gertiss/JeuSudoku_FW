//
//  AbsenceValeurs.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 10/02/2023.
//

import Foundation

/// Une contrainte qui affirme que les `valeurs`sont obligatoirement absentes de la `region`.
/// Cette affirmation est définitive une fois qu'elle est démontrée. Mais elle peut être précisée par la suite.

public struct AbsenceValeurs: Testable, Comparable, InstanciableParNom {
    
    public let valeurs: Set<Int>
    public let region: Set<Cellule>
    
    /// `PresenceValeurs([1, 2], dans: [Cellule(0,0), Cellule(0, 1)])`
    public init(_ valeurs: Set<Int>, dans region: Set<Cellule>) {
        assert(valeurs.count <= region.count)
        self.valeurs  = valeurs
        self.region = region
    }
    public var description: String {
        "AbsenceValeurs(\(valeurs), dans: \(region))"
    }
    
    /// on ordonne alphabétiquement suivant les noms des régions
    public static func < (lhs: AbsenceValeurs, rhs: AbsenceValeurs) -> Bool {
        lhs.region.nom < rhs.region.nom
    }
    
    /// `"AaAb_12"`
    public var nom: String {
        "\(region.nom)_\(valeurs.nom)"
    }
    
    /// `AbsenceValeurs(nom: "AaAb_12")`
    public init(nom: String) {
        let champs = nom.components(separatedBy: "_")
        assert(champs.count == 2)
        let (nomRegion, nomValeurs) = (champs[0], champs[1])
        let region = Set<Cellule>(nom: nomRegion)
        let valeurs = Set<Int>(nom: nomValeurs)
        self = Self(valeurs, dans: region)
    }
}
