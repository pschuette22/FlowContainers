//
//  BlueFlowViewControllerFactory.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/5/24.
//

import Foundation
import UIKit

protocol BlueFlowViewControllerFactoryProtocol {
    func buildFirstViewController() -> UIViewController
}

final class BlueFlowViewControllerFactory: BlueFlowViewControllerFactoryProtocol {
    func buildFirstViewController() -> UIViewController {
        FirstBlueViewController()
    }
}
