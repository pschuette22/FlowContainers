//
//  FirstRedViewController.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import Foundation
import UIKit

final class FirstRedViewController: UIViewController {
    enum Action: Equatable, Sendable {
        case didTapPushNextView
        case didTapPushFlow
    }

    let actionChannel = AsyncChannel<Action>()

    let firstButton = UIButton(configuration: .bordered())
    let secondButton = UIButton(configuration: .bordered())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationItem.title = "Red View 1"

        setupSubviews()
    }

    deinit {
        actionChannel.finish()
    }
}

// MARK: - Subviews

extension FirstRedViewController {
    private func setupSubviews() {
        // Style the buttons
        firstButton.setTitle("First button", for: .normal)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.setTitle("Second button", for: .normal)
        secondButton.translatesAutoresizingMaskIntoConstraints = false

        // Add to page
        view.addSubview(firstButton)
        view.addSubview(secondButton)

        // Constrain
        NSLayoutConstraint.activate([
            // First button
            firstButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            firstButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            firstButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            // Second button
            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 16),
            secondButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            secondButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
        ])

        // Actions
        let firstButtonAction = UIAction { [weak actionChannel] _ in
            Task {
                await actionChannel?.send(.didTapPushNextView)
            }
        }
        firstButton.addAction(firstButtonAction, for: .touchUpInside)

        let secondButtonAction = UIAction { [weak actionChannel] _ in
            Task {
                await actionChannel?.send(.didTapPushFlow)
            }
        }
        secondButton.addAction(secondButtonAction, for: .touchUpInside)
    }
}
