//
//  CodagePuzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

struct CodagePuzzle {
    /// Format : id (12 caractères) + 1 espace + 81 chiffres + 2 espaces + niveau (3 caractères)
    let code: String
    
    init(_ code: String) {
        assert(code.count == 99)
        self.code = code
    }
}

extension CodagePuzzle {
    
    static let exemple1 = "0000183b305c 050703060007000800000816000000030000005000100730040086906000204840572093000409000  1.2"
    
    /// La liste des caractères du code, sous forme de String à un caractère
    var caracteres: [String] {
        code.map { String($0) }
    }
    
    /// L'identificteur dans le préfixe, sur 12 caractères
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
    
    /// Les 81 chiffres
    var chiffres: [Int] {
        sourceChiffres.map { Int(String($0))! }
    }
    
    var niveau: Double {
        let source = caracteres[((12+81+3))...].joined()
        return Double(source)!
    }

    
}
