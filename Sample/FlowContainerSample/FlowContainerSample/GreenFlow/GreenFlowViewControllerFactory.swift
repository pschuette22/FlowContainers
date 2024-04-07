//
//  GreenFlowViewControllerFactory.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import Foundation
import UIKit

protocol GreenFlowViewControllerFactoryProtocol {
    func buildFirstViewController(_ actionChannel: AsyncChannel<GreenFlowContainer.GreenFlowAction>) -> UIViewController

    func buildSecondViewController(_ actionChannel: AsyncChannel<GreenFlowContainer.GreenFlowAction>) -> UIViewController
}

final class GreenFlowViewControllerFactory: GreenFlowViewControllerFactoryProtocol {
    func buildFirstViewController(_ actionChannel: AsyncChannel<GreenFlowContainer.GreenFlowAction>) -> UIViewController {
        let viewController = FirstGreenViewController()
        actionChannel.merge(viewController.actionChannel)
        return viewController
    }

    func buildSecondViewController(_ actionChannel: AsyncChannel<GreenFlowContainer.GreenFlowAction>) -> UIViewController {
        let viewController = SecondGreenViewController()
        actionChannel.merge(viewController.actionChannel)
        return viewController
    }
}
