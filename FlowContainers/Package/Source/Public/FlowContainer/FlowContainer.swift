//
//  FlowContainer.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

import Foundation
import UIKit

/// Base class for a container object which bundles a collection of ``UIViewControllers``s together to produce a unified experience or composed result
///
/// FlowContainer must be subclassed with ``FlowContainer/initialViewController()`` overridden.
/// ```swift
/// final class MyFlowContainer: FlowContainer {
///   override func initialViewController() -> UIViewController {
///       return MyViewController()
///   }
///   ...
/// }
/// ```
///
/// It is recommended to create an extension dedicated to ViewController building or implement a factory pattern
/// ```swift
/// extension MyFlowContainer {
///    func buildFirstViewController() -> UIViewController { ... }
///
///    func buildSecondViewController() -> UIViewController { ... }
///
///    func buildThirdViewController() -> UIViewController { ... }
/// }
/// ```
///
open class FlowContainer: NSObject {
  /// Identifier added to the initial view controller of the flow
  public static let initialViewControllerIdentifier = "initialViewController"
  private final var associationKey: Void?
  public private(set) weak var navigationController: UINavigationController?
  public weak var bindingDelegate: NavigationBindingDelegate?

  /// Observe controllers this coordinator has pushed onto the navigation controller
  private var pushedControllerObservers = NSMapTable<NSString, UIViewController>(
    keyOptions: .strongMemory,
    valueOptions: .weakMemory
  )
  /// Observe the controller this coordinator has presented over the navigation controller
  private(set) weak var presentedController: UIViewController?

  public init(
    bindingDelegate: NavigationBindingDelegate? = nil
  ) {
    super.init()
    self.bindingDelegate = bindingDelegate ?? (self as? NavigationBindingDelegate)
  }

  /// Provide the initial ``UIViewController`` for the flow.
  /// Do not retain this view controller within the flow, it should only be composed.
  /// **GOTCHA** This must be implemented! Fail loudly if it is not
  open func initialViewController() -> UIViewController {
    fatalError("`initialViewController()` was not overridden in \(String(describing: type(of: self)))!")
  }

  /// Start the flow using the provided ``UINavigationController``.
  /// This attaches the FlowContainer implementation to the ``UINavigationController`` and pushes the initial ``UIViewController`` onto it's navigation stack
  /// - Parameters:
  ///   - navigationController: ``UINavigationController`` the FlowContainer should attach to
  ///   - animated: True if initial ``UIViewController`` should be pushed onto the ``UINavigationController`` stack with default animation. Defaults to false when the NavigationStack is empty and true when it is not
  ///   - completion: (optional) completion to be called after the flow is started
  public func start(
    on navigationController: UINavigationController,
    animated: Bool? = nil,
    completion: (() -> Void)? = nil
  ) {
    attach(to: navigationController)
    push(
      initialViewController(),
      id: Self.initialViewControllerIdentifier,
      animated: animated ?? navigationController.viewControllers.isNotEmpty,
      completion: completion
    )
  }

  /// Unwind and, in turn, deallocate the ``FlowContainer``
  /// This function will dismiss all presented ``UIViewController``s before unwinding its views from the navigation stack
  /// - Parameters:
  ///   -  animated: True if the dismiss and unwind animations should be done with animations.
  ///   - completion: (optional) completion to be called after the flow is completed
  public func finish(
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
      if navigationController?.presentedViewController != nil {
          presentedController?.dismiss(animated: animated)
      }

    guard let navigationController else { return }

    let remove = Set(pushedControllers.map(\.hash))

    let navigationStack = navigationController.viewControllers.filter { !remove.contains($0.hashValue) }
    if navigationStack.isEmpty {
      navigationController.dismiss(animated: animated, completion: completion)
    } else {
      navigationController.setViewControllers(navigationStack, animated: animated, completion: completion)
    }
  }
}

// MARK: - Child Access

