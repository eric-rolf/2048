//
//  BlockView.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import SwiftUI

struct BlockView: View {

    private struct ColorPair {
        let primary: Color
        let secondary: Color
    }

    fileprivate let number: Int?
    fileprivate let textId: String?

    init(block: BlockIdentified) {
        self.number = block.number
        self.textId = "\(block.id):\(block.number)"
    }

    private init() {
        self.number = nil
        self.textId = ""
    }
    static func blank() -> Self {
        return self.init()
    }

    private var numberText: String {
        return number.map(String.init) ?? ""
    }

    private var fontSize: CGFloat {
        switch numberText.count {
        case 0...2:
            return 32
        case 3:
            return 28
        case 4:
            return 24
        default:
            return 20
        }
    }

    private var colorPair: ColorPair {
        guard let number = number else {
            return ColorPair(primary: Color(named: "emptyCell"), secondary: .black)
        }

        return ColorPair(primary: Color(named: "\(number)p"), secondary: Color(named: "\(number)s"))
    }

    // MARK: Body

    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorPair.primary)
                .zIndex(1.0)
            Text(numberText)
                .font(Font.system(size: fontSize))
                .bold()
                .foregroundColor(colorPair.secondary)
                .id(textId!)
                .zIndex(1000)
                .transition(AnyTransition.opacity.combined(with: .scale))
        }
        .clipped()
        .cornerRadius(6)
    }

}

// MARK: - Previews

#if DEBUG
struct BlockView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ForEach( (1...13).map { Int(pow(2.0, Double($0))) }, id: \.hashValue) { i in
                BlockView(block: BlockIdentified(id: 0, number: i))
                    .previewLayout(.sizeThatFits)
            }
            BlockView.blank().previewLayout(.sizeThatFits)
        }
    }

}
#endif
