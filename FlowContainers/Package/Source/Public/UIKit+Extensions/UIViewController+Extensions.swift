//
//  UIViewController+Extensions.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

import Foundation
import UIKit

public extension UIViewController {
    /// Presents a ``FlowContainer`` modally
    /// - Parameters:
    ///   - flowContainer: ``FlowContainer`` implementation
    ///   - navigationController: ``NavigationController`` to attach the flow to. Defaults to a new ``NavigationController`` instance
    ///   - animated: Pass true to animate the presentation; otherwise, pass false. True by default
    ///   - completion: (optional) completion to be called after the flow is presented
    func present(
        _ flowContainer: FlowContainer,
        navigationController: UINavigationController = UINavigationController(),
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        flowContainer.start(on: navigationController)
        present(navigationController, animated: animated, completion: completion)
    }
}
