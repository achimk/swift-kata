//: [Previous](@previous)

/*:
 
 ### Search results test case
 
*/

import RxSwift
import RxCocoa
import XCTest

typealias SearchItem = String

final class SearchStateObservable: ObservableConvertibleType {
    
    enum State {
        case start
        case searching
        case loading
        case searchResults
        case error
    }
    
    enum Action {
        case startSearch
        case cancel
        case search(String)
        case success([SearchItem])
        case failure(Error)
    }
    
    private let state = BehaviorRelay<State>(value: .start)
    private let bag = DisposeBag()
    
    var current: State { return state.value }
    
    init() { }
    
    func dispatch(_ action: Action) {
        switch (current, action) {
        case (.start, .startSearch): state.accept(.searching)
        case (.searching, .search): state.accept(.loading)
        case (.searching, .cancel): state.accept(.start)
        case (.loading, .success): state.accept(.searchResults)
        case (.loading, .failure): state.accept(.error)
        case (.searchResults, .startSearch): state.accept(.searching)
        case (.error, .startSearch): state.accept(.searching)
        default: return
        }
    }
    
    func asObservable() -> Observable<State> {
        return state.asObservable()
    }

}

protocol SearchAPI {
    func search(for value: String) -> Single<[SearchItem]>
}

final class SearchResultsObservable: ObservableConvertibleType {

    struct State {
        var searchState: SearchStateObservable.State
        var searchText: String? = nil
        var searchResults: [SearchItem] = []
    }
    
    private let api: SearchAPI
    private let state: BehaviorRelay<State>
    private let dispatcher = PublishRelay<SearchStateObservable.Action>()
    private let searchState = SearchStateObservable()
    private let bag = DisposeBag()
    
    var current: State { return state.value }
    
    init(api: SearchAPI) {
        self.api = api
        self.state = .init(value: State(searchState: searchState.current))
        prepareBindings()
    }
    
    func enterSearch() {
        dispatcher.accept(.startSearch)
    }
    
    func cancelSearch() {
        dispatcher.accept(.cancel)
    }
    
    func search(for text: String) {
        dispatcher.accept(.search(text))
    }
    
    func asObservable() -> Observable<State> {
        return state.asObservable()
    }
    
}

extension SearchResultsObservable {
    
    private func prepareBindings() {
        
        // Forward action
        dispatcher
            .bind(onNext: { [weak self] in self?.searchState.dispatch($0) })
            .disposed(by: bag)
        
        // Update state
        Observable
            .combineLatest(dispatcher.asObservable(), searchState.asObservable())
            .compactMap { [weak self] in self?.handle(action: $0, state: $1) }
            .bind(to: state)
            .disposed(by: bag)
        
        // Handle search for results (side effect)
        Observable
            .combineLatest(dispatcher.asObservable(), searchState.asObservable())
            .compactMap { [weak self] in self?.searchResults(action: $0, state: $1) }
            .flatMapLatest { $0 }
            .bind(to: dispatcher)
            .disposed(by: bag)
    }
    
    private func handle(action: SearchStateObservable.Action, state: SearchStateObservable.State) -> State {
        
        var newState = current
        newState.searchState = state
        
        switch (action, state) {
            
        case (.startSearch, .searching):
            newState.searchText = nil
            
        case (.search(let text), .loading):
            newState.searchText = text
            
        case (.success(let items), .searchResults):
            newState.searchResults = items
            
        default:
            break
        }
        
        return newState
    }
    
    private func searchResults(action: SearchStateObservable.Action, state: SearchStateObservable.State) -> Single<SearchStateObservable.Action>? {

        guard case .search(let text) = action else { return nil }
        guard state == .loading else { return nil }

        return api.search(for: text)
            .map { SearchStateObservable.Action.success($0) }
            .catchError { .just(SearchStateObservable.Action.failure($0)) }
    }
}

final class SearchStateObservableTests: XCTestCase {
    
    private struct TestError: Error { }
    private var lastExpectation: XCTestExpectation?
    private var lastState: [SearchStateObservable.State] = [] {
        didSet { lastExpectation?.fulfill(); lastExpectation = nil }
    }
    private var bag = DisposeBag()
    
    override func tearDown() {
        lastState = []
        bag = DisposeBag()
        super.tearDown()
    }
    
