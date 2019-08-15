//
//  BarChartView.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 8/14/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import SwiftUI

struct BarChartView: View {
    let bars: [Bar]

    var body: some View {
        Group {
            if bars.isEmpty {
                Text("There is no data to display chart...")
            } else {
                VStack {
                    BarsView(bars: bars).padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 60))
                    Text("Movement Directions: \(Int(bars.map({ $0.value }).reduce(0, +)))").foregroundColor(Color(named: "primaryFont"))
                    
                    LegendView(bars: bars)
                        .padding()
                        .accessibility(hidden: true)
                }
            }
        }
    }
}
