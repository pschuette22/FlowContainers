//
//  BlueFlowViewControllerFactory.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/5/24.
//

import AsyncAlgorithms
import Foundation
import UIKit

protocol BlueFlowViewControllerFactoryProtocol {
    func buildFirstViewController(_ actionChannel: AsyncChannel<BlueFlowContainer.BlueFlowAction>) -> UIViewController

    func buildSecondViewController(_ actionChannel: AsyncChannel<BlueFlowContainer.BlueFlowAction>) -> UIViewController
}

final class BlueFlowViewControllerFactory: BlueFlowViewControllerFactoryProtocol {
    func buildFirstViewController(_ actionChannel: AsyncChannel<BlueFlowContainer.BlueFlowAction>) -> UIViewController {
        let viewController = FirstBlueViewController()
        actionChannel.merge(viewController.actionChannel)
        return viewController
    }

    func buildSecondViewController(_ actionChannel: AsyncChannel<BlueFlowContainer.BlueFlowAction>) -> UIViewController {
        let viewController = SecondBlueViewController()
        actionChannel.merge(viewController.actionChannel)
        return viewController
    }
}
