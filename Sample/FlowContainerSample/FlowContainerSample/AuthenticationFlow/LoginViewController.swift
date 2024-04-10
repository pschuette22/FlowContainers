//
//  LoginViewController.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import Foundation
import UIKit

final class LoginViewController: UIViewController {
    // TODO: some splash image
    private lazy var emailTextField = UITextField()
    private lazy var passwordTextField = UITextField()
    private lazy var loginButton = UIButton(configuration: .borderedProminent())
    private lazy var signUpButton = UIButton(configuration: .borderless())
    let eventChannel = AsyncChannel<StreamedEvent>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
}

// MARK: - EventStreaming

extension LoginViewController: EventStreaming {
    enum StreamedEvent: SendableEvent {
        case didAuthenticate(token: String)
    }
}

// MARK: - Subviews

extension LoginViewController {
    private func setupSubviews() {
        // Style subviews
        emailTextField.placeholder = "Email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self
        passwordTextField.placeholder = "Password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        loginButton.setTitle("Log In", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTapAction { [weak self] _ in
            self?.didTapLogIn()
        }
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTapAction { [weak self] _ in
            self?.didTapSignUp()
        }

        view.addSubviews(
            emailTextField,
            passwordTextField,
            loginButton,
            signUpButton
        )

        NSLayoutConstraint.activate([
            // Password anchors everything else in the view
            passwordTextField.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -48),
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            // Email above
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -16),
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            // Log In
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 48),
            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48),
            // Sign Up
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 48),
            signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48),
        ])
    }

    private func didTapLogIn() {}

    private func didTapSignUp() {}
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return false
    }
}
