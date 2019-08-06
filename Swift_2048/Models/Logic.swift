//
//  Logic.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class Logic: ObservableObject {

    let objectWillChange = PassthroughSubject<Logic, Never>()
        
    typealias Condition = (canMerge: Bool, isFull: Bool)
    typealias MatrixBlockType = MatrixBlock<BlockIdentified>
        
    enum Direction: String {
        case left
        case right
        case up
        case down
    }
        
    fileprivate var _blockMatrix: MatrixBlockType!
    var blockMatrix: MatrixBlockType {
        _blockMatrix
    }
    
    fileprivate(set) var lastGestureDirection: Direction = .up
    
    fileprivate var _globalID = 0
    fileprivate var newGlobalID: Int {
        _globalID += 1
        return _globalID
    }
    
    var continueGame: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var hasWon: Bool {
        return _blockMatrix.flatten.filter({ $0.item.number == 2048}).count == 1 && continueGame == false
    }
    
    fileprivate(set) var hasLost: Bool = false
    
    fileprivate var _score: Int = 0
    var score: Int {
        return _score
    }
        
    init() {
        newGame()
    }
    
    func newGame() {
        _blockMatrix = MatrixBlockType()
        
//        _blockMatrix.place(BlockIdentified(id: newGlobalID, number: 1024), to: (3,3))
//        _blockMatrix.place(BlockIdentified(id: newGlobalID, number: 1024), to: (2,3))
        
        _score = 0
        hasLost = false
        continueGame = false
        generateNewBlocks()
        objectWillChange.send(self)
    }
        
    func move(_ direction: Direction) {
        defer {
            objectWillChange.send(self)
        }
        
        lastGestureDirection = direction
        
        var moved = false
        var allConditions = [Condition]()
        
        let axis = direction == .left || direction == .right
        for row in 0..<4 {
            var rowSnapshot = [BlockIdentified?]()
            var compactRow = [BlockIdentified]()
            for col in 0..<4 {
                // Transpose if necessary.
                if let block = _blockMatrix[axis ? (col, row) : (row, col)] {
                    rowSnapshot.append(block)
                    compactRow.append(block)
                } else {
                    rowSnapshot.append(nil)
                }
            }
            
            let reverse = direction == .down || direction == .right
            let conditions = checkConditions(blocks: compactRow, reverse: reverse)
            allConditions.append(conditions)
            if  conditions.canMerge {
                merge(blocks: &compactRow, reverse: reverse)
            }

            var newRow = [BlockIdentified?]()
            compactRow.forEach { newRow.append($0) }
            if compactRow.count < 4 {
                for _ in 0..<(4 - compactRow.count) {
                    if direction == .left || direction == .up {
                        newRow.append(nil)
                    } else {
                        newRow.insert(nil, at: 0)
                    }
                }
            }
            
            newRow.enumerated().forEach {
                if rowSnapshot[$0]?.number != $1?.number {
                    moved = true
                }
                _blockMatrix.place($1, to: axis ? ($0, row) : (row, $0))
            }
        }

        if allConditions.filter({ $0.canMerge == false && $0.isFull == true }).count == 4 {
            self.hasLost = true
            return
        }
        
        if moved {
            generateNewBlocks()
        }
    }

    fileprivate func checkConditions(blocks: [BlockIdentified], reverse: Bool) -> Condition {
        var canMerge = false
        var blocks = blocks
        if reverse {
            blocks = blocks.reversed()
        }
        
        blocks = blocks
            .map { (false, $0) }
            .reduce([(Bool, BlockIdentified)]()) { acc, item in
                if acc.last?.0 == false && acc.last?.1.number == item.1.number {
                    canMerge = true
                    var accPrefix = Array(acc.dropLast())
                    var mergedBlock = item.1
                    mergedBlock.number *= 2
                    accPrefix.append((true, mergedBlock))
                    return accPrefix
                } else {
                    var accTmp = acc
                    accTmp.append((false, item.1))
                    return accTmp
                }
        }
        .map { $0.1 }
        return (canMerge, blocks.count == 4)
    }
    
    fileprivate func merge(blocks: inout [BlockIdentified], reverse: Bool) {
        if reverse {
            blocks = blocks.reversed()
        }
        
        blocks = blocks
            .map { (false, $0) }
            .reduce([(Bool, BlockIdentified)]()) { acc, item in
                if acc.last?.0 == false && acc.last?.1.number == item.1.number {
                    var accPrefix = Array(acc.dropLast())
                    var mergedBlock = item.1
                    mergedBlock.number *= 2
                    _score += mergedBlock.number
                    accPrefix.append((true, mergedBlock))
                    return accPrefix
                } else {
                    var accTmp = acc
                    accTmp.append((false, item.1))
                    return accTmp
                }
        }
        .map { $0.1 }
        
        if reverse {
            blocks = blocks.reversed()
        }
    }
    
    @discardableResult fileprivate func generateNewBlocks() -> Bool {
        defer {
            objectWillChange.send(self)
        }
        var blankLocations = [MatrixBlockType.Index]()
        for rowIndex in 0..<4 {
            for colIndex in 0..<4 {
                let index = (colIndex, rowIndex)
                if _blockMatrix[index] == nil {
                    blankLocations.append(index)
                }
            }
        }
        
        guard blankLocations.count >= 1 else {
            return false
        }
        
        // Place the first block.
        var placeLocIndex = Int.random(in: 0..<blankLocations.count)
        placeDefaultBlock(blankLocations: &blankLocations, at: placeLocIndex)
        
        // Place the second block if needed.
        if (_blockMatrix.flatten.count > 1) {
            return false
        }
        
        guard let lastLoc = blankLocations.last else {
            return false
        }
        
        blankLocations[placeLocIndex] = lastLoc
        placeLocIndex = Int.random(in: 0..<(blankLocations.count - 1))
        placeDefaultBlock(blankLocations: &blankLocations, at: placeLocIndex)
        
        return true
    }
    
    fileprivate func placeDefaultBlock(blankLocations: inout [MatrixBlockType.Index], at index: Int) {
        _blockMatrix.place(BlockIdentified(id: newGlobalID, number: 2), to: blankLocations[index])
    }
    
}