extension FlowContainer {
  /// Retrieve a ``UIViewController`` on the navigation stack via an ID
  /// - Parameter id: Unique Identifier for this ``UIViewController``
  /// - Returns: ``UIViewController`` identified by _id_, if it exists, on the navigation stack. Nil if no such ViewController is found
  public func pushedViewController(id: String) -> UIViewController? {
    pushedControllerObservers.object(forKey: NSString(string: id))
  }

  /// An array of ``UIViewController``s pushed by this FlowContainer in the order they exist on the NavigationStack.
  public var orderedPushedControllers: [UIViewController] {
    let pushedControllerHashes = Set(pushedControllers.map(\.hash))
    return navigationController?.viewControllers.filter { pushedControllerHashes.contains($0.hash) } ?? []
  }

  /// An array of ``UIViewController``s pushed by this FlowContainer. Order is not guaranteed.
  public var pushedControllers: [UIViewController] {
    pushedControllerObservers
      .objectEnumerator()?
      .allObjects
      .compactMap { $0 as? UIViewController } ?? []
  }
}

// MARK: - Push / Present

extension FlowContainer {
  /// Push a ViewController onto the navigation stack
  /// - Parameters:
  ///   - viewController: ``UIViewController`` to be pushed
  ///   - id: Unique identifier for this ViewController. Generated by default.
  ///   - animated: True if the ViewController should be pushed with animation. True by default
  ///   - completion: (optional) completion to be called after the flow is pushed onto the stack
  public func push(
    _ viewController: UIViewController,
    id: String = UUID().uuidString,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let navigationController else {
      assertionFailure(
        "Attempted to push \(String(describing: viewController)), but reference to NavigationController was lost!"
      )
      return
    }

    addPushedController(viewController, id: id, file: file, line: line)
    navigationController.push(viewController, animated: animated, completion: completion)
  }

  /// Present a ViewController modally
  /// - Parameters:
  ///   - viewController: ``UIViewController`` to be presented modally
  ///   - animated: True if the ViewController should be presented with animation. True by default
  ///   - completion: (optional) completion to be called after the ViewController is presented over the current flow
  public func present(
    _ viewController: some UIViewController,
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    guard let navigationController else {
      assertionFailure(
        "Attempted to present \(String(describing: viewController)), but reference to NavigationController was lost!"
      )
      return
    }

    addPresentedController(viewController)
    // TODO: optionally reach for custom animator
    navigationController.present(viewController, animated: animated, completion: completion)
  }

  /// Push an instance of ``FlowContainer`` onto the navigation stack
  /// - Parameters:
  ///   - flowContainer: ``FlowContainer`` which will be pushed onto the navigation stack
  ///   - animated: True if transition should be animated. Nil if decision should be deferred. Nil by default
  ///   - completion: (optional) completion to be called after the flow is pushed onto the stack
  public func push(
    _ flowContainer: FlowContainer,
    animated: Bool? = nil,
    completion: (() -> Void)? = nil
  ) {
    guard let navigationController else {
      assertionFailure(
        "Attempted to push \(String(describing: flowContainer)), but reference to NavigationController was lost!"
      )
      return
    }

    navigationController.push(flowContainer, animated: animated, completion: completion)
  }

  /// Present an instance of ``FlowContainer`` modally over the current flow
  /// - Parameters:
  ///   - flowContainer: ``FlowContainer`` to be presented
  ///   - navigationController: ``UINavigationController`` the presented FlowContainer should attach to
  ///   - animated: True if transition should be animated. True by default.
  ///   - completion: (optional) completion to be called after the new flow is presented over the current flow
  public func present(
    _ flowContainer: FlowContainer,
    with navigationController: UINavigationController = UINavigationController(),
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    guard let currentNavigationController = self.navigationController else {
      assertionFailure(
        "Attempted to present \(String(describing: flowContainer)), but reference to NavigationController was lost!"
      )
      return
    }

    addPresentedController(navigationController)
    // TODO: optionally reach for custom animator
    currentNavigationController.present(
      flowContainer,
      navigationController: navigationController,
      animated: animated,
      completion: completion
    )
  }
}

