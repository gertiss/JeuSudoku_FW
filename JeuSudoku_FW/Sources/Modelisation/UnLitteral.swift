//
//  Litteral.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 10/03/2023.
//

import Foundation

/// Un Litteral est soit "atomique", soit "composé" (structuré).
/// C'est un peu comme une expression syntaxique structurée utilisable facilement dans les communications et dans les tests.
/// Cette expression est un peu analogue à du Lisp ou du JSON typé.
/// Mais à la différence de Json on ne cherche pas à relire un any Litteral non typé.
/// Les types Swift de base Int, Double, Bool, String sont conformes à UnLitteral.
public protocol UnLitteral: Hashable, Comparable, Identifiable, CustomStringConvertible, CodableEnJson  {
    
    /// Le texte du code Swift qui permet de recréer self
    /// L'intérêt est de pouvoir faire print(x), puis de coller le texte obtenu dans un test pour pouvoir instancier un objet.
    var codeSwift: String { get }
}

public extension UnLitteral {
    
    /// Protocole Identifiable
    var id: String {
        codeSwift
    }
        
    /// Protocole Comparable. On compare les textes par ordre alphabétique.
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.codeSwift < rhs.codeSwift
    }
    
    var description: String {
        codeSwift
    }
    
    var litteral: Self {
        self
    }
    

        
}


