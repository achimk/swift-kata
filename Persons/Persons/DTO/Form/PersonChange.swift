//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation
import CoreKit

public struct PersonChange {

    public let name: Change<String?>
    public let surname: Change<String?>
    public let age: Change<UInt?>
    public let isModified: Bool
    
    private init(name: Change<String?>,
                 surname: Change<String?>,
                 age: Change<UInt?>) {
        
        self.name = name
        self.surname = surname
        self.age = age
        self.isModified = name.isModified || surname.isModified || age.isModified
    }
    
    internal init(name: String?, surname: String?, age: UInt?) {
        self.name = .init(name)
        self.surname = .init(surname)
        self.age = .init(age)
        self.isModified = false
    }
    
    internal func updated(name value: String?) -> PersonChange {
        return PersonChange(name: name.updated(value), surname: surname, age: age)
    }
    
    internal func updated(surname value: String?) -> PersonChange {
        return PersonChange(name: name, surname: surname.updated(value), age: age)
    }
    
    internal func updated(age value: UInt?) -> PersonChange {
        return PersonChange(name: name, surname: surname, age: age.updated(value))
    }
}
