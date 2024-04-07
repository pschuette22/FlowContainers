//
//  GreenFlowContainer.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//
import AsyncAlgorithms
import FlowContainers
import Foundation
import UIKit

final class GreenFlowContainer: FlowContainer {
    enum GreenFlowAction: Equatable, Sendable {
        case pushNextGreenScreen
        case pushNextFlow // Green?
        case presentNextFlow
    }

    private let controllerFactory: GreenFlowViewControllerFactoryProtocol
    private let actionChannel = AsyncChannel<GreenFlowAction>()

    init(
        controllerFactory: GreenFlowViewControllerFactoryProtocol = GreenFlowViewControllerFactory()
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

extension GreenFlowContainer {
    func setupActionHandling() {
        Task { [weak self] in
            guard var iterator = self?.actionChannel.makeAsyncIterator() else { return }

            while let action = await iterator.next() {
                await self?.handle(action)
            }
        }
    }

    @MainActor
    func handle(_ action: GreenFlowAction) {
        switch action {
        case .pushNextGreenScreen:
            let viewController = controllerFactory.buildSecondViewController(actionChannel)
            push(viewController)
        case .pushNextFlow:
            // Push another Green flow for now
            push(GreenFlowContainer())
        case .presentNextFlow:
            present(GreenFlowContainer())
        }
    }
}

extension AsyncChannel where Element == GreenFlowContainer.GreenFlowAction {
    func merge(_ channel: AsyncChannel<FirstGreenViewController.Action>) {
        Task { [weak self, weak channel] in
            guard var iterator = channel?.makeAsyncIterator() else { return }
            while let action = await iterator.next() {
                switch action {
                case .didTapPushNextView:
                    await self?.send(.pushNextGreenScreen)
                case .didTapPushFlow:
                    await self?.send(.pushNextFlow)
                }
            }
        }
    }

    func merge(_ channel: AsyncChannel<SecondGreenViewController.Action>) {
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
