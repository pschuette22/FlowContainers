//
//  BlueFlowContainer.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/5/24.
//

import FlowContainers
import Foundation
import UIKit

final class BlueFlowContainer: FlowContainer, NavigationBindingDelegate {
    private let controllerFactory: BlueFlowViewControllerFactoryProtocol
    // TODO: Action reducer

    init(
        controllerFactory: BlueFlowViewControllerFactoryProtocol = BlueFlowViewControllerFactory()
    ) {
        self.controllerFactory = controllerFactory
    }

    override func initialViewController() -> UIViewController {
        controllerFactory.buildFirstViewController()
    }
}
