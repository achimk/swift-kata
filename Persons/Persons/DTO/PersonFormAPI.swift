//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

public protocol PersonFormAPI {
    func createPersonForm() -> PersonForm
    func update(name: String?, for form: PersonForm) -> PersonForm
    func update(surname: String?, for form: PersonForm) -> PersonForm
    func update(age: UInt?, for form: PersonForm) -> PersonForm
}
