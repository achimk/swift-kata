//
//  Created by Joachim Kret on 15/03/2019.
//  Copyright © 2019 Enterpryze. All rights reserved.
//

import Foundation

public protocol CancellationToken {
    
    var isCancelled: Bool { get }
    
    func register(_ action: @escaping () -> ())
}
