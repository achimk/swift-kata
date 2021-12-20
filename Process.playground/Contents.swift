import Foundation

// MARK: Types

typealias Completion<Value> = (Result<Value, Error>) -> ()

// MARK: Utils

func typeIdentifier<T>(from type: T.Type) -> String {
    return String(describing: type.self)
}

// MARK: Cancelable

protocol Cancelable {
    func cancel()
}

struct NopCancelable: Cancelable {
    func cancel() { }
}

class AnyCancelable: Cancelable {
    private var onCancel: (() -> ())?

    init(onCancel: @escaping () -> ()) {
        self.onCancel = onCancel
    }

    func cancel() {
        onCancel?()
        onCancel = nil
    }
}

// MARK: UseCase

protocol Command {
    associatedtype ReturnType
}

class UseCase<CommandType: Command> {

    func execute(_ command: CommandType, completion: @escaping Completion<CommandType.ReturnType>) -> Cancelable {
        fatalError()
    }
}

// MARK: Process

class Process<ObserverType> {

    func observe(with observer: ObserverType) -> Cancelable {
        fatalError()
    }

    func execute<CommandType: Command>(_ command: CommandType) where CommandType.ReturnType == Never {
        fatalError()
    }
}

// Counter

struct IncrementCommand: Command {
    typealias ReturnType = Never
}

struct DecrementCommand: Command {
    typealias ReturnType = Never
}

protocol CounterProcessObserving: class {
    func counterProccess(_ process: CounterProcess, didChangeState state: Int)
}

class CounterProcess: Process<CounterProcessObserving> {

    private var state: Int = 0 {
        didSet {
            observer?.counterProccess(self, didChangeState: state)
        }
    }
    private weak var observer: CounterProcessObserving?

    override func observe(with observer: CounterProcessObserving) -> Cancelable {
        self.observer = observer
        return AnyCancelable { [weak self] in
            self?.observer = nil
        }
    }

    override func execute<CommandType>(_ command: CommandType) where CommandType : Command, CommandType.ReturnType == Never {

        switch command {
        case _ as IncrementCommand: increment()
        case _ as DecrementCommand: decrement()
        default: break
        }
    }

    private func increment() {
        state = state + 1
    }

    private func decrement() {
        state = state - 1
    }
}

// MARK: Mocking

class MockProcess<ObserverType>: Process<ObserverType> {

    struct Arguments<CommandType: Command> {
//        let observer: ObserverType
        let command: CommandType
        let callsCount: Int
    }

    private let registry = EntityRegistry()
    private let invokeCounter = EntityInvokeCounter()
    private let invokeHistory = EntityInvokeHistory()

    private var observer: ObserverType?

    override func observe(with observer: ObserverType) -> Cancelable {
        self.observer = observer
        return NopCancelable()
    }

    override func execute<CommandType: Command>(_ command: CommandType) where CommandType.ReturnType == Never {
        let count = invokeCounter.increment(for: CommandType.self)
        let args = Arguments(command: command, callsCount: count)
        invokeHistory.push(CommandType.self)
        registry.handle(args)
    }
}

extension MockProcess {

    func `for`<CommandType: Command>(
        _ command: CommandType.Type) -> EntityInvocation<Arguments<CommandType>> where CommandType.ReturnType == Never {
        return registry.for(Arguments<CommandType>.self)
    }
}

extension MockProcess {

    func verify<CommandType: Command>(_ command: CommandType.Type, count: Int) -> Bool {
        invokeCounter.count(for: command) == count
    }

    func verifyNever<CommandType: Command>(_ command: CommandType.Type) -> Bool {
        !invokeHistory.contains(command)
    }

    func verifyContain<CommandType: Command>(_ command: CommandType.Type) -> Bool {
        invokeHistory.contains(command)
    }

    func verifyInOrder<T>(_ list: [T]) -> Bool {
        invokeHistory.inOrder(list)
    }
}

class EntityRegistry {
    private var invocationsByIdentifier: [String: [AnyObject]] = [:]

    func `for`<T>(_ entity: T.Type) -> EntityInvocation<T> {
        let invocation = EntityInvocation<T>()
        let identifier = String(describing: T.self)
        var invocations = invocationsByIdentifier[identifier] ?? []
        invocations.append(invocation)
        invocationsByIdentifier[identifier] = invocations
        return invocation
    }

    func handle<T>(_ entity: T) {
        let identifier = String(describing: T.self)
        let invocations = invocationsByIdentifier[identifier] ?? []
        invocations.forEach { (invocation) in
            if let invocation = invocation as? EntityInvocation<T>, invocation.condition(entity) {
                invocation.completion(entity)
            }
        }
    }
}

class EntityInvocation<T> {
    private(set) var condition: (T) -> Bool = { _ in true }
    private(set) var completion: (T) -> Void = { _ in }

    func when(_ condition: @escaping (T) -> Bool) -> Self {
        self.condition = condition
        return self
    }

    func then(_ completion: @escaping (T) -> Void) {
        self.completion = completion
    }
}

class EntityInvokeCounter {
    private var callsByIdentifier: [String: Int] = [:]

    func count<T>(for entity: T.Type) -> Int {
        let identifier = typeIdentifier(from: T.self)
        return callsByIdentifier[identifier] ?? 0
    }

    func increment<T>(for entity: T.Type) -> Int {
        let identifier = typeIdentifier(from: T.self)
        let count = (callsByIdentifier[identifier] ?? 0) + 1
        callsByIdentifier[identifier] = count
        return count
    }
}

class EntityInvokeHistory {
    private(set) var identifiers: [String] = []

    func push<T>(_ entity: T.Type) {
        identifiers.append(String(describing: T.self))
    }

    func contains<T>(_ entity: T.Type) -> Bool {
        identifiers.contains(String(describing: T.self))
    }

    func inOrder<T>(_ enities: [T]) -> Bool {
        return identifiers == enities.map { String(describing: $0) }
    }
}

// MARK: Runing

print("==== Runing ====")

class MockCalculatorObserver: CounterProcessObserving {
    func counterProccess(_ process: CounterProcess, didChangeState state: Int) {
        print("-> state: \(state)")
    }
}

func run(process: Process<CounterProcessObserving>) {
    process.execute(IncrementCommand())
    process.execute(IncrementCommand())
    process.execute(IncrementCommand())
    process.execute(DecrementCommand())
    process.execute(DecrementCommand())
    process.execute(DecrementCommand())
}

let observer = MockCalculatorObserver()
let process = CounterProcess()
process.observe(with: observer)
run(process: process)



// MARK: Testing

print("==== Testing ====")

let mockProcess = MockProcess<CounterProcessObserving>()

mockProcess.for(IncrementCommand.self)
    .when { $0.callsCount == 1 }
    .then { _ in print("-> fist increment call") }

mockProcess.for(DecrementCommand.self)
    .when { $0.callsCount == 3 }
    .then { _ in print("-> last decrement call") }

mockProcess.for(IncrementCommand.self)
    .then {  print("-> increment call: \($0.callsCount)") }

run(process: mockProcess)

print("Increment calls = 3 ?", mockProcess.verify(IncrementCommand.self, count: 3))
print("Decrement calls = 3 ?", mockProcess.verify(DecrementCommand.self, count: 3))

let isInOrder = mockProcess.verifyInOrder([
    IncrementCommand.self,
    IncrementCommand.self,
    IncrementCommand.self,
    DecrementCommand.self,
    DecrementCommand.self,
    DecrementCommand.self
])
print("Verify in order ?", isInOrder)

