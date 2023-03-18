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
public protocol UnLitteral: Hashable, Comparable, Identifiable, CustomStringConvertible, CodableEnJson  {
    
    var texte: String { get }
}

public extension UnLitteral {
    
    /// Protocole Identifiable
    var id: String {
        texte
    }
        
    /// Protocole Comparable
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.texte < rhs.texte
    }
    
    var description: String {
        // On passe par l'intermédiaire de "texte"
        // parce qu'on ne peut pas redéfinir "description" pour les objets Swift de base
        texte
    }
    
    var litteral: Self {
        self
    }
    

        
}


// MARK: - Atomes Swift

/// Les valeurs Swift de base : String, Int, Double, Bool  vérifient le protocole CodableEnLitteral.
/// Leur représentation en texte est une String entre guillemets.

public protocol UnAtomeSwift: CodableEnLitteral, UnLitteral { }

extension String: UnAtomeSwift {
    public typealias Litteral = String
    
    public var texte: String {
        self.debugDescription
    }
    
    public var litteral: Litteral {
        texte
    }
    
    /// litteral est de la forme "\"abc\""
    /// Il faut enlever les guillemets extérieurs
    public init(litteral: Litteral) {
        let guillemet = CharacterSet(charactersIn: "\"")
        self = litteral.trimmingCharacters(in: guillemet)
    }

}

extension Int: UnAtomeSwift {
    public var texte: String {
        String(self)
    }
    
    public typealias Litteral = String
    
    public var litteral: Litteral {
        texte
    }
    
    /// litteral est de la forme "123"
    public init(litteral: Litteral) {
        self = Int(litteral)!
    }

}

extension Double: UnAtomeSwift {
    public var texte: String {
        String(self)
    }
    
    public typealias Litteral = String
    
    public var litteral: Litteral {
        texte
    }
    
    /// litteral est de la forme "0.123"
    public init(litteral: Litteral) {
        self = Double(litteral)!
    }

}

extension Bool: UnAtomeSwift {
    public var texte: String {
        String(self)
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.litteral < rhs.litteral
    }

    public typealias Litteral = String
    
    public var litteral: Litteral {
        texte
    }
    
    /// litteral est de la forme "true" ou "false"
    public init(litteral: Litteral) {
        self = Bool(litteral)!
    }

}

