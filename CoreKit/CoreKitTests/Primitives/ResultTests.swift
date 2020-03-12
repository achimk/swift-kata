//
//  Created by Joachim Kret on 12/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import CoreKit

final class ResultTests: XCTestCase {
    
    struct StringError: Swift.Error, Equatable {
        var value: String
        init(_ value: String) { self.value = value }
    }
    
    struct IntError: Swift.Error, Equatable {
        var value: Int
        init(_ value: Int) { self.value = value }
    }
    
    struct FakeError: Swift.Error { }
    
    
    func testInitializeSuccess() {
        
        let result = Result<Int, StringError>(1)
        
        let value = retrieveValue(from: result, otherwise: 0)
        
        XCTAssertEqual(value, 1)
    }
    
    func testInitializeFailure() {
        
        let result = Result<Int, StringError>(StringError("a"))
        
        let errorReason = retrieveErrorReason(from: result, otherwise: StringError("b"))
        
        XCTAssertEqual(errorReason, StringError("a"))
    }
    
    func testValueProperty() {
        
        let result = Result<Int, StringError>(1)
        
        XCTAssertEqual(result.value, 1)
    }
    
    func testErrorReasonProperty() {
        
        let result = Result<Int, StringError>(StringError("a"))
        
        XCTAssertEqual(result.error, StringError("a"))
    }
    
    func testCheckIsSuccess() {
        
        let result = Result<Int, StringError>(1)
        
        XCTAssertTrue(result.isSuccess)
    }
    
    func testCheckIsFailure() {
        
        let result = Result<Int, StringError>(StringError("a"))
        
        XCTAssertTrue(result.isFailure)
    }
    
    func testOnSuccessClosure() {
        
        var value: Int = 0
        let result = Result<Int, StringError>(1)
        
        result.onSuccess { value = $0 }
        
        XCTAssertEqual(value, 1)
    }
    
    func testOnFailureClosure() {
        
        var errorReason = StringError("b")
        let result = Result<Int, StringError>(StringError("a"))
        
        result.onFailure { errorReason = $0 }
        
        XCTAssertEqual(errorReason, StringError("a"))
    }
    
    func testMap() {
        
        let result = Result<Int, StringError>(1).map { String("-\($0)-") }
        
        let value = retrieveValue(from: result, otherwise: "")
        
        XCTAssertEqual(value, "-1-")
    }
    
    func testFlatMap() {
        
        let result = Result<Int, StringError>(1)
            .flatMap { _ in Result.success("1") }
        
        let value = retrieveValue(from: result, otherwise: "")
        
        XCTAssertEqual(value, "1")
    }
    
    func testMapError() {
        
        let result = Result<Int, StringError>(StringError("1")).mapError { _ in IntError(1) }
        
        let errorReason = retrieveErrorReason(from: result, otherwise: IntError(0))
        
        XCTAssertEqual(errorReason, IntError(1))
    }
    
    func testFlatMapError() {
        
        let result = Result<Int, StringError>(StringError("1"))
            .flatMapError { _ in Result.failure(IntError(1)) }
        
        let value = retrieveErrorReason(from: result, otherwise: IntError(0))
        
        XCTAssertEqual(value, IntError(1))
    }
    
    func testAnalyze() {
        
        let success: (Int) -> Int = { _ in 1 }
        let failure: (StringError) -> Int = { _ in 2 }
        
        let outputValue = Result<Int, StringError>(0).analyze(ifSuccess: success, ifFailure: failure)
        let outputErrorReason = Result<Int, StringError>(StringError("a")).analyze(ifSuccess: success, ifFailure: failure)
        
        XCTAssertEqual(outputValue, 1)
        XCTAssertEqual(outputErrorReason, 2)
    }
    
    func testAnalyzeWithoutInput() {
        
        let success: () -> Int = { 1 }
        let failure: () -> Int = { 2 }
        
        let outputValue = Result<Int, StringError>(0).analyze(ifSuccess: success, ifFailure: failure)
        let outputErrorReason = Result<Int, StringError>(StringError("a")).analyze(ifSuccess: success, ifFailure: failure)
        
        XCTAssertEqual(outputValue, 1)
        XCTAssertEqual(outputErrorReason, 2)
    }
    
    func testConvenienceSuccessVoidValue() {
        
        let result = Result<Void, StringError>.success()
        
        XCTAssertTrue(result.isSuccess)
    }
    
    func testDetermineValue() {
        
        let value = try? Result<Int, FakeError>(1).get()
        
        XCTAssertEqual(value, 1)
    }
    
    func testThrowIfFailure() {
        
        do {
            
            try Result<Int, FakeError>(FakeError()).throwsIfFailure()
            
            XCTFail("Should never happen!")
            
        } catch {
            
            XCTAssertTrue(error as? FakeError != nil)
        }
    }
    
    private func retrieveValue<T, U>(from result: Result<T, U>, otherwise: T) -> T {
        
        switch result {
        case .success(let value): return value
        case .failure: return otherwise
        }
    }
    
    private func retrieveErrorReason<T, U>(from result: Result<T, U>, otherwise: U) -> U {
        
        switch result {
        case .success: return otherwise
        case .failure(let errorReason): return errorReason
        }
    }
    
}
