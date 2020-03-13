//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import Foundation

extension PersonId {
    
    public static func stubbed(_ id: String = "test") -> PersonId {
        return PersonId(id).or(else: { fatalError("Unable to create PersonId with: \(id)") })
    }
}
