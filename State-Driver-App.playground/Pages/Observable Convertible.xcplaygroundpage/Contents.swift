//: [Previous](@previous)

/*:
 
 ### Observable Convertible Definition
   
*/

protocol ObservableConvertibleType {
    /// Type of elements in sequence.
    associatedtype Element

    /// Converts `self` to `Observable` sequence.
    ///
    /// - returns: Observable sequence that represents `self`.
    func asObservable() -> Observable<Element>
}



//: [Next](@next)
