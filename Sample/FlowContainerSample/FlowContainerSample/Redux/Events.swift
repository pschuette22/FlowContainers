//
//  Events.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/7/24.
//

import AsyncAlgorithms
import Foundation

/// Contained structure indicating a thing has happened
/// The streamer of the event is none the wiser of how this is handled, just that is was
/// ```Swift
/// enum ViewControllerEvents: SendableEvent {
///     // Tell subscribers a user tapped an info button
///     // This event is handled outside the current view
///     case .didTapInfoButton
/// }
/// ```
protocol SendableEvent: Equatable, Sendable {}

/// Types which broadcast events that occur within them may conform to ``EventStreaming``
/// This acts as a hook for interested parties to observe and react to events as they happen
/// Events should be streamed off of the main thread. Handlers will return to main for UX
protocol EventStreaming<StreamedEvent> {
    associatedtype StreamedEvent: SendableEvent

    var eventChannel: AsyncChannel<StreamedEvent> { get }
}
