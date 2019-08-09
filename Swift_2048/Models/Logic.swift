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
    typealias MatrixBlockType = MatrixBlock<BlockIdentified>
    
    enum Direction {
        case left
        case right
        case up
        case down
        case none
    }
    
    private(set) var blockMatrix: MatrixBlockType!
    private(set) var lastGestureDirection: Direction = .up
    
    private var _globalID = 0
    private var newGlobalID: Int {
        _globalID += 1
        return _globalID
    }
    
    var continueGame: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var hasWon: Bool {
        return blockMatrix.flatten.filter({ $0.item.number == 2048}).count == 1 && continueGame == false
    }
    
    private(set) var hasLost: Bool = false
    private(set) var score: Int = 0
    
    init() {
        newGame()
    }
    
    /// Start a new game
    func newGame() {
        blockMatrix = MatrixBlockType()
        score = 0
        hasLost = false
        continueGame = false
        generateNewBlocks()
        objectWillChange.send(self)
    }
    
    /// Used to move the peices on the playboard in a specific direction
    /// - Parameter direction: Logic.Direction enum that indicates a movement direction (.up, .down, .left, .right)
    func move(_ direction: Direction) {
        defer {
            objectWillChange.send(self)
        }
        
        lastGestureDirection = direction
        
        var moved = false
        
        let axis = direction == .left || direction == .right
        for row in 0..<4 {
            var rowSnapshot = [BlockIdentified?]()
            var compactRow = [BlockIdentified]()
            for col in 0..<4 {
                // Transpose if necessary.
                if let block = blockMatrix[axis ? (col, row) : (row, col)] {
                    rowSnapshot.append(block)
                    compactRow.append(block)
                } else {
                    rowSnapshot.append(nil)
                }
            }
            
            let reverse = direction == .down || direction == .right
            merge(blocks: &compactRow, reverse: reverse)
            
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
                blockMatrix.place($1, to: axis ? ($0, row) : (row, $0))
            }
        }
        
        generateNewBlocks(moved: moved)
        self.hasLost = check(gameOver: blockMatrix)
    }
    
    private func merge(blocks: inout [BlockIdentified], reverse: Bool) {
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
                    score += mergedBlock.number
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
    
    private func check(gameOver blockMatrix: MatrixBlockType) -> Bool {
        for row in 0..<4 {
            for col in 0..<4 {
                guard let block = blockMatrix[(row, col)] else {
                    return false
                }
                if row != 3 {
                    guard let rowComp = blockMatrix[(row + 1, col)] else {
                        return false
                    }
                    if (block.number == rowComp.number) {
                        return false
                    }
                }
                if col != 3 {
                    guard let colComp = blockMatrix[(row, col + 1)] else {
                        return false
                    }
                    if (block.number == colComp.number) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func generateNewBlocks(moved: Bool = true) {
        if !moved { return }
        defer {
            objectWillChange.send(self)
        }
        var blankLocations = [MatrixBlockType.Index]()
        for rowIndex in 0..<4 {
            for colIndex in 0..<4 {
                let index = (colIndex, rowIndex)
                if blockMatrix[index] == nil {
                    blankLocations.append(index)
                }
            }
        }
        
        guard blankLocations.count >= 1 else { return }
        
        // Place the first block.
        var placeLocIndex = Int.random(in: 0..<blankLocations.count)
        placeDefaultBlock(blankLocations: &blankLocations, at: placeLocIndex)
        
        // Place the second block if needed.
        if (blockMatrix.flatten.count > 1) { return }
        
        guard let lastLoc = blankLocations.last else { return }
        
        blankLocations[placeLocIndex] = lastLoc
        placeLocIndex = Int.random(in: 0..<(blankLocations.count - 1))
        placeDefaultBlock(blankLocations: &blankLocations, at: placeLocIndex)
    }
    
    private func placeDefaultBlock(blankLocations: inout [MatrixBlockType.Index], at index: Int) {
        blockMatrix.place(BlockIdentified(id: newGlobalID, number: Bool.random() ? 2 : 4), to: blankLocations[index])
    }
    
}
