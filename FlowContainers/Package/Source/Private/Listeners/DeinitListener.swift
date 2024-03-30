//
//  DeinitListener.swift
//  FlowContainers
//
//  Created by Peter Schuette on 3/30/24.
//

import Foundation

/// Listener that notifies interested consumers that its observed object has deinitialized
final class DeinitListener: NSObject {
    typealias DeinitCallback = () -> Void
    private final var associationKey: Void?
    private let onDeinit: DeinitCallback
    private weak var observed: AnyObject?
    
    /// Attach a callback to an object for when it is dealocated
    /// - Parameters:
    ///   - observed: Object to observe deallocation
    ///   - onDeinit: Callback when object is deallocated
    @discardableResult
    init(observe observed: some AnyObject, _ onDeinit: @escaping DeinitCallback) {
        self.observed = observed
        self.onDeinit = onDeinit
        
        super.init()
        
        objc_setAssociatedObject(observed, &associationKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    deinit {
        onDeinit()
    }
}
