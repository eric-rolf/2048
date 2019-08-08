//
//  MatrixBlock.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import Foundation

protocol Block {
    associatedtype Value
    var number: Value { get set }
}

struct IndexedBlock<T> where T: Block {
    typealias Index = MatrixBlock<T>.Index
    
    let index: Self.Index
    let item: T
}

struct MatrixBlock<T> : CustomDebugStringConvertible where T: Block {
    typealias Index = (Int, Int)
    fileprivate var matrix: [[T?]]
    
    init() {
        matrix = [[T?]]()
        for _ in 0..<4 {
            var row = [T?]()
            for _ in 0..<4 {
                row.append(nil)
            }
            matrix.append(row)
        }
    }
    
    var debugDescription: String {
        let v = matrix.compactMap { row -> String in
            row.compactMap {
                return $0 == nil ? "[ ]" : "[\(String(describing: $0!.number))]"
            }.joined(separator: " ")
        }.joined(separator: "\n")
        return v
    }
    
    var flatten: [IndexedBlock<T>] {
        return self.matrix.enumerated().flatMap { (y: Int, element: [T?]) in
            element.enumerated().compactMap { (x: Int, element: T?) in
                guard let element = element else { return nil }
                return IndexedBlock(index: (x, y), item: element)
            }
        }
    }
    
    subscript(index: Self.Index) -> T? {
        guard isIndexValid(index) else { return nil }
        guard let item = matrix[index.1][index.0] else { return nil }
        return item
    }
    
    /// Move the block to specific location and leave the original location blank.
    /// - Parameter from: Source location
    /// - Parameter to: Destination location
    mutating func move(from: Self.Index, to: Self.Index) {
        guard isIndexValid(from) && isIndexValid(to) else { return }
        
        guard let source = self[from] else { return }
        
        matrix[to.1][to.0] = source
        matrix[from.1][from.0] = nil
    }
    
    /// Move the block to specific location, change its value and leave the original location blank.
    /// - Parameter from: Source location
    /// - Parameter to: Destination location
    /// - Parameter newValue: The new value
    mutating func move(from: Self.Index, to: Self.Index, with newValue: T.Value) {
        guard isIndexValid(from) && isIndexValid(to) else { return }
        guard var source = self[from] else { return }
        
        source.number = newValue
        
        matrix[to.1][to.0] = source
        matrix[from.1][from.0] = nil
    }
    
    /// Place a block to specific location.
    /// - Parameter block: The block to place
    /// - Parameter to: Destination location
    mutating func place(_ block: T?, to: Self.Index) {
        matrix[to.1][to.0] = block
    }
    
    fileprivate func isIndexValid(_ index: Self.Index) -> Bool {
        return index.0 >= 0 && index.0 < 4 || index.1 >= 0 && index.1 < 4
    }
    
}
