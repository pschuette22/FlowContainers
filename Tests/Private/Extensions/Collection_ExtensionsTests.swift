//
//  Collection_ExtensionsTests.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

@testable import FlowContainers
import Foundation
import XCTest

final class Collection_ExtensionsTests: XCTestCase {
    func testSafeIndex_whenIndexIsOutOfBounds_isNil() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertNil(array[safe: 5])
    }

    func testSafeIdndex_whenIndexIsInBounds_isElementAtIndex() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertEqual(array[2], 3)
    }

    func testIsNotEmpty_whenArrayHasNoElements_isFalse() {
        XCTAssertFalse([].isNotEmpty)
    }

    func testIsNotEmpty_whenArrayHasElements_isTrue() {
        XCTAssertTrue([1, 2, 3].isNotEmpty)
    }
}
