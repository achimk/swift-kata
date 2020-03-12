//: [Previous](@previous)

/*:
 
 3. Add safe mutation

*/

struct PersonChange {
    
    struct Change<T> {
        var original: T
        var value: T
        var isModified: Bool
    }
    
    let name: Change<String?>
    
    func set(name value: String?) -> PersonChange {
        
        var change = name
        change.value = value
        change.isModified = change.original != value
        
        return PersonChange(name: change)
    }
}

struct PersonForm {
    let change: PersonChange
}

//: [Next](@next)
