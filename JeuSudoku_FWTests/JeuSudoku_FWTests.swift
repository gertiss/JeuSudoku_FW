//
//  JeuSudoku_FWTests.swift
//  JeuSudoku_FWTests
//
//  Created by Gérard Tisseau on 31/01/2023.
//

import XCTest
@testable import JeuSudoku_FW

final class JeuSudoku_FWTests: XCTestCase {

    override func setUpWithError() throws {
        print()
    }

    override func tearDownWithError() throws {
        print()
    }

    func testBijection() {
        let bijection = Bijection([Cellule(3, 5), Cellule(3, 6)], [1, 2])
        XCTAssertEqual(bijection.nom, "DfDg_12")
    }
}
