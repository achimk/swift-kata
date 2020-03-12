//: Playground - noun: a place where people can play

import UIKit
import XCPlayground


func prepare(_ maxValue: Int) -> [Int] {

    let maxValue = max(maxValue, 0)

    if maxValue == 0 { return [] }
    
    var items: [Int] = []
    
    (1...maxValue).reversed().forEach { (value) in
        
        items.insert(value, at: 0)
        items.append(value)
        
    }
    
    return items
}

func modulo(_ by: Int) -> (Int) -> Bool {
    
    return { $0 % by == 0 }
}

func not<T>(_ predicate: @escaping (T) -> Bool) -> (T) -> Bool {
    return { !predicate($0) }
}

test("Rotate") {
    var input = prepare(3)
    
    print("before:", input)
    
    let output = input.rotate(shiftingToStart: 3)
    
    print("after: ", input)
    print("index: ", output)
}

test("Stable Partition I") {
    
    var input = prepare(3)
    let predicate = not(modulo(2))
    
    print("before:", input)
    
    let output = input.stablePartition(isSuffixElement: predicate)
    
    print("after: ", input)
    print("index: ", output)
}

test("Stable partition II") {
    
    var input = prepare(3)
    let predicate = modulo(2)
    
    print("before:", input)
    
    let output = input.stablePartition(count: 3, isSuffixElement: predicate)
    
    print("after: ", input)
    print("index: ", output)
}

test("Move to front") {
    
    var data = prepare(3)
    let predicate = modulo(2)
    
    let index = data.stablePartition(isSuffixElement: not(predicate))
    
    expectEqual(index, 2)
    expectEqual(data, [2, 2, 1, 3, 3, 1])
}

test("Move to back") {
    
    var data = prepare(3)
    let predicate = modulo(2)
    
    let index = data.stablePartition(isSuffixElement: predicate)
    
    expectEqual(index, 4)
    expectEqual(data, [1, 3, 3, 1, 2, 2])
}

test("Gather to target") {
    
    var data = prepare(3)
    let predicate = modulo(2)
    let target: Int = 3
    
    let l = data[0..<target].stablePartition(isSuffixElement: predicate)
    let h = data[target...].stablePartition(isSuffixElement: not(predicate))
    
    expectEqual(l, 2)
    expectEqual(h, 4)
    expectEqual(data, [1, 3, 2, 2, 3, 1])
}

runAllTests()


