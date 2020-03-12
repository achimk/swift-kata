//: [Previous](@previous)

/*:
 
 ### Sample code
 
 1. Define search API ✅
 2. Define SearchResultsObservable ✅
 3. Define State of SearchResultsObservable ✅
 4. Update actions and add dispatcher ✅
 5. Prepare action binding ✅
 6. Prepare state update ✅
 7. Prepare side effect
 
*/

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
    
    //...
    
}

extension SearchResultsObservable {
    
    private func prepareBindings() {
        
        // Forward action
        //...
        
        // Update state
        Observable
            .combineLatest(dispatcher.asObservable(), searchState.asObservable())
            .compactMap { [weak self] in self?.handle(action: $0, state: $1) }
            .bind(to: state)
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
}


//: [Next](@next)
