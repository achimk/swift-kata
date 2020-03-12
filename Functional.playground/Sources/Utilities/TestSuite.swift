import Foundation

public class TestSuite {
    
    let name: String
    var tests: [(name: String, body: ()->())] = []
    
    public static var all: [TestSuite] = []
    
    static let shared = TestSuite("Test")
    
    public init(_ name: String) {
        self.name = name
        TestSuite.all.append(self)
    }
    
    public func test(_ name: String, body: @escaping ()->()) {
        tests.append((name, body))
    }
}

public func test(_ name: String, body: @escaping ()->()) {
    TestSuite.shared.test(name, body: body)
}

public func runAllTests() {
    
    for s in TestSuite.all {
        
        for (testName, f) in s.tests {
            print("\(s.name)/\(testName)...")
            f()
            print("done.\n")
        }
    }
}

public func expectTrue(_ expected: Bool) {
    
    if !expected {
        fatalError("Expected to be true!")
    }
}

public func expectFalse(_ expected: Bool) {
    
    if expected {
        fatalError("Expected to be false!")
    }
}

public func expectEqual<T : Equatable>(_ expected: T, _ x: T) {
    
    if !(x == expected) {
        fatalError("Expected \(expected) == \(x)")
    }
}

public func expectGreater<T: Comparable>(_ a: T, _ b: T) {
    
    if !(a > b) {
        fatalError("Expected \(a) > \(b)")
    }
}

public func expectGreaterEqual<T: Comparable>(_ a: T, _ b: T) {
    
    if !(a >= b) {
        fatalError("Expected \(a) >= \(b)")
    }
}

public func expectLess<T: Comparable>(_ a: T, _ b: T) {
    
    if !(a < b) {
        fatalError("Expected \(a) < \(b)")
    }
}

public func expectLessEqual<T: Comparable>(_ a: T, _ b: T) {
    
    if !(a <= b) {
        fatalError("Expected \(a) <= \(b)")
    }
}
