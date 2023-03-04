//
//  API.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 28/02/2023.
//

import Foundation
import SwiftUI

public func suiteDesCoups(presences: String) -> Result<String, String> {
    if presences.count < 100 {
        return .success(String(presences.prefix(10)))
    } else {
        return .failure("Erreur suiteDesCoups")
    }
}

public func vueGT(presences: String) -> VueGT {
    VueGT(presences: presences)
}

public struct VueGT: View {
    
    var presences: String

    public var body: some View {
        HStack {
            Text("VueGT")
            if presences.count < 100 {
                Text(String(presences.prefix(10)))
            } else {
                Text("?")
            }
        }

    }
}
