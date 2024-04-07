//
//  State.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import Foundation

protocol ObjectState: Hashable, Sendable {}

extension ObjectState {
    func updating(_ updateHandler: (inout Self) -> Void) -> Self {
        var newState = self
        updateHandler(&newState)
        return newState
    }
}

protocol Stateful: AnyObject {
    associatedtype State: ObjectState
    var currentState: State { get }

    func transition(to state: State, from oldState: State)
}

// TODO: Macro for state management / reduction
