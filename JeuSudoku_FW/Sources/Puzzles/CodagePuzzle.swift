//
//  CodagePuzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Codage suivant le format de la banque Sudoku Exchange.
public struct CodagePuzzle {
    /// Format : id (12 caractères) + 1 espace + 81 chiffres + 2 espaces + niveau (3 caractères)
    public let code: String
    
    /// code doit être valide, sinon fatalError
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
    
    /// Le puzzle créé à partir du code. On oublie id et niveau.
    /// On suppose le code correct.
    var puzzle: Puzzle {
        Puzzle(code)
    }
    
    /// `saisieChiffres` ne contient que les 81 chiffres.
    /// Ils peuvent être écrits avec des espaces, tabs et return qui seront supprimés.
    /// On retourne un code normalisé, avec un id et un niveau factices.
    static func codeDepuisSaisie(_ saisieChiffres: String) -> String {
        let chiffres = saisieChiffres.avecSuppressionEspacesTabsNewlines
        return "012345678901" + " " + chiffres + "  " + "1.0"
    }
}


