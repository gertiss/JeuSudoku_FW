//
//  VueGT.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 07/03/2023.
//

import Foundation
import SwiftUI

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
