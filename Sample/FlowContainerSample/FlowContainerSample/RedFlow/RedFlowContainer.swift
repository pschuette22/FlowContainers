//
//  RedFlowContainer.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import FlowContainers
import Foundation
import UIKit

final class RedFlowContainer: FlowContainer {
    enum RedFlowAction: Equatable, Sendable {
        case pushNextRedScreen
        case pushNextFlow
        case presentNextFlow
    }

    private let controllerFactory: RedFlowViewControllerFactoryProtocol
    private let actionChannel = AsyncChannel<RedFlowAction>()

    init(
        controllerFactory: RedFlowViewControllerFactoryProtocol = RedFlowViewControllerFactory()
    ) {
        self.controllerFactory = controllerFactory
        super.init()

        setupActionHandling()
    }

    override func initialViewController() -> UIViewController {
        controllerFactory.buildFirstViewController(actionChannel)
    }

    deinit {
        actionChannel.finish()
    }
}

// MARK: - Action Handler

extension RedFlowContainer {
    func setupActionHandling() {
        Task { [weak self] in
            guard var iterator = self?.actionChannel.makeAsyncIterator() else { return }

            while let action = await iterator.next() {
                await self?.handle(action)
            }
        }
    }

    @MainActor
    func handle(_ action: RedFlowAction) {
        switch action {
        case .pushNextRedScreen:
            let viewController = controllerFactory.buildSecondViewController(actionChannel)
            push(viewController)
        case .pushNextFlow:
            // Push another Red flow for now
            push(RedFlowContainer())
        case .presentNextFlow:
            present(RedFlowContainer())
        }
    }
}

extension AsyncChannel where Element == RedFlowContainer.RedFlowAction {
    func merge(_ channel: AsyncChannel<FirstRedViewController.Action>) {
        Task { [weak self, weak channel] in
            guard var iterator = channel?.makeAsyncIterator() else { return }
            while let action = await iterator.next() {
                switch action {
                case .didTapPushNextView:
                    await self?.send(.pushNextRedScreen)
                case .didTapPushFlow:
                    await self?.send(.pushNextFlow)
                }
            }
        }
    }

    func merge(_ channel: AsyncChannel<SecondRedViewController.Action>) {
        Task { [weak self, weak channel] in
            guard var iterator = channel?.makeAsyncIterator() else { return }
            while let action = await iterator.next() {
                switch action {
                case .didTapPresentFlow:
                    await self?.send(.presentNextFlow)
                case .didTapPushFlow:
                    await self?.send(.pushNextFlow)
                }
            }
        }
    }
}
