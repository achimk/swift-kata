//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

public struct PersonId {
    public let value: String
    
    internal init?(_ value: String) {
        guard value.count > 0 else { return nil }
        self.value = value
    }
}
