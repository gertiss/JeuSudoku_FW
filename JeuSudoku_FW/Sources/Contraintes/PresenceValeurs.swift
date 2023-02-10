//
//  PresenceValeur.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 09/02/2023.
//

import Foundation

/// Une contrainte qui affirme que les `valeurs` doivent être obligatoirement présentes dans la `region`
/// Cette affirmation est définitive une fois qu'elle est démontrée.
public struct PresenceValeurs: Testable, Comparable, InstanciableParNom {
    
    public let valeurs: Set<Int>
    public let region: Set<Cellule>
    
    /// `PresenceValeurs([1, 2], dans: [Cellule(0,0), Cellule(0, 1)])`
    public init(_ valeurs: Set<Int>, dans region: Set<Cellule>) {
        assert(valeurs.count <= region.count)
        self.valeurs  = valeurs
        self.region = region
    }
    
    public var description: String {
        "PresenceValeurs(\(valeurs), dans: \(region))"
    }
    
    /// on ordonne alphabétiquement suivant les noms des régions
    public static func < (lhs: PresenceValeurs, rhs: PresenceValeurs) -> Bool {
        lhs.region.nom < rhs.region.nom
    }
    
    /// `"AaAb_12"`
    public var nom: String {
        "\(region.nom)_\(valeurs.nom)"
    }
    
    /// `PresenceValeurs(nom: "AaAb_12")`
    public init(nom: String) {
        let champs = nom.components(separatedBy: "_")
        assert(champs.count == 2)
        let (nomRegion, nomValeurs) = (champs[0], champs[1])
        let region = Set<Cellule>(nom: nomRegion)
        let valeurs = Set<Int>(nom: nomValeurs)
        self = Self(valeurs, dans: region)
    }
    
}

public extension PresenceValeurs {
    
    var estUneBijection: Bool {
        valeurs.count == region.count
    }
    
    var eliminations: Set<Cellule> {
        
        /// Si la région est réduite à une cellule, on élimine 20 autres cellules dépendantes
        if region.count == 1 {
            let cellule = region.uniqueElement
            return cellule.dependantes
        }
        /// Si les cellules sont dans une même ligne, toutes les autres cases de la ligne sont éliminées
        if let ligne = region.ligneCommune {
            return ligne.cellules.subtracting(self.region)
        }
        /// Si les cellules sont dans une même colonne, toutes les autres cases de la colonne sont éliminées
        if let colonne = region.colonneCommune {
            return colonne.cellules.subtracting(self.region)
        }
        return []
    }
    
}
