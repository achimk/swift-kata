import Foundation

/**
 Paired by stide interator
 
 Usage:
 let it = AnySequence { StridePairIterator(input.makeIterator()) }
 it.forEach { print($0) }
 
 Inputs:
 # [1, 2, 3]
 
 Outputs:
 # (1, 2)
 # (2, 3)
 
 */
public struct PairedByStrideIterator<C: IteratorProtocol>: IteratorProtocol {
    private var baseIterator: C
    private var cache: C.Element?
    
    public init(_ iterator: C) {
        baseIterator = iterator
    }
    
    public mutating func next() -> (C.Element, C.Element)? {
        if let left = cache ?? baseIterator.next() {
            if let right = baseIterator.next() {
                cache = right
                return (left, right)
            }
        }
        
        return nil
    }
}
