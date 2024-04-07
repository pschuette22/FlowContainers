//
//  Effects.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import Foundation

protocol Effect: Equatable, Sendable {}

/// Types which handle streamed events conform to ``EventHandling``
/// This acts as an interface to
protocol EffectHandling {
    associatedtype HandledEffect: Effect

    func handle(_ effect: HandledEffect) async
}

extension EffectHandling where Self: AnyObject {
    /// Converts a ``SendableEvent`` into a ``HandledEffect`` and dispatches to ``handle(_:)`` for handling
    /// - Parameters:
    ///   - channel: Channel events are streamed from
    ///   - mapping: Converts event to effect
    func handleEvents<SomeSendableEvent: SendableEvent>(
        from channel: AsyncChannel<SomeSendableEvent>,
        reducing: @escaping (SomeSendableEvent) async -> HandledEffect?
    ) {
        Task { [weak self, weak channel] in
            guard var iterator = channel?.makeAsyncIterator() else { return }
            while let event = await iterator.next() {
                guard let self else { throw CancellationError() }
                guard let effect = await reducing(event) else { continue }
                await handle(effect)
            }
        }
    }
}

extension EffectHandling where Self: Stateful {
    /// Converts a ``SendableEvent`` into a ``HandledEffect`` and dispatches to ``handle(_:)`` for handling
    /// - Parameters:
    ///   - channel: Channel events are streamed from
    ///   - mapping: Converts event to effect
    func handleEvents<SomeSendableEvent: SendableEvent>(
        from channel: AsyncChannel<SomeSendableEvent>,
        reducing: @escaping (SomeSendableEvent, State) async -> HandledEffect?
    ) {
        Task { [weak self, weak channel] in
            guard var iterator = channel?.makeAsyncIterator() else { return }
            while let event = await iterator.next() {
                guard let self else { throw CancellationError() }
                guard
                    let effect = await reducing(event, currentState)
                else { continue }
                await handle(effect)
            }
        }
    }
}
