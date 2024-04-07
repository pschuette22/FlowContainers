//
//  UIButton+Extensions.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import Foundation
import UIKit

extension UIButton {
    func send<Event: SendableEvent>(
        _ event: Event,
        to channel: AsyncChannel<Event>,
        for controlEvent: UIControl.Event,
        identifier: UIAction.Identifier? = nil
    ) {
        let action = UIAction(identifier: identifier) { [weak channel] _ in
            Task {
                await channel?.send(event)
            }
        }
        addAction(action, for: controlEvent)
    }
}
