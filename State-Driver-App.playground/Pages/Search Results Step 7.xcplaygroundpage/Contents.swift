//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define search API ✅
 2. Define SearchResultsObservable ✅
 3. Define State of SearchResultsObservable ✅
 4. Update actions and add dispatcher ✅
 5. Prepare action binding ✅
 6. Prepare state update ✅
 7. Prepare side effect ✅
 
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
    
    //...
    
}

extension SearchResultsObservable {
    
    private func prepareBindings() {
        
        // Forward action
        //...
        
        // Update state
        //...
        
        // Handle search for results (side effect)
        Observable
            .combineLatest(dispatcher.asObservable(), searchState.asObservable())
            .compactMap { [weak self] in self?.searchResults(action: $0, state: $1) }
            .flatMapLatest { $0 }
            .bind(to: dispatcher)
            .disposed(by: bag)
    }

    private func searchResults(action: SearchStateObservable.Action, state: SearchStateObservable.State) -> Single<SearchStateObservable.Action>? {

        guard case .search(let text) = action else { return nil }
        guard state == .loading else { return nil }

        return api.search(for: text)
            .map { SearchStateObservable.Action.success($0) }
            .catchError { .just(SearchStateObservable.Action.failure($0)) }
    }
}


//: [Next](@next)
