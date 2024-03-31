//
//  FlowContainerTests.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

import Foundation
@testable import FlowContainers
import XCTest
import UIKit

fileprivate final class TestFlowContainer: FlowContainer {
    // swiftlint:disable:next force_unwrap
    weak var injectedInitialViewController: UIViewController!

    override func initialViewController() -> UIViewController {
        injectedInitialViewController
    }
}

final class FlowContainerTests: XCTestCase {
    private var flowContainer: TestFlowContainer!
    override func setUp() {
        super.setUp()
        flowContainer = TestFlowContainer()
    }

    func testStart_pushesInitialViewController() {
        let viewController = UIViewController()
        let navigationController = UINavigationController()

        flowContainer.injectedInitialViewController = viewController
        flowContainer.start(on: navigationController)
        XCTAssertEqual(navigationController.topViewController, viewController)
    }

    func testPushViewController_pushesAViewControllerOntoNavigationController() {
        let viewController = UIViewController()
        let navigationController = UINavigationController()

        flowContainer.injectedInitialViewController = viewController
        flowContainer.start(on: navigationController)
        
        let nextViewController = UIViewController()
        flowContainer.push(nextViewController, animated: false)
        
        XCTAssertEqual(navigationController.topViewController, nextViewController)
        XCTAssertEqual([viewController, nextViewController], flowContainer.orderedPushedControllers)
    }
    
    func testPresentViewController_presentsViewController() {
        let viewController = UIViewController()
        let navigationController = UINavigationController()

        flowContainer.injectedInitialViewController = viewController
        flowContainer.start(on: navigationController)
        
        let nextViewController = UIViewController()
        flowContainer.present(nextViewController, animated: false)
        
        XCTAssertEqual(navigationController.presentedViewController, nextViewController)
        XCTAssertEqual(flowContainer.presentedController, nextViewController)
    }
        
}
