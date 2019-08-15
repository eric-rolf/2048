//
//  LegendView.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 8/14/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import SwiftUI

struct LegendView: View {
    private let legends: [Legend]

    init(bars: [Bar]) {
        legends = bars.map{$0.legend}
    }

    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            ForEach(legends, id: \.self) { legend in
                VStack(alignment: .center) {
                    Circle()
                        .fill(legend.color)
                        .frame(width: 16, height: 16)

                    Text(legend.label)
                        .foregroundColor(Color(named: "2s"))
                        .font(.subheadline).fontWeight(.medium)
                        .lineLimit(nil)
                }
            }
        }
    }
}
