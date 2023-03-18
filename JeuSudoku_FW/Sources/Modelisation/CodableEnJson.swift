//
//  CodableEnJson.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 18/03/2023.
//

import Foundation

public protocol CodableEnJson: Codable {
    
    // Fonctions directes avec fatalError si échec
    
    var json: String { get }
    static func avecJson(_ code: String) throws -> Self
    
    // Fonctions avec Result
    
    var jsonResult: Result<String, String> { get }
    static func avecJsonResult(_ code: String) -> Result<Self, String>
    
    // fonctions avec try
    
    func jsonThrows() throws -> String
    static func avecJsonThrows(_ code: String) throws -> Self
    

}

public extension CodableEnJson {
    
    // MARK: Encodage
    
    var jsonResult: Result<String, String> {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            guard let texte = String(data: data, encoding: .utf8) else {
                return .failure("\(Self.self) Codage json : Impossible de créer data")
            }
            return .success(texte)
        } catch {
            return .failure("\(Self.self) Erreur de décodage json : \(error)")
        }
    }
    
    func jsonThrows() throws -> String {
        switch jsonResult {
        case.success(let code):
            return code
        case .failure(let erreur):
            throw erreur
        }
    }

    /// encode en json ou sinon fatalError()
    var json: String {
        try! jsonThrows()
    }

    // MARK: Decodage
    
    static func avecJsonResult(_ code: String) -> Result<Self, String> where Self: Codable {
        let decoder = JSONDecoder()
        guard let data = code.data(using: .utf8) else {
            return .failure("\(Self.self) Decodage: Impossible de créer data. Le code est censé être du json valide en utf8")
        }
        do {
            let instance = try decoder.decode(Self.self, from: data)
            return .success(instance)
        } catch {
            return .failure("\(Self.self) Erreur de décodage json : \(error)")
        }
    }
    
    static func avecJsonThrows(_ code: String) throws -> Self {
        switch avecJsonResult(code) {
        case .success(let objet):
            return objet
        case .failure(let erreur):
            throw erreur
        }
    }

    /// decode depuis json ou sinon fatalError()
    static func avecJson(_ code: String) throws -> Self {
        try! avecJsonThrows(code)
    }

}
