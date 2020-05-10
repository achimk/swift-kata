//
//  Created by Joachim Kret on 10/05/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import RxFun

final class ActionStateIndicatorTests: XCTestCase {
    
    struct TestError: Error, Equatable { }
    
    enum Action {
        case get
        case update
        case delete
    }
    
    func testInitialState() {
        let state = prepareTestActionStateIndicator()
        expect(state.current.isInitial) == true
    }
    
    func testLoadingState() {
        let state = prepareTestActionStateIndicator(shouldLoading: { _ in true })
        state.dispatch(.get)
        expect(state.current.isLoading) == true
    }
    
    func testSuccessState() {
        let state = prepareTestActionStateIndicator()
        state.dispatch(.get)
        expect(state.current.isSuccess) == true
        state.current.onSuccess { (value) in
            expect(value) == 1
        }
    }
    
    func testFailureState() {
        let state = prepareTestActionStateIndicator(shouldFailure: { _ in true })
        state.dispatch(.get)
        expect(state.current.isFailure) == true
        state.current.onFailure { (error) in
            expect(error).to(beAKindOf(TestError.self))
        }
    }
    
    func testDispatchDuringLoading() {
        let state = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        state.dispatch(.get)
        state.dispatch(.update)
        expect(state.current.isLoading) == true
    }
    
    func testForceDispatchDuringLoading() {
        let state = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        state.dispatch(.get)
        state.dispatch(.update, force: true)
        expect(state.current.isSuccess) == true
        state.current.onSuccess { (value) in
            expect(value) == 2
        }
    }
    
    private func prepareTestActionStateIndicator(
        shouldLoading loadingOnAction: @escaping (Action) -> Bool = { _ in false },
        shouldFailure failureOnAction: @escaping (Action) -> Bool = { _ in false }) -> ActionStateIndicator<Action, Int> {

        return ActionStateIndicator<Action, Int>.init { (action) -> Single<Int> in
            if loadingOnAction(action) {
                return .never()
            }
            if failureOnAction(action) {
                return .error(TestError())
            }
            switch action {
            case .get: return .just(1)
            case .update: return .just(2)
            case .delete: return .just(3)
            }
        }
    }
}
