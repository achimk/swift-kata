//
//  Created by Joachim Kret on 17.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

open class Task<Input, Output> {
    
    public init() { }
    
    @discardableResult
    open func run(_ input: Input, _ completion: @escaping (Output) -> ()) -> Cancellable {
        
        fatalError("Task can't be used directly, please provide subclass of Task and override perform method!")
    }
}
