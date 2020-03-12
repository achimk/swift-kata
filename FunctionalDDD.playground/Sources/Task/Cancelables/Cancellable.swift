//
//  Created by Joachim Kret on 22.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public protocol Cancellable {
    
    var isCancelled: Bool { get }
    
    func cancel()
}
