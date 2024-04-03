//
//  NavigationBindingDelegate.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//
#if canImport(UIKit)

    import Foundation
    import UIKit

    /// Interface for an object which acts as a ``FlowContainer``'s delegate when binding and unbinding from it's ``UINavigationController``
    public protocol NavigationBindingDelegate: AnyObject {
        /// Called before a ``FlowContainer`` attaches to a ``UINavigationController``
        /// - Parameters:
        ///   - flowContainer: ``FlowContainer`` which will attach
        ///   - navigationController: ``UINavigationController`` which ``FlowContainer`` will attach to
        func willAttach(
            _ flowContainer: FlowContainer,
            to navigationController: UINavigationController
        )

        /// Called after a ``FlowContainer`` attaches to a ``UINavigationController``
        /// - Parameters:
        ///   - flowContainer: ``FlowContainer`` which did attach
        ///   - navigationController: ``UINavigationController`` which ``FlowContainer`` is now attached to
        func didAttach(
            _ flowContainer: FlowContainer,
            to navigationController: UINavigationController
        )

        /// Called when a ``FlowContainer`` no longer has any pushed or presented ``UIViewController``s
        /// - Parameters:
        ///   - flowContainer: ``FlowContainer`` whose ``UIViewController``s were all dismissed
        func didDismissAllControllers(presentedBy flowCoodinator: FlowContainer)

        /// Use to prevent a ``FlowContainer`` from automatically detatching from its ``UINavigationController``.
        /// **BEWARE** If implemented, you are responsible for detatching the ``FlowContainer`` when necessary.
        /// ```swift
        ///   myFlowContainer.detatch()
        /// ```
        ///
        /// - Parameter flowContainer: ``FlowContainer`` which is requesting to detach
        /// - Returns: True if ``FlowContainer`` should detach from it's ``UINavigationController``. False if not
        func shouldDetach(_ flowContainer: FlowContainer) -> Bool

        /// Called before a ``FlowContainer`` detaches from it's ``UINavigationController``
        /// - Parameter flowContainer: ``FlowContainer`` which is preparing to detach
        func willDetach(_ flowContainer: FlowContainer)

        /// Called after a ``FlowContainer`` has detached from it's ``UINavigationController``
        /// - Parameter flowContainer: ``FlowContainer`` which has detached from it's ``UINavigationController``
        func didDetach(_ flowContainer: FlowContainer)
    }

    // MARK: - Default implementations

    public extension NavigationBindingDelegate {
        func willAttach(
            _: FlowContainer,
            to _: UINavigationController
        ) {}
        func didAttach(
            _: FlowContainer,
            to _: UINavigationController
        ) {}
        func didDismissAllControllers(presentedBy _: FlowContainer) {}
        func shouldDetach(_: FlowContainer) -> Bool { true }
        func willDetach(_: FlowContainer) {}
        func didDetach(_: FlowContainer) {}
    }

#endif
