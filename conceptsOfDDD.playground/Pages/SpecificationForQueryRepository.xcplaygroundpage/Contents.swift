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

protocol PersonSpecification: Specifying where Candidate == Person {
    func satisfiedPersons(from repository: PersonRepository) -> [Person]
}

protocol PersonRepository {
    func all(before birthDate: Date) -> [Person]
}

struct InMemoryBasedPersonRepository: PersonRepository {
    let persons: [Person]
    
    func all(before birthDate: Date) -> [Person] {
        
        let query = prepareQuery(birthDate)
        let results = executeQuery(query)
        let persons = buildPersonsFrom(results)
        
        return persons
    }
    
    private func prepareQuery(_ date: Date) -> String {
        // Simulate prepare query
        return "SELECT * FROM PERSON WHERE PERSON.BIRTH < \(date)"
    }
    
    private func executeQuery(_ query: String) -> [Data] {
        // Simulate query execution
        return []
    }
    
    private func buildPersonsFrom(_ results: [Data]) -> [Person] {
        // Simulate mapping for results
        return persons
    }
}

final class MaturePersonSpecification: PersonSpecification {
    
    func isSatisfied(by candidate: Person) -> Bool {
        return candidate.age >= 18
    }
    
    /**
     Seperates details query from specification by passing PersonRepository as a parameter
     */
    func satisfiedPersons(from repository: PersonRepository) -> [Person] {
        return repository.all(before: Date()).filter { isSatisfied(by: $0) }
        
    }
}

let repository = InMemoryBasedPersonRepository(persons: persons)
let specification = MaturePersonSpecification()

let results = specification.satisfiedPersons(from: repository)

results.forEach { print($0) }


//: [Next](@next)
