//
//  SwiftUIExtensions.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//


import SwiftUI

extension View {
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
}

postfix operator >*
postfix func >*<V>(lhs: V) -> AnyView where V: View {
    return lhs.eraseToAnyView()
}

//Logic.Direction
extension DragGesture {

    static func direction(minimumDistance: CGFloat = 44, translation: CGSize) -> Logic.Direction {
        
        guard abs(translation.width) > minimumDistance ||
            abs(translation.height) > minimumDistance else { return .none }
        
        if translation.width > minimumDistance {
            return .right
        } else if translation.width < -minimumDistance {
            return .left
        } else if translation.height > minimumDistance {
            return .down
        } else if translation.height < -minimumDistance {
            return .up
        }
        return .up
    }

}

extension GeometryProxy {
    
    typealias GridMetrics = (boardSize: CGFloat, blockSize: CGFloat, spacing: CGFloat)
    
    func gridMetrics() -> GridMetrics {
        let landscape = self.size.width > self.size.height
        let spacing: CGFloat = 12
        let inset = landscape ? min(self.safeAreaInsets.leading, self.safeAreaInsets.trailing) : min(self.safeAreaInsets.top, self.safeAreaInsets.bottom)
        let maxSize = min( min(self.size.width, self.size.height), 350)
        
        let boardSize: CGFloat = maxSize - (2.0*inset)
        let blockSize: CGFloat = (boardSize - (5 * spacing)) / 4
        return (boardSize, blockSize, spacing)
    }
    
}
