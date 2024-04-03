//
//  UINavigationController+PrivateExtensions.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

#if canImport(UIKit)
    import Foundation
    import UIKit

    extension UINavigationController {
        /// Push a ``UIViewController`` onto the navigation stack and attach a completion to the ``CATransaction``
        /// - Parameters:
        ///   - viewController: ViewController to be pushed onto the stack
        ///   - animated: True if the transition should be animated
        ///   - completion: Optional completion to attach to the end of the transition
        func push(
            _ viewController: UIViewController,
            animated: Bool,
            completion: (() -> Void)?
        ) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            pushViewController(viewController, animated: animated)
            CATransaction.commit()
        }

        /// Update the navigation stack to a set of specific``UIViewController``s and attach a completion to the ``CATransaction``
        /// - Parameters:
        ///   - viewControllers: Array of ViewControllers which should represent the navigation stack
        ///   - animated: True if the transition should be animated
        ///   - completion: Optional completion to attach to the end of the transition
        func setViewControllers(
            _ viewControllers: [UIViewController],
            animated: Bool,
            completion: (() -> Void)?
        ) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            setViewControllers(viewControllers, animated: animated)
            CATransaction.commit()
        }

        /// Pop the navigation stack back to a specific ``UIViewController`` and attach a completion to the ``CATransaction``
        /// - Parameters:
        ///   - viewController: ViewController that should ultimately be at the top of the Navigation stack
        ///   - animated: True if the transition should be animated
        ///   - completion: Optional completion to attach to the end of the transition
        func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            _ = popToViewController(viewController, animated: animated)
            CATransaction.commit()
        }
    }

#endif
