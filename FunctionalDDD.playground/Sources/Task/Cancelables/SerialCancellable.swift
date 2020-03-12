//
//  Created by Joachim Kret on 22.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public final class SerialCancellable: Cancellable {
    
    private let lock = NSLock()
    private var cancelled = false
    private var current: Cancellable?
    
    public var isCancelled: Bool {
        return cancelled
    }
    
    public var cancelable: Cancellable {
        
        get {
            return current ?? AnyCancellable { }
        }
        
        set (newCancellable) {
            
            lock.lock(); defer { lock.unlock() }
            
            let cancelable: Cancellable? = {
                
                if cancelled {
                    
                    return newCancellable
                    
                } else {
                    
                    let toCancel = current
                    current = newCancellable
                    return toCancel
                    
                }
                
            }()
            
            cancelable?.cancel()
        }
    }
    
    public init() { }
    
    public func cancel() {
        
        lock.lock(); defer { lock.unlock() }
        
        if !cancelled {
            cancelled = true
            current?.cancel()
            current = nil
        }
    }
}
