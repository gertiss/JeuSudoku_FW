//
//  UtilisableCommeAtome.swift
//  LaboSudoku_FW
//
//  Created by Gérard Tisseau on 13/01/2023.
//

import Foundation

/// Tout type T conforme à UnAtome peut être utilisé comme clé dans un dico.
/// On peut comparer deux instances avec ==
/// Pour toute instance t, on peut faire print(t), ce qui rend une description qui est le code d'un appel  à une init relisible par Swift et qui recrée une instance égale à t.
/// Toute instance t peut être codée en json et ce json peut être décodé pour redonner une instance égale.
/// Toute instance a un nom, qui a le rôle de id pour le protocole Identifiable
public protocol Testable: Hashable, CustomStringConvertible, Codable, Identifiable  {
    var nom: String { get }
}

public extension Testable {
    var id: String { nom }
}
