//
//  Created by Joachim Kret on 17.07.2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

public final class AnyTask<Input, Output>: Task<Input, Output> {
    
    let transform: (Input, @escaping (Output) -> ()) -> Cancellable
    let dispose: () -> ()
    
    public static func onDispose<T>(_ dispose: @escaping () -> ()) -> Task<T, T> {
        return AnyTask<T, T>(transform: { (input, completion) in
            completion(input)
            return Cancellables.noop()
        }, dispose: dispose)
    }
    
    public convenience init(_ f: @escaping (Input) -> Output) {
        self.init(transform: { (input, completion) in
            completion(f(input))
            return Cancellables.noop()
        }, dispose: { })
    }
    
    public convenience init(_ f: @escaping (Input, @escaping (Output) -> ()) -> Cancellable) {
        self.init(transform: f, dispose: { })
    }
    
    public init(transform: @escaping (Input, @escaping (Output) -> ()) -> Cancellable, dispose: @escaping () -> ()) {
        self.transform = transform
        self.dispose = dispose
    }

    deinit {
        dispose()
    }
    
    @discardableResult
    public override func run(_ input: Input, _ completion: @escaping (Output) -> ()) -> Cancellable {
        return transform(input, completion)
    }
    
}
