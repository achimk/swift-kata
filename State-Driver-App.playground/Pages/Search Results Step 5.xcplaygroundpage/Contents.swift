//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define search API ✅
 2. Define SearchResultsObservable ✅
 3. Define State of SearchResultsObservable ✅
 4. Update actions and add dispatcher ✅
 5. Prepare action binding ✅
 6. Prepare state update
 7. Prepare side effect
 
*/

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

    }
}


//: [Next](@next)
