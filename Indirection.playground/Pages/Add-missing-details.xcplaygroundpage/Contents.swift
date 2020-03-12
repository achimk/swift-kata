//: [Previous](@previous)

/*:
 
 2. Add details for diff - add original value, current state and modified flag

*/

struct PersonChange {
    
    struct Change<T> {
        var original: T
        var value: T
        var isModified: Bool
    }
    
    let name: Change<String?>
}

struct PersonForm {
    let change: PersonChange
}

//: [Next](@next)
