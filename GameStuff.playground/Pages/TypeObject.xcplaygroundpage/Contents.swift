//: [Previous](@previous)

import Foundation

struct Breed {
    let health: Int // starting health
    let attack: String
}

struct Monster {
    let health: Int // current health
    var attack: String { return breed.attack }
    private let breed: Breed
    
    init(breed: Breed) {
        self.health = breed.health
        self.breed = breed
    }
}

extension Breed {
    // defer initialization of Monster (large resources)
    func makeMonster() -> Monster {
        return Monster(breed: self)
    }
}

//: [Next](@next)
