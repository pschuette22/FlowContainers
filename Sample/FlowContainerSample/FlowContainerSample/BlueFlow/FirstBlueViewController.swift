//
//  FirstBlueViewController.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/3/24.
//

import Foundation
import UIKit

final class FirstBlueViewController: UIViewController {
    enum Action: Equatable {
        case didTapPushNextView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        navigationItem.title = "Blue View 1"
            
        setupSubviews()
    }
}

// MARK: - Subviews

extension FirstBlueViewController {
    private func setupSubviews() {
        let firstButton = UIButton(configuration: .bordered())
        firstButton.setTitle("First button", for: .normal)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        
        let secondButton = UIButton(configuration: .bordered())
        secondButton.setTitle("Second button", for: .normal)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(firstButton)
        view.addSubview(secondButton)
        
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
    }
}
