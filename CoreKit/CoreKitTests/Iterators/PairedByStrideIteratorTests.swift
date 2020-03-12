//
//  Created by Joachim Kret on 12/03/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import CoreKit

final class PairedByStrideIteratorTests: XCTestCase {
    
    struct Pair<Left: Equatable, Right: Equatable>: Equatable {
        let left: Left
        let right: Right
    }
    
    func testIterateEmptyCollection() {

        // Given
        let input: [Int] = []
        let output: [(Int, Int)] = []
        
        let it = AnySequence { PairedByStrideIterator(input.makeIterator()) }
        
        // When
        var result: [(Int, Int)] = []
        it.forEach { result.append($0) }
        
        // Then
        expect(result.map(Pair.init)) == output.map(Pair.init)
    }
    
    func testIterateCollectionWithOneElement() {
        
        // Given
        let input: [Int] = [1]
        let output: [(Int, Int)] = []
        
        let it = AnySequence { PairedByStrideIterator(input.makeIterator()) }
        
        // When
        var result: [(Int, Int)] = []
        it.forEach { result.append($0) }
        
        // Then
        expect(result.map(Pair.init)) == output.map(Pair.init)
    }
    
    func testIterateCollectionWithTwoElements() {
        
        // Given
        let input: [Int] = [1, 2]
        let output: [(Int, Int)] = [
            (1, 2)
        ]
        
        let it = AnySequence { PairedByStrideIterator(input.makeIterator()) }
        
        // When
        var result: [(Int, Int)] = []
        it.forEach { result.append($0) }
        
        // Then
        expect(result.map(Pair.init)) == output.map(Pair.init)
    }
    
    func testIterateCollectionWithThreeElements() {
        
        // Given
        let input: [Int] = [1, 2, 3]
        let output: [(Int, Int)] = [
            (1, 2),
            (2, 3)
        ]
        
        let it = AnySequence { PairedByStrideIterator(input.makeIterator()) }
        
        // When
        var result: [(Int, Int)] = []
        it.forEach { result.append($0) }
        
        // Then
        expect(result.map(Pair.init)) == output.map(Pair.init)
    }
    
    func testIterateCollectionWithFourElements() {
        
        // Given
        let input: [Int] = [1, 2, 3, 4]
        let output: [(Int, Int)] = [
            (1, 2),
            (2, 3),
            (3, 4)
        ]
        
        let it = AnySequence { PairedByStrideIterator(input.makeIterator()) }
        
        // When
        var result: [(Int, Int)] = []
        it.forEach { result.append($0) }
        
        // Then
        expect(result.map(Pair.init)) == output.map(Pair.init)
    }
    
    func testIterateCollectionWithFiveElements() {
        
        // Given
        let input: [Int] = [1, 2, 3, 4, 5]
        let output: [(Int, Int)] = [
            (1, 2),
            (2, 3),
            (3, 4),
            (4, 5)
        ]
        
        let it = AnySequence { PairedByStrideIterator(input.makeIterator()) }
        
        // When
        var result: [(Int, Int)] = []
        it.forEach { result.append($0) }
        
        // Then
        expect(result.map(Pair.init)) == output.map(Pair.init)
    }
}
