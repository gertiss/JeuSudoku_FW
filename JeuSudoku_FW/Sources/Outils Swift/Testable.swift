//
//  UtilisableCommeAtome.swift
//  LaboSudoku_FW
//
//  Created by Gérard Tisseau on 13/01/2023.
//

import Foundation

/// Tout type T conforme à Testable peut être utilisé comme clé dans un dico et comme élément d'un Set
/// On peut comparer deux instances avec ==
/// Pour toute instance t, on peut faire print(t), ce qui rend une description qui est le code d'un appel  à une init relisible par Swift et qui recrée une instance égale à t.
/// Toute instance t peut être codée en json et ce json peut être décodé pour redonner une instance égale.
public protocol Testable:  Hashable, CustomStringConvertible, Codable {
    
}

public extension Encodable {
    
    /// Encodage en JSON
    var json: Result<String, String> {
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
}
    
public extension Decodable {

    /// Decodage depuis JSON
    static func avecJson(_ code: String) -> Result<Self, String> where Self: Codable {
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

}

