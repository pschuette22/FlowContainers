//
//  DeinitListenerTests.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

@testable import FlowContainers
import Foundation
import UIKit
import XCTest

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
