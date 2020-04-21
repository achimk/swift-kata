//
//  Created by Joachim Kret on 12/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import CoreKit

final class ResultStateTests: XCTestCase {
    
    typealias State = ResultState<Int, String>
    
    struct TestError: Error, Equatable { }
    
    func testIsInitial() {
        let state = State.initial
        expect(state.isInitial) == true
    }
    
    func testInvokedInitial() {
        var invoked = false
        let state = State.initial
        state.onInitial { invoked = true }
        expect(invoked) == true
    }
    
    func testInitialValue() {
        let state = State.initial
        expect(state.value).to(beNil())
    }
    
    func testInitialError() {
        let state = State.initial
        expect(state.error).to(beNil())
    }
    
    func testIsLoading() {
        let state = State.loading
        expect(state.isLoading) == true
    }
    
    func testInvokedLoading() {
        var invoked = false
        let state = State.loading
        state.onLoading { invoked = true }
        expect(invoked) == true
    }
    
    func testLoadingValue() {
        let state = State.loading
        expect(state.value).to(beNil())
    }
    
    func testLoadingError() {
        let state = State.loading
        expect(state.error).to(beNil())
    }
    
    func testIsSuccess() {
        let state = State.success(1)
        expect(state.isSuccess) == true
    }
    
    func testInvokedSuccess() {
        var invokedValue: Int?
        let state = State.success(1)
        state.onSuccess { invokedValue = $0 }
        expect(invokedValue) == 1
    }
    
    func testSuccessValue() {
        let state = State.success(1)
        expect(state.value) == 1
    }
    
    func testSuccessError() {
        let state = State.success(1)
        expect(state.error).to(beNil())
    }
    
    func testIsFailure() {
        let state = State.failure("test")
        expect(state.isFailure) == true
    }
    
    func testInvokedFailure() {
        var invokedValue: String?
        let state = State.failure("test")
        state.onFailure { invokedValue = $0 }
        expect(invokedValue) == "test"
    }
    
    func testFailureValue() {
        let state = State.failure("test")
        expect(state.value).to(beNil())
    }
    
    func testFailureError() {
        let state = State.failure("test")
        expect(state.error) == "test"
    }
    
    func testEquatable() {
        let initial = State.initial
        let loading = State.loading
        let success = State.success(1)
        let failure = State.failure("test")
        
        expect(initial) == initial
        expect(loading) == loading
        expect(success) == success
        expect(failure) == failure
    }
    
    func testNotEquatable() {
        let initial = State.initial
        let loading = State.loading
        let success = State.success(1)
        let failure = State.failure("test")
        
        expect(initial) != loading
        expect(initial) != success
        expect(initial) != failure
        expect(loading) != initial
        expect(loading) != success
        expect(loading) != failure
        expect(success) != initial
        expect(success) != loading
        expect(success) != failure
        expect(failure) != initial
        expect(failure) != loading
        expect(failure) != success
    }
    
    func testResultConversion() {
     
        let initial = ResultState<Int, TestError>.initial
        let loading = ResultState<Int, TestError>.loading
        let success = ResultState<Int, TestError>.success(1)
        let failure = ResultState<Int, TestError>.failure(TestError())
        
        expect(initial.result).to(beNil())
        expect(loading.result).to(beNil())
        expect(success.result).toNot(beNil())
        expect(failure.result).toNot(beNil())
        
        success.result.ifPresent { (result) in
            expect(result.value) == 1
        }
        
        failure.result.ifPresent { (result) in
            expect(result.error) == TestError()
        }
    }
}


extension ResultStateTests {
    
    func testRaw() {
        
        let items: [ResultStateRaw] = [
            .success,
            .success ,
            .failure,
            .success,
            .success
        ]
        
        let reduced = items.reduce(ResultStateRaw.initial, reduce(_:_:))
        
        print(reduced)
    }
}

extension ResultState where Success == Void {
    public static var success: ResultState { return ResultState.success(()) }
}

extension ResultState where Failure == Void {
    public static var failure: ResultState { return ResultState.failure(()) }
}

public typealias ResultStateRaw = ResultState<Void, Void>

public func reduce(_ lhs: ResultStateRaw, _ rhs: ResultStateRaw) -> ResultStateRaw {
    
    switch (lhs, rhs) {
    
    case (.initial, .loading): return .loading
    case (.loading, .initial): return .loading
        
    case (.initial, _): return .initial
    case (_, .initial): return .initial

    case (.loading, _): return .loading
    case (_, .loading): return .loading
    
    case (.failure, _): return .failure
    case (_, .failure): return .failure
    
    case (.success, .success): return .success
    }
}
