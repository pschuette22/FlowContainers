//
//  DeinitListenerTests.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

import Foundation
@testable import FlowContainers
import XCTest
import UIKit

public final class DeinitListenerTests: XCTestCase {
    @MainActor
    func test_whenObservedObjectDeinits_onDeinitIsCalled() async {
        let expectation = XCTestExpectation(description: "DeinitCallback is called")
        autoreleasepool {
            let viewController = UIViewController()
            DeinitListener(observe: viewController) {
                expectation.fulfill()
            }
        }
        await fulfillment(of: [expectation], timeout: .normalTimeout)
    }
}
