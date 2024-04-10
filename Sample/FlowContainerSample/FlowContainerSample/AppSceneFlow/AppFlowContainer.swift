//
//  AppFlowContainer.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import FlowContainers
import Foundation
import UIKit

final class AppFlowContainer: FlowContainer {
    private(set) var currentState = State()

    override func initialViewController() -> UIViewController {
        let viewController = buildMainViewController()
        viewController.edgesForExtendedLayout = []
        return viewController
    }
}

extension AppFlowContainer {
    private func buildMainViewController() -> UIViewController {
        let viewController = MainViewController()
        handleEvents(from: viewController.eventChannel) { event, state in
            switch event {
            case .didTapAuthenticate:
                if state.isAuthenticated {
                    // Shouldn't get here, maybe a toast?
                    nil
                } else {
                    .presentAuthentication
                }
            case .didTapPresentAuthenticatedAlert:
                if state.isAuthenticated {
                    .presentAlert
                } else {
                    .presentNeedsAuthentication
                }
            }
        }

        return viewController
    }
}

extension AppFlowContainer: Stateful {
    struct State: ObjectState {
        var isAuthenticated: Bool = false
    }

    @MainActor
    func transition(to state: State, from _: State) {
        print("TODO: transition")
        currentState = state
        // Handle authentication state transition
    }
}

extension AppFlowContainer: EffectHandling {
    enum HandledEffect: Effect {
        case authenticated
        case presentAuthentication
        case presentNeedsAuthentication
        case presentAlert
    }

    @MainActor
    func handle(_ effect: HandledEffect) async {
        switch effect {
        case .authenticated:
            let newState = currentState.updating {
                $0.isAuthenticated = true
            }
            transition(to: newState, from: currentState)
        case .presentAuthentication:
            // TODO: present authentication flow
            present(AuthenticationFlowContainer())
        case .presentNeedsAuthentication:
            // TODO: present alert indicating authentication is needed
            break
        case .presentAlert:
            // TODO: show the auth locked alert
            break
        }
    }
}
