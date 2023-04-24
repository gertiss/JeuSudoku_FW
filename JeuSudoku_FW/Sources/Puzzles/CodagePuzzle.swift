//
//  CodagePuzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Codage suivant le format de la banque Sudoku Exchange :
/// un puzzle est codé sur une ligne de 99 caractères.
public struct CodagePuzzle {
    /// Format : id (12 caractères) + 1 espace + 81 chiffres + 2 espaces + niveau (3 caractères)
    public let code: String
    
    /// code doit être valide syntaxiquement, sinon fatalError
    /// On ne teste pas la validité sémantique
    public init(_ code: String) {
        assert(code.count == 99)
        self.code = code
        guard essaiChiffres != nil else {
            fatalError("chiffres invalides")
        }
    }
}

public extension CodagePuzzle {
    
    static let exemple1 = "0000183b305c 050703060007000800000816000000030000005000100730040086906000204840572093000409000  1.2"
    
    /// La liste des caractères du code, sous forme de String à un caractère
    var caracteres: [String] {
        code.map { String($0) }
    }
    
    /// L'identificateur dans le préfixe, sur 12 caractères
    var id: String {
        caracteres.prefix(12).joined()
    }
    
    /// Les 81 caractères des chiffres
    var sourceChiffres: String {
        // Avant les chiffres, il y a 12 + 1 caractères (id + un espace)
        let resultat = caracteres[13...(12+81)].joined()
        assert(resultat.count == 81)
        return resultat
    }
    
    /// Essaye de lire les chiffres, nil si erreur.
    /// Les caractères doivent être des chiffres et il doit y en avoir 81.
    var essaiChiffres: [Int]? {
        let essai = sourceChiffres.map { Int(String($0)) }
        if essai.contains(Optional<Int>.none) {
            return nil
        }
        guard essai.count == 81 else { return nil }
        return essai.map { $0! }
    }
    
    /// Les 81 chiffres, valides
    var chiffres: [Int] {
        guard let chiffresValides = essaiChiffres else {
            fatalError("chiffres invalides")
        }
        return chiffresValides
    }
    
    var niveau: Double {
        let source = caracteres[((12 + 1 + 81 + 2))...].joined()
        return Double(source)!
    }
    
    /// Vérifie la validité syntaxique : 81 chiffres de 0 à 9. Mais pas la validité sémantique (sudoku).
    /// `saisieChiffres` ne contient que les 81 chiffres.
    /// Ils peuvent être écrits avec des espaces, tabs et return qui seront supprimés.
    /// L'indication d'absence peut être ce qu'on veut à part espace tab return (pas forcément 0).
    /// On retourne un code normalisé, avec un id et un niveau factices.
    static func codeDepuisSaisie(_ saisieChiffres: String) throws -> String {
        let chiffres = saisieChiffres.avecSuppressionEspacesTabsNewlines
            .map { Int(String($0)) == nil ? "0" : $0 }
        guard chiffres.count == 81 else {
            throw("chiffres : on attend 81 chiffres")
        }
        guard chiffres.allSatisfy({ c in
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
                .contains(c)
        }) else {
            throw("chiffres : on attend des chiffres de 0 à 9")
        }
        return "012345678901" + " " + chiffres + "  " + "1.0"
    }
    
    func chiffresLigneDansCode(_ indexLigne: Int) -> [Int] {
        chiffres[(indexLigne * 9)...(indexLigne * 9 + 8)].map { $0 }
    }
    
    var texteDessin: String {
        let lignesChiffres = (0...8)
            .map { indexLigne in
                chiffresLigneDansCode(indexLigne)
            }.map { ligneChiffres in
                ligneChiffres[0...2].map { $0.description }.joined()
                + " " + ligneChiffres[3...5].map { $0.description }.joined()
                + " " + ligneChiffres[6...8].map { $0.description }.joined()
            }
        
        let bande0 = lignesChiffres[0...2].map { $0 }.joined(separator: "\n")
        let bande1 = lignesChiffres[3...5].map { $0 }.joined(separator: "\n")
        let bande2 = lignesChiffres[6...8].map { $0 }.joined(separator: "\n")
        return [bande0, bande1, bande2].joined(separator: "\n\n").replacingOccurrences(of: "0", with: "·")
    }
}



