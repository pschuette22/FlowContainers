//
//  SceneDelegate.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/5/24.
//

import Foundation
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            assertionFailure("missing scene")
            return
        }

        window = UIWindow(windowScene: windowScene)
        let rootNavigationController = UINavigationController()
        window?.rootViewController = rootNavigationController
        let firstFlow = BlueFlowContainer()
        firstFlow.start(on: rootNavigationController)
        window?.makeKeyAndVisible()
    }
}
