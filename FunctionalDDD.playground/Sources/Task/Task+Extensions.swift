//
//  Created by Joachim Kret on 17.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public typealias SimpleTask = InputTask<Void>

public typealias PipeTask<T> = InputTask<T>

extension Task {
    
    public static func never() -> Task<Input, Output> {
        return AnyTask<Input, Output> { (_, _) in Cancellables.noop() }
    }
    
    public static func create(_ transform: @escaping (Input, @escaping (Output) -> ()) -> Cancellable) -> Task<Input, Output> {
        return AnyTask<Input, Output>(transform)
    }
    
    public static func create(_ transform: @escaping (Input) -> Output) -> Task<Input, Output> {
        return AnyTask<Input, Output>.init { (input, completion) -> Cancellable in
            completion(transform(input))
            return Cancellables.noop()
        }
    }
    
    public func then<T>(_ transform: @escaping (Output, @escaping (T) -> ()) -> Cancellable) -> Task<Input, T> {
        return self.then(.create(transform))
    }
    
    public func then<T>(_ transform: @escaping (Output) -> T) -> Task<Input, T> {
        return self.then(.create(transform))
    }
    
    public func then<T>(_ other: Task<Output, T>) -> Task<Input, T> {
        
        return AnyTask { (input, completion) in
            
            let dispose = Cancellables.serial()
            
            dispose.cancelable = self.run(input, { (output) in
                
                if dispose.isCancelled { return }
                
                dispose.cancelable = other.run(output, completion)
            })
            
            return dispose
        }
    }
    
    public func async(_ queue: DispatchQueue, after deadline: TimeInterval? = nil) -> Task<Input, Output> {
        
        return AnyTask { (input, completion) in
            
            let dispose = Cancellables.single()
            
            let cancelable = self.run(input, { (output) in
                
                if dispose.isCancelled { return }
                
                if let deadline = deadline {
                    
                    queue.asyncAfter(deadline: .now() + deadline) {
                        
                        if !dispose.isCancelled {
                            
                            completion(output)
                        }
                    }
                    
                } else {
                    
                    queue.async {
                        completion(output)
                    }
                }
            })
            
            dispose.set(cancelable)
            
            return dispose
        }
    }
}

extension Task where Output == Void {
    
    public static func create(_ transform: @escaping (Input) -> ()) -> Task<Input, Output> {
        return AnyTask<Input, Output> { (input, completion) in
            transform(input)
            completion(())
            return Cancellables.noop()
        }
    }
}

extension Task where Input == Void {
    
    @discardableResult
    public func run() -> Cancellable {
        return run((), { _ in })
    }
    
    @discardableResult
    public func run(_ completion: @escaping (Output) -> ()) -> Cancellable {
        return run((), completion)
    }
}

extension Task {
    
    @discardableResult
    public func run(_ input: Input) -> Cancellable {
        return run(input, { _ in })
    }
}
