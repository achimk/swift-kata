import Foundation

public struct SafeList<Element> {
    
    public let first: Element
    public private(set) var last: Element
    public private(set) var all: [Element]
    
    public static func of<S: Sequence>(_ sequence: S) -> SafeList? where S.Iterator.Element == Element {
        
        var list: SafeList<Element>? = nil
        
        sequence.forEach { (element) in
            switch list {
            case .none: list = SafeList<Element>.create(element)
            case .some(let wrapped): list = wrapped.appended(element)
            }
        }
        
        return list
    }
    
    public static func create(_ element: Element) -> SafeList {
        return SafeList(first: element, last: element, all: [element])
    }
    
    public mutating func append(_ element: Element) {
        self.last = element
        self.all.append(element)
    }
    
    public mutating func append<S: Sequence>(of sequence: S) where S.Iterator.Element == Element {
        sequence.forEach { (element) in
            self.last = element
            self.all.append(element)
        }
    }
    
    private init(first: Element, last: Element, all: [Element]) {
        self.first = first
        self.last = last
        self.all = all
    }
    
    public func appended(_ element: Element) -> SafeList {
        
        var list = self
        list.append(element)
        return list
    }
    
    public func appended<S: Sequence>(of sequence: S) -> SafeList where S.Iterator.Element == Element {
        
        var list = self
        list.append(of: sequence)
        return list
    }
    
    public func map<U>(_ f: (Element) throws -> U) rethrows -> SafeList<U> {
        return try SafeList<U>.of(all.map(f))
            ?? SafeList<U>.create(f(first))
    }
    
}
