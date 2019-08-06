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
