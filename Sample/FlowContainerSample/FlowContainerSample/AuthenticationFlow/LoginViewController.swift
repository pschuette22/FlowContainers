//
//  LoginViewController.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import Foundation
import UIKit
import AsyncAlgorithms

final class LoginViewController: UIViewController {
    private lazy var emailTextField = UITextField()
    private lazy var passwordTextField = UITextField()
    private lazy var loginButton = UIButton()
    private lazy var signUpButton = UIButton()
    let eventChannel = AsyncChannel<StreamedEvent>()
}

extension LoginViewController: EventStreaming {
    enum StreamedEvent: SendableEvent {
        case didTapSignUp
    }
}
