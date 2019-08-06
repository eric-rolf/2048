//
//  UIKeyCommandExtensions.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 8/5/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import Foundation
import UIKit

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
