//
//  AuthenticationFlowContainer.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import FlowContainers
import Foundation
import UIKit

final class AuthenticationFlowContainer: FlowContainer {
    override func initialViewController() -> UIViewController {
        // TODO: wire in events
        LoginViewController()
    }
}
