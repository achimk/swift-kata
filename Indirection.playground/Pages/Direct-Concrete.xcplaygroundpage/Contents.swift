//: [Previous](@previous)

/*:
 >Direct - Concrete
 */
struct PersonForm {
    
    struct Name {
        var value: String = ""
        var error: String?
    }
    
    var name = Name()
}

var form = PersonForm()
form.name.value = "Adam"
form.name.error = form.name.value.isEmpty ? "Invalid name" : nil

//: [Next](@next)
