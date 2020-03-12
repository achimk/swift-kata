//
//  Created by Joachim Kret on 25.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public final class InputTask<T>: Task<T, T> {
    
    public override func run(_ input: T, _ completion: @escaping (T) -> ()) -> Cancellable {
        completion(input)
        return Cancellables.noop()
    }
}
