//
//  Created by Joachim Kret on 22.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public final class AnyCancellable: Cancellable {
    
    private let onCancel: () -> ()
    private let lock = NSLock()
    private var cancelled: Bool = false
    
    public var isCancelled: Bool {
        return cancelled
    }
    
    public init(_ onCancel: @escaping () -> ()) {
        self.onCancel = onCancel
    }
    
    public func cancel() {
        lock.lock(); defer { lock.unlock() }
        
        if !cancelled {
            cancelled = true
            onCancel()
        }
    }
}
