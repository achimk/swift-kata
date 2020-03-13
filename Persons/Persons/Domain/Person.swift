//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

public struct Person {
    public let id: PersonId
    public let name: String
    public let surname: String
    public let age: UInt
}

extension Person {
    static let minimalAge: UInt = 18
}
