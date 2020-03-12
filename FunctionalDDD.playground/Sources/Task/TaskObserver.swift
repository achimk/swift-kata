//
//  Created by Joachim Kret on 15/03/2019.
//  Copyright © 2019 Enterpryze. All rights reserved.
//

import Foundation

public protocol TaskStatus: Cancellable {
    var isInitial: Bool { get }
    var isPending: Bool { get }
    var isResolved: Bool { get }
    var isRejected: Bool { get }
}

extension TaskStatus {
    
    public func onInitial(_ action: () -> ()) {
        if isInitial { action() }
    }
    
    public func onPending(_ action: () -> ()) {
        if isPending { action() }
    }
    
    public func onResolved(_ action: () -> ()) {
        if isResolved { action() }
    }
    
    public func onRejected(_ action: () -> ()) {
        if isRejected { action() }
    }
    
    public func onCancelled(_ action: () -> ()) {
        if isCancelled { action() }
    }
}

public protocol TaskObservable {
    
    associatedtype Value
    
    @discardableResult
    func then(_ action: @escaping (Value) -> ()) -> Self
    
    @discardableResult
    func `catch`(_ action: @escaping (Swift.Error) -> ()) -> Self
    
    @discardableResult
    func cancelled(_ action: @escaping () -> ()) -> Self
}



public final class TaskObserver<Input, Output>: Task<Input, Result<Output, Swift.Error>>, TaskStatus, TaskObservable {
    public typealias Value = Output
    public typealias TaskResult = Result<Output, Swift.Error>
    
    enum State {
        case initial
        case pending
        case resolved(Output)
        case rejected(Swift.Error)
        case cancelled
        
    }
    
    private let task: Task<Input, TaskResult>
    private var dispose: Cancellable = Cancellables.noop()
    private var thenActions: [(Output) -> ()] = []
    private var catchActions: [(Swift.Error) -> ()] = []
    private var cancelActions: [() -> ()] = []
    
    private var state: State = .initial {
        didSet {
            
            onValue { value in thenActions.forEach { $0(value) } }
            onError { error in catchActions.forEach { $0(error) } }
            onCancelled { cancelActions.forEach { $0() } }
            
            thenActions = []
            catchActions = []
            cancelActions = []
        }
    }
    
    public init(_ task: Task<Input, TaskResult>) {
        self.task = task
        super.init()
        finishInitialize()
    }
    
    private func finishInitialize() {
        dispose = AnyCancellable {
            if self.isInitial {
                self.state = .cancelled
            }
        }
    }
    
    public var value: Output? {
        guard case .resolved(let value) = state else { return nil }
        return value
    }
    
    public var error: Swift.Error? {
        guard case .rejected(let error) = state else { return nil }
        return error
    }
    
    public var isInitial: Bool {
        guard case .initial = state else { return false }
        return true
    }
    
    public var isPending: Bool {
        guard case .pending = state else { return false }
        return true
    }
    
    public var isResolved: Bool {
        guard case .resolved = state else { return false }
        return true
    }
    
    public var isRejected: Bool {
        guard case .rejected = state else { return false }
        return true
    }
    
    public var isCancelled: Bool {
        guard case .cancelled = state else { return false }
        return true
    }
    
    public func onValue(_ action: (Output) -> ()) {
        if let value = value { action(value) }
    }
    
    public func onError(_ action: (Swift.Error) -> ()) {
        if let error = error { action(error) }
    }
    
    @discardableResult
    public func then(_ action: @escaping (Output) -> ()) -> Self {
        
        onPending {
            thenActions.append(action)
        }
        
        onValue { (value) in
            action(value)
        }
        
        return self
    }
    
    @discardableResult
    public func `catch`(_ action: @escaping (Swift.Error) -> ()) -> Self {
        
        onPending {
            catchActions.append(action)
        }
        
        onError { (error) in
            action(error)
        }
        
        return self
    }
    
    @discardableResult
    public func cancelled(_ action: @escaping () -> ()) -> Self {
        
        onPending {
            cancelActions.append(action)
        }
        
        onCancelled {
            action()
        }
        
        return self
    }
    
    public override func run(_ input: Input, _ completion: @escaping (Result<Output, Error>) -> ()) -> Cancellable {
        
        guard isInitial else { return Cancellables.noop() }
        
        state = .pending
        
        let taskDispose = task.run(input) { (result) in
            
            guard self.isPending else { return }
            
            result.onSuccess { self.state = .resolved($0) }
            result.onFailure { self.state = .rejected($0) }
            
            completion(result)
        }
        
        let dispose = AnyCancellable {
            if self.isInitial || self.isPending {
                self.state = .cancelled
                taskDispose.cancel()
            }
        }
        
        self.dispose = dispose
        
        return dispose
    }
    
    public func cancel() {
        dispose.cancel()
    }
}
