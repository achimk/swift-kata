//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

public struct PersonErrors {
    public var errorByField: [PersonValidationKey: PersonValidationError] = [:]
    public var hasErrors: Bool { return !errorByField.isEmpty }
}
