//
//  PresenceValeur.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 09/02/2023.
//

import Foundation

/// Une contrainte qui affirme que les `valeurs` doivent être obligatoirement présentes dans la `region`
/// Cette affirmation est définitive une fois qu'elle est démontrée. Mais elle peut être précisée par la suite.
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
    
    var estUneBijectionUnaire: Bool {
        valeurs.count == 1 &&  region.count == 1
    }
    
    var estUneBijectionBinaire: Bool {
        valeurs.count == 2 &&  region.count == 2
    }
 
    var estUneBijectionTernaire: Bool {
        valeurs.count == 3 &&  region.count == 3
    }

   var estUneBijection: Bool {
        valeurs.count == region.count
    }
    
    /// La présence d'une contrainte dans le Puzzle avec la `valeur`
    /// provoque des éliminations de cellules pour cette valeur
    /// sinon `[]`
    /// Ces éliminations sont purement géométriques et ne dépendent pas du contenu du Puzzle
    func eliminations(pour valeur: Int) -> Set<Cellule> {
        guard valeurs.contains(valeur) else {
            return []
        }
        var cellulesEliminees = Set<Cellule>()
        /// Si les cellules de self sont dans une même ligne, toutes les autres cases de la ligne sont éliminées
        if let ligne = region.ligneCommune {
            cellulesEliminees = cellulesEliminees
                .union(ligne.cellules.subtracting(self.region))
        }
        /// Si les cellules de self sont dans une même colonne, toutes les autres cases de la colonne sont éliminées
        if let colonne = region.colonneCommune {
            cellulesEliminees = cellulesEliminees
                .union(colonne.cellules.subtracting(self.region))
        }
        /// Si les cellules de self sont dans un même carré, toutes les autres cases du carré sont éliminées
        if let carre = region.carreCommun {
            cellulesEliminees = cellulesEliminees
                .union(carre.cellules.subtracting(self.region))
        }
       return cellulesEliminees
    }
    
    func eliminations(pour: Set<Int>) -> Set<Cellule> {
        var cellulesEliminees = Set<Cellule>()
        for valeur in valeurs {
            cellulesEliminees = cellulesEliminees.union(eliminations(pour: valeur))
        }
        return cellulesEliminees
    }
    
    /// L'ensemble des cases qui ne peuvent contenir aucune des valeurs de la contrainte, comme conséquence de la contrainte.
    /// Si la contrainte est une bijection unaire, il y a 20 cases éliminées.
    /// La contrainte est vue comme un émetteur d'éliminations
    /// Ces éliminations sont définitives.
    /// Toute contrainte de présence implique une contrainte "complémentaire" d'éliminations
    var eliminations: Set<Cellule> {
        eliminations(pour: valeurs)
    }
    
    var absenceComplementaire: AbsenceValeurs {
        return AbsenceValeurs(valeurs, dans: eliminations)
    }
    
}
