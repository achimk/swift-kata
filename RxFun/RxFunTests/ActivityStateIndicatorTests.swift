//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import RxFun

final class ActivityStateIndicatorTests: XCTestCase {
    
    struct TestError: Error, Equatable { }
    
    func testInitialState() {
        let state = prepareTestActivityStateIndicator()
        expect(state.current.isInitial) == true
    }
    
    func testLoadingState() {
        let state = prepareTestActivityStateIndicator(shouldLoading: { true })
        state.dispatch()
        expect(state.current.isLoading) == true
    }
    
    func testSuccessState() {
        let state = prepareTestActivityStateIndicator()
        state.dispatch()
        expect(state.current.isSuccess) == true
        state.current.onSuccess { (value) in
            expect(value) == 1
        }
    }
    
    func testFailureState() {
        let state = prepareTestActivityStateIndicator(shouldFailure: { true })
        state.dispatch()
        expect(state.current.isFailure) == true
        state.current.onFailure { (error) in
            expect(error).to(beAKindOf(TestError.self))
        }
    }
    
    func testDispatchDuringLoading() {
        var call = 0
        let state = prepareTestActivityStateIndicator(shouldLoading: { call += 1; return true })
        state.dispatch()
        state.dispatch()
        expect(state.current.isLoading) == true
        expect(call) == 1
    }
    
    func testForceDispatchDuringLoading() {
        var call = 0
        let state = prepareTestActivityStateIndicator(shouldLoading: { call += 1; return true })
        state.dispatch()
        state.dispatch(force: true)
        expect(state.current.isLoading) == true
        expect(call) == 2
    }
    
    private func prepareTestActivityStateIndicator(
        shouldLoading loadingOnAction: @escaping () -> Bool = { false },
        shouldFailure failureOnAction: @escaping () -> Bool = { false }) -> ActivityStateIndicator<Int> {

        return ActivityStateIndicator { () -> Single<Int> in
            if loadingOnAction() {
                return .never()
            }
            if failureOnAction() {
                return .error(TestError())
            }
            return .just(1)
        }
    }
}
