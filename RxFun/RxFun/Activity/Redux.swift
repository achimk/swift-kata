//
//  Created by Joachim Kret on 20/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import RxCocoa

typealias Reducer<Action, State> = (_ action: Action, _ currentState: State) -> State

typealias Middleware<Action, State> = (@escaping (Action) -> (), @escaping () -> State?) -> (@escaping (Action) -> ()) -> (Action) -> ()

typealias SideEffect<Action, State> = (@escaping (Action) -> (), @escaping () -> State?) -> (Action) -> ()
