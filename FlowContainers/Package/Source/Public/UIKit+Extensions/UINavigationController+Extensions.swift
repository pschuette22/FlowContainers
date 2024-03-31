//
//  UINavigationController+Extensions.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

import Foundation
import UIKit

public extension UINavigationController {
    /// Push a contained flow onto the navigation stack.
    /// This will automatically start the flow
    /// - Parameters:
    ///   - flowContainer: ``FlowContainer`` implementation to be pushed onto the navigation stack.
    ///   - animated: True if transition should be animated. Nil if animation decision should be deferred. Nil by default
    ///   - completion: (optional) completion to be called after the flow is pushed onto the stack
    func push(
        _ flowContainer: FlowContainer,
        animated: Bool? = nil,
        completion: (() -> Void)? = nil
    ) {
        flowContainer.start(on: self, animated: animated, completion: completion)
    }
}
