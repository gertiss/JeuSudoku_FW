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
    
    func testCodagePuzzle() {
        let codage = CodagePuzzle(CodagePuzzle.exemple1)
        XCTAssertEqual(codage.caracteres.count, 99)
        XCTAssertEqual(codage.id, "0000183b305c")
        XCTAssertEqual(codage.sourceChiffres, "050703060007000800000816000000030000005000100730040086906000204840572093000409000")
        XCTAssertEqual(codage.chiffres, [0, 5, 0, 7, 0, 3, 0, 6, 0, 0, 0, 7, 0, 0, 0, 8, 0, 0, 0, 0, 0, 8, 1, 6, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 1, 0, 0, 7, 3, 0, 0, 4, 0, 0, 8, 6, 9, 0, 6, 0, 0, 0, 2, 0, 4, 8, 4, 0, 5, 7, 2, 0, 9, 3, 0, 0, 0, 4, 0, 9, 0, 0, 0])
        XCTAssertEqual(codage.niveau, 1.2)
        
        let nomsBijections = Puzzle(CodagePuzzle.exemple1).bijections
            .map { $0.nom }
            .sorted()
        
        XCTAssertEqual(nomsBijections, ["Ab_5", "Ad_7", "Af_3", "Ah_6", "Bc_7", "Bg_8", "Cd_8", "Ce_1", "Cf_6", "De_3", "Ec_5", "Eg_1", "Fa_7", "Fb_3", "Fe_4", "Fh_8", "Fi_6", "Ga_9", "Gc_6", "Gg_2", "Gi_4", "Ha_8", "Hb_4", "Hd_5", "He_7", "Hf_2", "Hh_9", "Hi_3", "Id_4", "If_9"])
    }
}
