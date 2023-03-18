//
//  Atomes Swift.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 18/03/2023.
//

import Foundation

// MARK: - Atomes Swift

/// Les valeurs Swift de base : String, Int, Double, Bool  vérifient le protocole InstanciableParNom, et donc CodableEnLitteral.
/// Leur représentation en littéral est une String.
/// Le type String est spécial car c'est une sorte de boucle du bootstrap. Il doit vérifier UnLitteral
/// puisque d'autres typs s'en servent comme littéral.


extension String: InstanciableParNom, UnLitteral {
    
    public var nom: String {
        self.debugDescription
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

