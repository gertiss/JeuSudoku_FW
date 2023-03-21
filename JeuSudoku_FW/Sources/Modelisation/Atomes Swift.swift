//
//  Atomes Swift.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 18/03/2023.
//

import Foundation

// MARK: - Atomes Swift

/// Les valeurs Swift de base : String, Int, Double, Bool  vérifient le protocole InstanciableParNom, et donc CodableEnLitteral. Ils sont dans l'univers "sémantique" des objets.
/// Leur représentation en littéral est une String.


/// Le type String est spécial car c'est une sorte de boucle du bootstrap.
/// Il doit vérifier UnLitteral puisque d'autres types s'en servent comme littéral.
/// Il est à la fois dans l'univers "sémantique" des objets et dans l'univers "syntaxique" des littéraux.
/// C'est un littéral atomique, car représentable en String avec `codeSwift`,
/// et un objet atomique car InstanciableParNom et représentable en String avec `nom`.
/// La boucle vient de ce que `codeSwift == nom`
/// Mais contrairement à ce qu'on pourrait penser, le nom d'une String n'est pas self, c'est debugDescription.
extension String: InstanciableParNom, UnLitteral {
    
    public var nom: String {
        self
    }
        
    public var codeSwift: String {
        nom
    }
    
    /// litteral est de la forme "\"abc\""
    /// Il faut enlever les guillemets extérieurs, et on obtient la String "abc"
    public init(nom: String) {
        let guillemet = CharacterSet(charactersIn: "\"")
        self = nom.trimmingCharacters(in: guillemet)
    }

}

extension Int: InstanciableParNom  {
    
    public var nom: String {
        String(self)
    }
    
    /// litteral est de la forme "123". On obtient un Int 123
    public init(nom: String) {
        self = Int(nom)!
    }

}

extension Double: InstanciableParNom {

    public var nom: String {
        String(self)
    }
    
    /// litteral est de la forme "0.123", on obtient un Double 0.123
    public init(nom: String) {
        self = Double(nom)!
    }

}

extension Bool: InstanciableParNom {
    
    public var nom: String {
        String(self)
    }
    
    /// litteral est de la forme "true" ou "false". On obtient un Bool true ou false.
    public init(nom: String) {
        self = Bool(nom)!
    }

}

