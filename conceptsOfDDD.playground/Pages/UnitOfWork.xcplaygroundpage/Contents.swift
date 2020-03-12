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
    func add(_ person: Person)
    func update(_ person: Person)
    func remove(_ person: Person)
    func all() -> [Person]
}

struct DBContext {
    func dispose() { }
    func saveChanges() { }
}

final class DBPersonRespository: PersonRepository {
    init(context: DBContext) { }
    func add(_ person: Person) { }
    func update(_ person: Person) { }
    func remove(_ person: Person) { }
    func all() -> [Person] { return [] }
}

protocol PersonUnitOfWorkType {
    func add(_ person: Person)
    func update(_ person: Person)
    func remove(_ person: Person)
    func commit()
    func dispose()
}

final class PersonUnitOfWork {
    
    private let context: DBContext
    private var new: [Person] = []
    private var dirty: [Person] = []
    private var removed: [Person] = []
    let repository: PersonRepository
    
    init(context: DBContext) {
        self.context = context
        self.repository = DBPersonRespository(context: context)
    }
    
    func add(_ person: Person) {
        new.append(person)
    }
    
    func update(_ person: Person) {
        dirty.append(person)
    }
    
    func remove(_ person: Person) {
        removed.append(person)
    }
    
    func commit() {
        insertNew()
        updateDirty()
        deleteRemoved()
        cleanUp()
        context.saveChanges()
    }
    
    func dispose() {
        cleanUp()
        context.dispose()
    }
    
    private func insertNew() {
        new.forEach { repository.add($0) }
    }
    
    private func updateDirty() {
        dirty.forEach { repository.update($0) }
    }
    
    private func deleteRemoved() {
        removed.forEach { repository.remove($0) }
    }
    
    private func cleanUp() {
        new = []
        dirty = []
        removed = []
    }
}

//: [Next](@next)
