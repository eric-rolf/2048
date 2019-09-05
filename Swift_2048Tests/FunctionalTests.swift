//
//  FunctionalTests.swift
//  Swift_2048Tests
//
//  Created by Eric Rolf on 8/26/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import XCTest
@testable import Swift_2048

class FunctionalTests: XCTestCase {

    var data = [Int]()

    override func setUp() {
        data = [3, 4, 2, 5, 7, 3, 34, 5, 4, 34, 234, 23, 2345, 234, 234, 2345, 2345, 2346,
                345, 3457, 3567, 456, 234, 1, 2345, 346, 3456, 23, 5345, 43, 86, 5, 6, 45,
                64, 56, 456, 45, 4, 6, 3, 3, 634, 1, 3, 34, 41, 34, 42, 4, 6, 3345, 67, 34,
                6345, 34, 6345, 346, 345, 345, 6346, 34, 234, 24, 45, 4567, 6874, 4568, 357,
                345, 34265, 34, 234, 345, 634, 5735, 67, 3456, 34, 23, 23, 4, 3, 34, 45, 7,
                62, 7, 8765, 45, 6, 65, 4, 5678, 7, 3, 77, 6, 3, 2, 3, 17, 3, 32, 3, 4, 56,
                433, 3, 2, 4, 3, 4, 3, 2, 6, 2, 456, 3456, 34, 5, 32, 45, 7, 45, 9, 6, 8,
                64, 56, 4, 56, 45, 6, 46, 456, 45, 645, 6, 3, 23, 24, 4, 345, 7, 54, 5367,
                645, 34256, 45, 4567, 687, 56, 5, 4, 76, 3, 2, 73, 7453547, 2, 453, 2, 2,
                12, 34, 4, 56, 4, 7, 5, 3, 3, 5, 37, 546, 56, 567, 45, 45, 34, 53, 34, 457,
                43, 56, 4, 6, 45, 34, 34, 456, 4, 6, 45, 235, 2, 2, 345, 6, 2, 456, 3, 1, 345,
                63, 7, 3567, 45, 680, 8]
    }

    override func tearDown() {
        data.removeAll()
    }

    func testHistogram() {

        let output = [357: 1, 65: 1, 62: 1, 645: 2, 76: 1, 8: 2, 453: 1, 53: 1, 5: 7, 345: 8,
                      6346: 1, 64: 2, 7453547: 1, 5367: 1, 54: 1, 546: 1, 67: 2, 680: 1, 9: 1,
                      2346: 1, 37: 1, 6874: 1, 73: 1, 42: 1, 4567: 2, 41: 1, 34256: 1, 8765: 1,
                      7: 8, 12: 1, 234: 6, 24: 2, 43: 2, 456: 6, 77: 1, 34: 16, 235: 1, 32: 2,
                      2345: 4, 6345: 2, 634: 2, 45: 15, 34265: 1, 3567: 2, 4568: 1, 23: 5,
                      3345: 1, 86: 1, 3: 19, 4: 16, 46: 1, 3457: 1, 567: 1, 5735: 1, 17: 1,
                      687: 1, 5678: 1, 63: 1, 2: 12, 1: 3, 6: 12, 346: 2, 3456: 3, 433: 1,
                      5345: 1, 56: 8, 457: 1]

        XCTAssertEqual(data.histogram, output)
    }

    func testHistorgramPerformance() {
        // This is an example of a performance test case.
        self.measure {
            let output = data.histogram
            XCTAssertEqual(data.histogram, output)
        }

    }

}
