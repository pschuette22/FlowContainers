//
//  FlowContainerTests.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

@testable import FlowContainers
import Foundation
import UIKit
import XCTest

private final class TestFlowContainer: FlowContainer {
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

    func testPushFlowContainer_pushesSecondFlowContainerInitialControllerOnToStack() {
        let viewController = UIViewController()
        let navigationController = UINavigationController()

        flowContainer.injectedInitialViewController = viewController
        flowContainer.start(on: navigationController)

        let nextFlowContainer = TestFlowContainer()
        let nextViewController = UIViewController()
        nextFlowContainer.injectedInitialViewController = nextViewController
        flowContainer.push(nextFlowContainer, animated: false)

        XCTAssertEqual(navigationController.topViewController, nextViewController)
    }

    func testPopViewController_whenFlowContainerViewControllersAreRemoved_deallocatesFlowContainer() {
        let navigationController = UINavigationController()
        weak var flowContainer: TestFlowContainer?
        autoreleasepool {
            let viewController = UIViewController()
            let fc = TestFlowContainer()
            fc.injectedInitialViewController = viewController
            flowContainer = fc
            navigationController.pushViewController(UIViewController(), animated: false)
            flowContainer?.start(on: navigationController, animated: false)
            XCTAssertEqual(navigationController.topViewController, viewController)
            navigationController.popViewController(animated: false)
        }

        XCTAssertNil(flowContainer)
    }
}
