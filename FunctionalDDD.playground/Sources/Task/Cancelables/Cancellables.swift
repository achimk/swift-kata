//
//  Created by Joachim Kret on 25.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public struct Cancellables {
    
    // No Operation
    public static func noop() -> Cancellable {
        
        return AnyCancellable { }
    }
    
    public static func any(_ onCancel: @escaping () -> ()) -> Cancellable {
        
        return AnyCancellable(onCancel)
    }
    
    public static func list() -> ListCancellable {
        
        return ListCancellable()
    }
    
    public static func single() -> SingleCancellable {
        
        return SingleCancellable()
    }
    
    public static func serial() -> SerialCancellable {
        
        return SerialCancellable()
    }
}