    func testInitialState() {
    
        let state = SearchStateObservable()
        bind(state)
        
        XCTAssertEqual(lastState, [.start])
    }
    
    func testSearchingTransition() {
        
        let state = SearchStateObservable()
        bind(state)
        
        wait { state.dispatch(.startSearch) }
        
        XCTAssertEqual(lastState, [
            .start,
            .searching
        ])
    }
    
    func testCancelSearchingTransition() {
        
        let state = SearchStateObservable()
        bind(state)
        
        wait { state.dispatch(.startSearch) }
        wait { state.dispatch(.cancel) }
        
        XCTAssertEqual(lastState, [
            .start,
            .searching,
            .start
        ])
    }
    
    func testLoadingTransition() {
        
        let state = SearchStateObservable()
        bind(state)
        
        wait { state.dispatch(.startSearch) }
        wait { state.dispatch(.search("test")) }
        
        XCTAssertEqual(lastState, [
            .start,
            .searching,
            .loading
        ])
    }
    
    func testSuccessTransition() {
        
        let state = SearchStateObservable()
        bind(state)
        
        wait { state.dispatch(.startSearch) }
        wait { state.dispatch(.search("test")) }
        wait { state.dispatch(.success(["1", "2", "3"])) }

        XCTAssertEqual(lastState, [
            .start,
            .searching,
            .loading,
            .searchResults
        ])
    }
    
    func testFailureTransition() {
        
        let state = SearchStateObservable()
        bind(state)

        wait { state.dispatch(.startSearch) }
        wait { state.dispatch(.search("test")) }
        wait { state.dispatch(.failure(TestError())) }
        
        XCTAssertEqual(lastState, [
            .start,
            .searching,
            .loading,
            .error
        ])
    }
    
    func testSearchingFromSuccessTransition() {
     
        let state = SearchStateObservable()
        bind(state)

        wait { state.dispatch(.startSearch) }
        wait { state.dispatch(.search("test")) }
        wait { state.dispatch(.success(["1", "2", "3"])) }
        wait { state.dispatch(.startSearch) }
        
        XCTAssertEqual(lastState, [
            .start,
            .searching,
            .loading,
            .searchResults,
            .searching
        ])
    }
    
    func testSearchingFromFailureTransition() {
        
        let state = SearchStateObservable()
        bind(state)

        wait { state.dispatch(.startSearch) }
        wait { state.dispatch(.search("test")) }
        wait { state.dispatch(.failure(TestError())) }
        wait { state.dispatch(.startSearch) }

        XCTAssertEqual(lastState, [
            .start,
            .searching,
            .loading,
            .error,
            .searching
        ])
    }
    
    private func bind(_ state: SearchStateObservable) {
        state.asObservable()
            .subscribe(onNext: { [weak self] state in self?.lastState.append(state) })
            .disposed(by: bag)
    }
    
    private func wait(for action: () -> ()) {
        let e = expectation(description: "wait")
        self.lastExpectation = e
        action()
        wait(for: [e], timeout: 1)
    }
}


final class SearchResultsObservableTests: XCTestCase {

    private struct StubAPI: SearchAPI {
        
        let publisher = PublishRelay<Result<[SearchItem], Error>>()
        
