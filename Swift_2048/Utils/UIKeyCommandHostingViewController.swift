//
//  UIKeyCommandHostingController.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 8/5/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import UIKit
import SwiftUI

class UIKeyCommandHostingController: UIHostingController<GameView> {
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyCommandHandler(_:))),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(keyCommandHandler(_:))),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyCommandHandler(_:))),
            UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyCommandHandler(_:))),
            
            UIKeyCommand(input: "a", modifierFlags: [], action: #selector(keyCommandHandler(_:))),
            UIKeyCommand(input: "s", modifierFlags: [], action: #selector(keyCommandHandler(_:))),
            UIKeyCommand(input: "d", modifierFlags: [], action: #selector(keyCommandHandler(_:))),
            UIKeyCommand(input: "w", modifierFlags: [], action: #selector(keyCommandHandler(_:)))
        ]
    }
    
    @objc func keyCommandHandler(_ sender: UIKeyCommand) {
        let view = rootView as GameView
        view.gameLogic.move(sender.moveDirection)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

extension UIKeyCommand {
    
    var moveDirection: Logic.Direction {
        switch self.input  {
        case UIKeyCommand.inputUpArrow, "w":
            return .up
        case UIKeyCommand.inputDownArrow, "s":
            return .down
        case UIKeyCommand.inputLeftArrow, "a":
            return .left
        default:
            return .right
        }
    }
    
}
