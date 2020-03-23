//
//  Created by Joachim Kret on 13/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import RxSwift
import CoreKit

final class InMemoryPersonRepository: PersonRepository {
    
    enum PersonListError: Error {
        case createFailure
        case updateFailure
        case deleteFailure
    }
    
    final class PersonList {
        
        private let queue = DispatchQueue(label: "PersonList", qos: .userInteractive, attributes: .concurrent)
        private var items: [Person]
        
        init(items: [Person] = []) {
            self.items = items
        }
        
        func read(where specification: Specification<Person>? = nil, completion: @escaping ([Person]) -> ()) {
            queue.async { [weak self] in
                let items = self?.items ?? []
                switch specification {
                case .none:
                    completion(items)
                case .some(let specification):
                    completion(items.filter(specification.isSatisfied(by:)))
                }
            }
        }
        
        func write(modify: @escaping (inout [Person]) -> ()) {
            queue.async(flags: .barrier) { [weak self] in
                if var items = self?.items {
                    modify(&items)
                    self?.items = items
                }
            }
        }
    }

    private var list: PersonList
    private let idGenerator: () -> String
    
    init(items: [Person] = [], idGenerator: @escaping () -> String = { UUID().uuidString }) {
        self.list = PersonList(items: items)
        self.idGenerator = idGenerator
    }
    
    func all() -> Single<[Person]> {
        return Single.create { [list] (consumer) -> Disposable in
            list.read { (all) in
                consumer(.success(all))
            }
            return Disposables.create()
        }
    }
    
    func allSatisfying(_ specification: Specification<Person>) -> Single<[Person]> {
        return Single.create { [list] (consumer) -> Disposable in
            list.read(where: specification) { (all) in
                consumer(.success(all))
            }
            return Disposables.create()
        }
    }
    
    func find(with id: PersonId) -> Single<Person?> {
        return Single.create { [list] (consumer) -> Disposable in
            let spec = Specification<Person>.from { $0.id == id }
            list.read(where: spec) { (all) in
                consumer(.success(all.first))
            }
            return Disposables.create()
        }
    }
    
    func add(person: ValidatedPerson) -> Single<Person> {
        return Single.create { [list, idGenerator] (consumer) -> Disposable in
            list.write { (items) in
                guard let id = PersonId(idGenerator()) else {
                    consumer(.error(PersonListError.createFailure))
                    return
                }
                let newPerson = Person(
                    id: id,
                    name: person.name,
                    surname: person.surname,
                    age: person.age)
                
                items.append(newPerson)
                
                let spec = Specification<Person>.from { $0.id == id }
                list.read(where: spec) { (items) in
                    items.first.ifPresent({
                        consumer(.success($0))
                    }, otherwise: {
                        consumer(.error(PersonListError.createFailure))
                    })
                }
            }
            return Disposables.create()
        }
    }
    
    func update(with id: PersonId, person: ValidatedPerson) -> Single<Person> {
        return Single.create { [list] (consumer) -> Disposable in
            list.write { (items) in
                guard let index = items.firstIndex(where: { $0.id == id }) else {
                    consumer(.error(PersonListError.updateFailure))
                    return
                }
                let newPerson = Person(
                    id: id,
                    name: person.name,
                    surname: person.surname,
                    age: person.age)
                
                items.remove(at: index)
                items.insert(newPerson, at: index)
                
                let spec = Specification<Person>.from { $0.id == id }
                list.read(where: spec) { (items) in
                    items.first.ifPresent({
                        consumer(.success($0))
                    }, otherwise: {
                        consumer(.error(PersonListError.updateFailure))
                    })
                }
            }
            return Disposables.create()
        }
    }
    
    func remove(with id: PersonId) -> Single<Void> {
        return Single.create { [list] (consumer) -> Disposable in
            list.write { (items) in
                guard let index = items.firstIndex(where: { $0.id == id }) else {
                    consumer(.error(PersonListError.deleteFailure))
                    return
                }
                
                items.remove(at: index)
                
                let spec = Specification<Person>.from { $0.id == id }
                list.read(where: spec) { (items) in
                    items.first.ifPresent({ _ in
                        consumer(.success(()))
                    }, otherwise: {
                        consumer(.error(PersonListError.deleteFailure))
                    })
                }
            }
            return Disposables.create()
        }
    }
    
}


enum PersonListError: Error {
    
}

final class PersonList {

    private let queue = DispatchQueue(label: "PersonList", qos: .userInteractive, attributes: .concurrent)
    private let idGenerator: () -> String
    private var items: [Person]
    
    init(items: [Person] = [], idGenerator: @escaping () -> String = { UUID().uuidString }) {
        self.items = items
        self.idGenerator = idGenerator
    }
    
    func queryAll(where specification: Specification<Person>? = nil, completion: @escaping (Result<[Person], PersonListError>) -> ()) {
        
    }
    
    func add(person: ValidatedPerson, completion: @escaping (Result<Person, PersonListError>) -> ()) {
        
    }
    
    func update(person: ValidatedPerson, for id: PersonId, completion: @escaping (Result<Person, PersonListError>) -> ()) {
        
    }
    
    func remove(for id: PersonId, completion: @escaping (Result<Void, PersonListError>) -> ()) {
        
    }
    
    private func prepareRead(for specification: Specification<Person>? = nil, completion: @escaping ([Person]) -> ()) {
        queue.async { [weak self] in
            let items = self?.items ?? []
            switch specification {
            case .none:
                completion(items)
            case .some(let specification):
                completion(items.filter(specification.isSatisfied(by:)))
            }
        }
    }
    
    private func prepareWrite() -> (@escaping (inout [Person]) -> ()) -> () {
        return { [queue, weak self] modify in
            queue.async(flags: .barrier) { [weak self] in
                if var items = self?.items {
                    modify(&items)
                    self?.items = items
                }
            }
        }
    }
}
