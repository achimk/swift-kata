//: [Previous](@previous)

/*:
 >Indirect - Concrete
 */

struct Change {
    var name: String = ""
}

struct Validation {
    var name: String?
    mutating func validate(name value: String) {
        name = value.isEmpty ? "Invalid name" : nil
    }
}

struct PersonForm {
    private(set) var change = Change()
    private(set) var validation = Validation()
    
    mutating func set(name value: String) {
        change.name = value
        validation.validate(name: value)
    }
}

var form = PersonForm()
form.set(name: "Adam")


//: [Next](@next)
