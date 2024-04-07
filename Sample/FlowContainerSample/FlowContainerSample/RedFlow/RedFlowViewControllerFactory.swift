//
//  RedFlowViewControllerFactory.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//
import AsyncAlgorithms
import Foundation
import UIKit

protocol RedFlowViewControllerFactoryProtocol {
    func buildFirstViewController(_ actionChannel: AsyncChannel<RedFlowContainer.RedFlowAction>) -> UIViewController

    func buildSecondViewController(_ actionChannel: AsyncChannel<RedFlowContainer.RedFlowAction>) -> UIViewController
}

final class RedFlowViewControllerFactory: RedFlowViewControllerFactoryProtocol {
    func buildFirstViewController(_ actionChannel: AsyncChannel<RedFlowContainer.RedFlowAction>) -> UIViewController {
        let viewController = FirstRedViewController()
        actionChannel.merge(viewController.actionChannel)
        return viewController
    }

    func buildSecondViewController(_ actionChannel: AsyncChannel<RedFlowContainer.RedFlowAction>) -> UIViewController {
        let viewController = SecondRedViewController()
        actionChannel.merge(viewController.actionChannel)
        return viewController
    }
}
