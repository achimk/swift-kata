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
        let indicator = prepareTestActionStateIndicator()
        expect(indicator.current.action.isPresent) == false
        expect(indicator.current.state.isInitial) == true
    }
    
    func testLoadingState() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { _ in true })
        indicator.dispatch(.get)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isLoading) == true
    }
    
    func testSuccessState() {
        let indicator = prepareTestActionStateIndicator()
        indicator.dispatch(.get)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isSuccess) == true
        indicator.current.state.onSuccess { (value) in
            expect(value) == 1
        }
    }
    
    func testFailureState() {
        let indicator = prepareTestActionStateIndicator(shouldFailure: { _ in true })
        indicator.dispatch(.get)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isFailure) == true
        indicator.current.state.onFailure { (error) in
            expect(error).to(beAKindOf(TestError.self))
        }
    }
    
    func testDispatchDuringLoading() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update)
        expect(indicator.current.action) == .get
        expect(indicator.current.state.isLoading) == true
    }
    
    func testForceDispatchDuringLoading() {
        let indicator = prepareTestActionStateIndicator(shouldLoading: { $0 == .get })
        indicator.dispatch(.get)
        indicator.dispatch(.update, force: true)
        expect(indicator.current.action) == .update
        expect(indicator.current.state.isSuccess) == true
        indicator.current.state.onSuccess { (value) in
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