        func search(for value: String) -> Single<[SearchItem]> {
            return Single.create { [publisher] (observer) -> Disposable in
                return publisher.subscribe(onNext: { result in
                    switch result {
                    case .success(let items):
                        observer(.success(items))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            }
        }
    }
    
    private struct TestError: Error { }
    private var lastExpectation: XCTestExpectation?
    private var lastState: SearchResultsObservable.State? {
        didSet { lastExpectation?.fulfill(); lastExpectation = nil }
    }
    private var bag = DisposeBag()
    
    override func tearDown() {
        lastState = nil
        bag = DisposeBag()
        super.tearDown()
    }
    
    func testInitialState() {
        
        let components = prepareTestComponents()
        bind(components.state)
        
        XCTAssertEqual(lastState?.searchState, .start)
        XCTAssertEqual(lastState?.searchText, nil)
        XCTAssertEqual(lastState?.searchResults, [])
    }
    
    func testSearchingTransition() {
        
        let components = prepareTestComponents()
        bind(components.state)
        
        wait(for: components.action.enterSearch)
        
        XCTAssertEqual(lastState?.searchState, .searching)
        XCTAssertEqual(lastState?.searchText, nil)
        XCTAssertEqual(lastState?.searchResults, [])
    }
    
    func testCancelSearchingTransition() {
        
        let components = prepareTestComponents()
        bind(components.state)
        
        wait(for: components.action.enterSearch)
        wait(for: components.action.cancelSearch)
        
        XCTAssertEqual(lastState?.searchState, .start)
        XCTAssertEqual(lastState?.searchText, nil)
        XCTAssertEqual(lastState?.searchResults, [])
    }
    
    func testLoadingTransition() {
        let components = prepareTestComponents()
        bind(components.state)
        
        wait(for: components.action.enterSearch)
        wait { components.action.searchText("test") }
        
        XCTAssertEqual(lastState?.searchState, .loading)
        XCTAssertEqual(lastState?.searchText, "test")
        XCTAssertEqual(lastState?.searchResults, [])
    }
    
    func testSuccessTransition() {
        let components = prepareTestComponents()
        bind(components.state)
        
        wait(for: components.action.enterSearch)
        wait { components.action.searchText("test") }
        wait { components.action.searchSuccess(["1", "2", "3"]) }
        
        XCTAssertEqual(lastState?.searchState, .searchResults)
        XCTAssertEqual(lastState?.searchText, "test")
        XCTAssertEqual(lastState?.searchResults, ["1", "2", "3"])
    }
    
    func testFailureTransition() {
        let components = prepareTestComponents()
        bind(components.state)
        
        wait(for: components.action.enterSearch)
        wait { components.action.searchText("test") }
        wait { components.action.searchFailure(TestError()) }
        
        XCTAssertEqual(lastState?.searchState, .error)
        XCTAssertEqual(lastState?.searchText, "test")
        XCTAssertEqual(lastState?.searchResults, [])
    }
    
    func testSearchingFromSuccessTransition() {
        let components = prepareTestComponents()
        bind(components.state)
        
        wait(for: components.action.enterSearch)
        wait { components.action.searchText("test") }
        wait { components.action.searchSuccess(["1", "2", "3"]) }
        wait(for: components.action.enterSearch)
        
        XCTAssertEqual(lastState?.searchState, .searching)
        XCTAssertEqual(lastState?.searchText, nil)
        XCTAssertEqual(lastState?.searchResults, ["1", "2", "3"])
    }
    
    func testSearchingFromFailureTransition() {
        
        let components = prepareTestComponents()
        bind(components.state)
        
        wait(for: components.action.enterSearch)
        wait { components.action.searchText("test") }
        wait { components.action.searchFailure(TestError()) }
        wait(for: components.action.enterSearch)
        
        XCTAssertEqual(lastState?.searchState, .searching)
        XCTAssertEqual(lastState?.searchText, nil)
        XCTAssertEqual(lastState?.searchResults, [])
    }
    
    typealias TestComponents = (state: SearchResultsObservable, action: Action)
    typealias Action = (
        enterSearch: () -> (),
        cancelSearch: () -> (),
        searchText: (String) -> (),
        searchSuccess: ([SearchItem]) -> (),
        searchFailure: (Error) -> ()
    )

    private func prepareTestComponents() -> TestComponents {
        
        let api = StubAPI()
        let state = SearchResultsObservable(api: api)
        let enterSearch = state.enterSearch
        let cancelSearch = state.cancelSearch
        let searchText = state.search(for:)
        let searchSuccess: ([SearchItem]) -> () = { api.publisher.accept(.success($0)) }
        let searchFailure: (Error) -> () = { api.publisher.accept(.failure($0)) }
        
        return (state, (enterSearch, cancelSearch, searchText, searchSuccess, searchFailure))
    }
    
    private func bind(_ state: SearchResultsObservable) {
        state.asObservable()
            .subscribe(onNext: { [weak self] state in self?.lastState = state })
            .disposed(by: bag)
    }
    
    private func wait(for action: () -> ()) {
        let e = expectation(description: "wait")
        self.lastExpectation = e
        action()
        wait(for: [e], timeout: 1)
    }
}


//: [Next](@next)
