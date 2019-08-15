//
//  ProgressShape.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 8/14/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import SwiftUI

struct ProgressShape: Shape {
    let progress: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: .radians(1.5 * .pi),
            endAngle: .init(radians: 2 * Double.pi * progress + 1.5 * Double.pi),
            clockwise: false
        )
        return path
    }
}