// MARK: - Pop

extension FlowContainer {
  /// Pop navigation stack back to a ``UIViewController`` based on position in the flow
  /// If position is out of index, nothing happens.
  /// - Parameters:
  ///   - position: Position within the flow the NavigationStack should be popped to.
  ///   - animated: True if the transition should be animated. True by default
  ///   - completion: (optional) completion to be called once the ViewController at the given position is at the top of the navigation stack
  public func pop(toPosition position: Int, animated: Bool = true, completion: (() -> Void)? = nil) {
    guard let controller = orderedPushedControllers[safe: position] else { return }

    navigationController?.popToViewController(controller, animated: animated, completion: completion)
  }

  /// Pop the navigation stack back to a view controllre based on the view controller's unique identifier.
  /// If a ViewController with id is not found, nothing happens.
  /// - Parameters:
  ///   - id: Unique identifier of the ``UIViewController``
  ///   - animated: True if the transition should be animated. True by default
  ///   - completion: (optional) completion to be called once the ViewController specified by ID is at the top of the navigation stack
  public func pop(toControllerWithId id: String, animated: Bool = true, completion: (() -> Void)? = nil) {
    guard let controller = pushedViewController(id: id) else { return }

    navigationController?.popToViewController(controller, animated: animated, completion: completion)
  }
}

// MARK: - Attach / Detach

extension FlowContainer {
  /// Attach the flow coordinator to the memory allocation of the ``UINavigationController``
  /// - Parameter navigationController: controller which should dictate FlowContainer allocation
  private func attach(to navigationController: UINavigationController) {
    guard self.navigationController == nil else {
      assertionFailure(
        "\(String(describing: self)) is already attached to a NavigationController! You must explicitly detatch first"
      )
      return
    }

    bindingDelegate?.willAttach(self, to: navigationController)
    self.navigationController = navigationController

    objc_setAssociatedObject(
      navigationController,
      &associationKey,
      self,
      .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    )

    bindingDelegate?.didAttach(self, to: navigationController)
  }

  private func detachIfNeeded() {
    if bindingDelegate?.shouldDetach(self) ?? true {
      detach()
    }
  }

  /// Explicitly detach the FlowContainer from the ``UINavigationController``
  /// **NOTE:** This does _not_ unwind the child ``UIViewController``s presented by the FlowContainer
  /// If you want to unwind the FlowContainer before detaching look for ``FlowContainer/finish(animated:)``
  public func detach() {
    guard let navigationController else { return }

    bindingDelegate?.willDetach(self)

    let strongSelf = self
    objc_setAssociatedObject(
      navigationController,
      &associationKey,
      nil,
      .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    )

    self.navigationController = nil

    bindingDelegate?.didDetach(strongSelf)
  }
}

// MARK: - Child memory management

extension FlowContainer {
  private func addPushedController(
    _ controller: UIViewController,
    id: String = UUID().uuidString,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let key = NSString(string: id)
    assert(
      pushedControllerObservers.object(forKey: key) == nil,
      "Unexpectedly overwritting pushedViewController reference with id \(id)!",
      file: file,
      line: line
    )
      DeinitListener(observe: controller) { [weak self, key] in
          self?.pushedControllerObservers.removeObject(forKey: key)
          self?.didDeinitChild()
        }
      
    pushedControllerObservers.setObject(
      controller,
      forKey: key
    )
  }

  private func addPresentedController(
    _ controller: UIViewController,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    assert(
      presentedController?.isBeingDismissed != false, // presented controller is nil or being dismissed
      "Attempting to present \(String(describing: controller)) when one is already presented! Dismiss the presented view controller first.",
      file: file,
      line: line
    )

      DeinitListener(observe: controller) { [weak self] in
          self?.didDeinitChild()
      }
    presentedController = controller
  }

  private func didDeinitChild() {
    guard pushedControllers.isEmpty && presentedController == nil else { return }

    bindingDelegate?.didDismissAllControllers(presentedBy: self)
    detachIfNeeded()
  }
}
