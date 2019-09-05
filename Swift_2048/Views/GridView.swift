//
//  GridView.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import SwiftUI

/// ViewModifier that scales from an anchor point.
struct AnchoredScale: ViewModifier {

    let scaleFactor: CGFloat
    let anchor: UnitPoint

    func body(content: Self.Content) -> some View {
        content.scaleEffect(scaleFactor, anchor: anchor)
    }

}

/// Allows concatted ViewModifiers.
struct MergedViewModifier<M1, M2>: ViewModifier where M1: ViewModifier, M2: ViewModifier {

    let m1: M1
    let m2: M2

    init(first: M1, second: M2) {
        m1 = first
        m2 = second
    }

    func body(content: Self.Content) -> some View {
        content.modifier(m1).modifier(m2)
    }

}

extension AnyTransition {

    static func blockGenerated(from: Edge, position: CGPoint, `in`: CGRect) -> AnyTransition {
        let anchor = UnitPoint(x: position.x / `in`.width, y: position.y / `in`.height)

        return .asymmetric(
            insertion: AnyTransition.opacity.combined(with: .move(edge: from)),
            removal: AnyTransition.opacity.combined(with: .modifier(
                active: MergedViewModifier(
                    first: AnchoredScale(scaleFactor: 0.8, anchor: anchor),
                    second: AnchoredScale(scaleFactor: 0.8, anchor: anchor)
                ),
                identity: MergedViewModifier(
                    first: AnchoredScale(scaleFactor: 1, anchor: anchor),
                    second: AnchoredScale(scaleFactor: 1.0, anchor: anchor)
                )
            ))
        )
    }

}

struct GridView: View {

    typealias SupportingMatrix = MatrixBlock<BlockIdentified>

    let matrix: Self.SupportingMatrix
    let blockEnterEdge: Edge
    let proxy: GeometryProxy
    let boardSize: CGFloat = 0

    func createBlock(_ block: BlockIdentified?, at index: IndexedBlock<BlockIdentified>.Index) -> some View {
        let blockView: BlockView
        if let block = block {
            blockView = BlockView(block: block)
        } else {
            blockView = BlockView.blank()
        }

        let blockSize: CGFloat = proxy.gridMetrics().blockSize
        let boardSize: CGFloat = proxy.gridMetrics().boardSize
        let spacing: CGFloat = proxy.gridMetrics().spacing

        let position = CGPoint(
            x: CGFloat(index.0) * (blockSize + spacing) + blockSize / 2 + spacing,
            y: CGFloat(index.1) * (blockSize + spacing) + blockSize / 2 + spacing
        )

        return blockView
            .frame(width: blockSize, height: blockSize, alignment: .center)
            .position(x: position.x, y: position.y)
            .transition(.blockGenerated(
                from: self.blockEnterEdge,
                position: CGPoint(x: position.x, y: position.y),
                in: CGRect(x: 0, y: 0, width: boardSize, height: boardSize)
            ))
    }

    var body: some View {
        ZStack(alignment: .center) {
            // Background grid blocks:
            ForEach(0..<4) { x in
                ForEach(0..<4) { y in
                    self.createBlock(nil, at: (x, y))
                }
            }
            .zIndex(1.0)

            // Number blocks:
            ForEach(self.matrix.flatten, id: \.item.id) {
                self.createBlock($0.item, at: $0.index)
            }
            .zIndex(1000)
            .animation(.spring())
        }
        .frame(width: proxy.gridMetrics().boardSize, height: proxy.gridMetrics().boardSize, alignment: .center)
        .background(
            Rectangle()
                .fill(Color(named: "playfield"))
        )
        .clipped()
        .cornerRadius(6)
        .drawingGroup(opaque: false, colorMode: .linear)
    }

}

#if DEBUG
struct BlockGridView_Previews: PreviewProvider {

    static var matrix: GridView.SupportingMatrix {
        var _matrix = GridView.SupportingMatrix()
        _matrix.place(BlockIdentified(id: 1, number: 2), to: (2, 0))
        _matrix.place(BlockIdentified(id: 2, number: 2), to: (3, 0))
        _matrix.place(BlockIdentified(id: 3, number: 8), to: (1, 1))
        _matrix.place(BlockIdentified(id: 4, number: 4), to: (2, 1))
        _matrix.place(BlockIdentified(id: 5, number: 512), to: (3, 3))
        _matrix.place(BlockIdentified(id: 6, number: 1024), to: (2, 3))
        _matrix.place(BlockIdentified(id: 7, number: 16), to: (0, 3))
        _matrix.place(BlockIdentified(id: 8, number: 8), to: (1, 3))
        return _matrix
    }

    static var previews: some View {
        GeometryReader { proxy in
            GridView(matrix: matrix, blockEnterEdge: .top, proxy: proxy)
                .previewLayout(.sizeThatFits)
        }
    }

}
#endif
