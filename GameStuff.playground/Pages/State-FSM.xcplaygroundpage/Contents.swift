//: [Previous](@previous)

import Foundation

enum Input {
    
    // A B
    case pressA
    case pressB
    case releaseA
    case releaseB
    
    // Up, Down, Left, Right
    case pressUp
    case pressDown
    case pressLeft
    case pressRight
    case releaseUp
    case releaseDown
    case releaseLeft
    case releaseRight
}

class Heroine {
    func setGraphics(_ name: String) { }
    func superBomb() { }
}

protocol HeroineState {
    func handle(_ heroine: Heroine, input: Input)
    func update(_ heroine: Heroine)
}

/**
 Basic States - classes for each state
 */

class BaseHeroineState: HeroineState {
    func handle(_ heroine: Heroine, input: Input) {
        //noop
    }
    func update(_ heroine: Heroine) {
        //noop
    }
}

class StandingState: BaseHeroineState { }
class DuckingState: BaseHeroineState { }
class JumpingState: BaseHeroineState { }
class DivingState: BaseHeroineState { }

/**
 Delegating Heroine example
 */

class AnotherDuckingState: HeroineState {
    
    struct Const {
        static let maxCharge: Int = 100
    }
    
    var chargeTime: Int = 0
    
    func handle(_ heroine: Heroine, input: Input) {
        if input == .releaseDown {
            heroine.setGraphics("ImageStand")
        }
    }
    
    func update(_ heroine: Heroine) {
        chargeTime += 1
        if chargeTime > Const.maxCharge {
            heroine.superBomb()
        }
    }
}

class DelegatingHeroine: Heroine {
    
    var state: HeroineState = StandingState()
    
    func handle(_ input: Input) {
        state.handle(self, input: input)
    }
    
    func update() {
        state.update(self)
    }
}

/**
 Static states example
 */

class StaticHeroineState: HeroineState {
    
    static let standing = StandingState()
    static let ducking = DuckingState()
    static let jumping = JumpingState()
    static let diving = DivingState()
    
    func handle(_ heroine: Heroine, input: Input) {
        
        if input == .pressB {
            let h = heroine as! DelegatingHeroine
            h.state = StaticHeroineState.jumping
            h.setGraphics("ImageJump")
        }
    }
    
    func update(_ heroine: Heroine) {
        
    }
}

/**
 Transition of states, when one state cause create another state
 for example: StandingState to DuckingState
 */

protocol TransitionHeroineState {
    func handle(_ heroine: Heroine, input: Input) -> TransitionHeroineState?
    func update(_ heroine: Heroine)
}

class StandingTransitionState: TransitionHeroineState {
    
    func handle(_ heroine: Heroine, input: Input) -> TransitionHeroineState? {
        
        if input == .pressDown {
            // ...
            return DuckingTransitionState()
        }
        
        // stay in this state
        return nil
    }
    
    func update(_ heroine: Heroine) {
        //...
    }
}

class DuckingTransitionState: TransitionHeroineState {
    
    func handle(_ heroine: Heroine, input: Input) -> TransitionHeroineState? {
        //...
        return nil
    }
    
    func update(_ heroine: Heroine) {
        //...
    }
}

class TransitionHeroine: Heroine {
    
    var state: TransitionHeroineState = StandingTransitionState()
    
    func handle(_ input: Input) {
        let newState = state.handle(self, input: input)
        
        if let newState = newState {
            state = newState
        }
    }
    
    func update() {
        state.update(self)
    }
}


/**
 Add Enter and Exit actions for preparing states transition
 for example we don't want to set properties for new state in current state
 in this case we delegating it to enter fuctionality of new state
 */

protocol EnterHeroineState {
    func enter(_ heroine: Heroine)
    func handle(_ heroine: Heroine, input: Input) -> EnterHeroineState?
    func update(_ heroine: Heroine)
}

class StandingActionState: EnterHeroineState {
    
    func enter(_ heroine: Heroine) {
        heroine.setGraphics("ImageStand")
    }
    
    func handle(_ heroine: Heroine, input: Input) -> EnterHeroineState? {
        //...
        return nil
    }
    
    func update(_ heroine: Heroine) {
        //...
    }
}

class ActionHeroine: Heroine {
    
    var state: EnterHeroineState = StandingActionState()
    
    func handle(_ input: Input) {
        let newState = state.handle(self, input: input)
        
        if let newState = newState {
            state = newState
            
            // Call enter to new state
            newState.enter(self)
        }
    }
    
    func update() {
        state.update(self)
    }
}

/**
 Concurrent state machines
 */

class ConcurrentHeroine: Heroine {
    
    var state: HeroineState?
    var equipment: HeroineState?
    
    func handle(_ input: Input) {
        state?.handle(self, input: input)
        equipment?.handle(self, input: input)
    }
}

/**
 Hierarchical state machines
 */

class OnGroundState: HeroineState {
    
    func handle(_ heroine: Heroine, input: Input) {
        if input == .pressB {
            // jump
        } else if input == .pressDown {
            // duck
        }
    }
    
    func update(_ heroine: Heroine) {
        //...
    }
}

class DuckState: OnGroundState {
    
    override func handle(_ heroine: Heroine, input: Input) {
        if input == .releaseDown {
            // stand up
        } else {
            // go up hierarchy
            handle(heroine, input: input)
        }
    }
}

/**
 Pushdown Automata
 */

struct Stack<T> {
    
    private var content: [T] = []
    
    mutating func push(_ element: T) {
        content.append(element)
    }
    
    mutating func pop() -> T? {
        return content.popLast()
    }
}

class HeroineAutomata: Heroine {
    
    var state = Stack<TransitionHeroineState>()
    
    func handle(_ input: Input) {
        let newState = state.pop()?.handle(self, input: input)
        
        if let newState = newState {
            state.push(newState)
        }
    }
}

//: [Next](@next)
