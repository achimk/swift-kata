//
//  Created by Joachim Kret on 15/03/2019.
//  Copyright © 2019 Enterpryze. All rights reserved.
//

import Foundation

public final class ListCancellable: Cancellable, CancellationToken {
    
    private let lock = NSLock()
    private var cancelled: Bool = false
    public private(set) var actions: [() -> ()] = []
    
    public var isCancelled: Bool {
        return cancelled
    }
    
    public init() { }
    
    public func register(_ action: @escaping () -> ()) {
        lock.lock(); defer { lock.unlock() }
        
        if cancelled {
            action()
        } else {
            actions.append(action)
        }
    }
    
    public func cancel() {
        
        lock.lock(); defer { lock.unlock() }
        
        if !cancelled {
            cancelled = true
            actions.forEach { $0() }
            actions = []
        }
    }
}
