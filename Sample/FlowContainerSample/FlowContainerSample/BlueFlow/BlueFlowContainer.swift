//
//  BlueFlowContainer.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/5/24.
//

import AsyncAlgorithms
import FlowContainers
import Foundation
import UIKit

final class BlueFlowContainer: FlowContainer, NavigationBindingDelegate {
    enum BlueFlowAction: Equatable, Sendable {
        case pushNextBlueScreen
        case pushNextFlow // Green?
    }

    private let controllerFactory: BlueFlowViewControllerFactoryProtocol
    private let actionChannel = AsyncChannel<BlueFlowAction>()

    init(
        controllerFactory: BlueFlowViewControllerFactoryProtocol = BlueFlowViewControllerFactory()
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

extension BlueFlowContainer {
    func setupActionHandling() {
        Task { [weak self] in
            guard var iterator = self?.actionChannel.makeAsyncIterator() else { return }

            while let action = await iterator.next() {
                await self?.handle(action)
            }
        }
    }

    @MainActor
    func handle(_ action: BlueFlowAction) {
        switch action {
        case .pushNextBlueScreen:
            print("push next blue screen")
        case .pushNextFlow:
            // Push another blue flow for now
            push(BlueFlowContainer())
        }
    }
}

extension AsyncChannel where Element == BlueFlowContainer.BlueFlowAction {
    func merge(_ channel: AsyncChannel<FirstBlueViewController.Action>) {
        Task { [weak self, weak channel] in
            guard var iterator = channel?.makeAsyncIterator() else { return }
            while let action = await iterator.next() {
                switch action {
                case .didTapPushNextView:
                    await self?.send(.pushNextBlueScreen)
                case .didTapPushFlow:
                    await self?.send(.pushNextFlow)
                }
            }
        }
    }
}
