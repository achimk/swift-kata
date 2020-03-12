//
//  Created by Joachim Kret on 22.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public final class SingleCancellable: Cancellable {
    
    enum State {
        case initial
        case setCancel
        case cancelled
    }
    
    private var cancelable: Cancellable?
    private let lock = NSLock()
    private var state: State = .initial
    
    public var isCancelled: Bool {
        return state == .cancelled
    }
    
    public init() { }
    
    public func set(_ cancelable: Cancellable) {
        lock.lock(); defer { lock.unlock() }
        
        switch state {
        
        case .initial:
            state = .setCancel
            self.cancelable = cancelable
        
            
        case .cancelled:
            cancelable.cancel()
            self.cancelable = nil
        
        case .setCancel:
            fatalError("Cancel already set")
        }
    }
    
    public func cancel() {
        lock.lock(); defer { lock.unlock() }
        
        switch state {
        
        case .initial:
            fatalError("Cancel not set")
        
        case .cancelled:
            return
            
        case .setCancel:
            state = .cancelled
            cancelable?.cancel()
            cancelable = nil
        }
    }
}
