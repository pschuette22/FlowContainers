//
//  MainViewController.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import Foundation
import UIKit

final class MainViewController: UIViewController {
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var presentLoginButton = UIButton(configuration: .borderedProminent())
    private lazy var loginLockedFeatureButton = UIButton(configuration: .borderedProminent())
    let eventChannel = AsyncChannel<StreamedEvent>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationAppearance = UINavigationBarAppearance(idiom: .phone)
        navigationAppearance.backgroundColor = .white
        navigationItem.standardAppearance = navigationAppearance
        view.backgroundColor = .white
        setupSubviews()
    }

    deinit {
        // This is required to avoid leaking EventHandling tasks
        // It would be preferred if AsyncChannels cleaned themselved up
        eventChannel.finish()
    }
}

// MARK: - EventStreaming

extension MainViewController: EventStreaming {
    enum StreamedEvent: SendableEvent {
        case didTapAuthenticate
        case didTapPresentAuthenticatedAlert
    }
}

// MARK: - Views

private extension UIAction.Identifier {
    // Used to identify the action associated tapping the authenticate button
    static var didTapAuthenticate: UIAction.Identifier { UIAction.Identifier(rawValue: "MainViewController.didTapLogin") }
}

extension MainViewController {
    func setupSubviews() {
        // -- Title --
        titleLabel.text = "Login Flows Sample"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // -- Description --
        descriptionLabel.text = """
        The purpose of this sample is to demonstrate stitching flows together, managing state, and keeping things DRY.
        Like most apps, there's a simple feature (showing an alert, lol) that requires authentication. Complete the authentication flow before presenting the alert.
        """
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        // -- Login Button --
        presentLoginButton.setTitle("Authenticate!", for: .normal)
        presentLoginButton.send(
            .didTapAuthenticate,
            to: eventChannel,
            for: .touchUpInside,
            identifier: .didTapAuthenticate
        )
        presentLoginButton.translatesAutoresizingMaskIntoConstraints = false
        // -- Feature Button --
        loginLockedFeatureButton.setTitle("Present Authenticated Alert", for: .normal)
        loginLockedFeatureButton.send(
            .didTapPresentAuthenticatedAlert,
            to: eventChannel,
            for: .touchUpInside
        )
        loginLockedFeatureButton.translatesAutoresizingMaskIntoConstraints = false

        // -- Constraints --
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(presentLoginButton)
        view.addSubview(loginLockedFeatureButton)

        // Present login prefers to be centered, but can be pushed by description to maintain margin
        let preferedPresentLoginYConstraint = presentLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        preferedPresentLoginYConstraint.priority = UILayoutPriority(750) // Wants to be centered but constraint can be broken

        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            // Present login
            presentLoginButton.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 36),
            preferedPresentLoginYConstraint,
            presentLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Present Login Locked alert
            loginLockedFeatureButton.topAnchor.constraint(equalTo: presentLoginButton.bottomAnchor, constant: 16),
            loginLockedFeatureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
