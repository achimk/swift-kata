//: [Previous](@previous)

import Foundation

struct Person {
    let name: String
    let surname: String
    let age: Int
}

let persons = [
    Person(name: "Adam", surname: "Adamski", age: 22),
    Person(name: "Bartosz", surname: "Bartoszewski", age: 33),
    Person(name: "Cyprian", surname: "Cypriański", age: 11)
]

protocol PersonRepository {
    func all() -> [Person]
    func allSatisfying(_ specification: Specification<Person>) -> [Person]
}

struct InMemoryBasedPersonRepository: PersonRepository {
    let persons: [Person]
    
    func all() -> [Person] {
        return persons
    }
    
    func allSatisfying(_ specification: Specification<Person>) -> [Person] {
        return all().filter(specification.isSatisfied(by:))
    }
}

let specification: Specification<Person> = Specification
    .from { $0.age > 10 }
    .and(.from { $0.age < 30 })

let repository = InMemoryBasedPersonRepository(persons: persons)
let results = repository.allSatisfying(specification)

results.forEach { print($0) }


//: [Next](@next)
