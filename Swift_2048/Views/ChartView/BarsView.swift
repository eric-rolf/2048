//
//  BarsView.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 8/14/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import SwiftUI

struct BarsView: View {
    let bars: [Bar]
    let max: Double

    init(bars: [Bar]) {
        self.bars = bars
        self.max = bars.map { $0.value }.max() ?? 0
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(self.bars) { bar in
                    ZStack(alignment: .bottom) {
                    Capsule()
                        .fill(bar.legend.color)
                        .frame(height: CGFloat(bar.value) / CGFloat(self.max) * geometry.size.height)
                        .frame(width: geometry.size.width / 8)
                        .padding(6)
                        .accessibility(label: Text(bar.label))
                        .accessibility(value: Text(bar.legend.label))
                        Text("\(Int(bar.value))")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 10))
                            .offset(CGSize(width: 0, height: -10))
                    }
                }
            }
        }
    }
}
