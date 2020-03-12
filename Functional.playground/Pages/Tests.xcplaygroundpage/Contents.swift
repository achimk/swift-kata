//: [Previous](@previous)

import Foundation

final class API {
    
    func prepare(dependency1: Int, dependency2: Int, key: String) -> Result<String, Swift.Error> {
        return .success("test")
    }
}

final class ViewModel {
    
    let provider: (String) -> Result<String, Swift.Error>
    
    init(provider: @escaping (String) -> Result<String, Swift.Error>) {
        self.provider = provider
    }
}

let api = API()

// function world

let provider1 = curry(api.prepare(dependency1:dependency2:key:))

let vm1 = ViewModel(provider: provider1(1)(2))

// Swift world

let provider2: (String) -> Result<String, Swift.Error> = { key in
    return api.prepare(dependency1: 1, dependency2: 2, key: key)
}

let vm2 = ViewModel(provider: provider2)



//: [Next](@next)
