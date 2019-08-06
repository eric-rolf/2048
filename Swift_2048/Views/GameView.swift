//
//  GameView.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import SwiftUI

extension Edge {
    static func from(_ from: Logic.Direction) -> Self {
        switch from {
        case .down:
            return .top
        case .up:
            return .bottom
        case .left:
            return .trailing
        case .right:
            return .leading
        }
    }
}

struct GameView : View {
    
    @State var ignoreGesture = false
    @ObservedObject var gameLogic: Logic = Logic()
    
    fileprivate struct LayoutTraits {
        let bannerOffset: CGSize
        let newOffset: CGSize
        let containerAlignment: Alignment
        let scoreOffset: CGSize
    }
    
    fileprivate func layoutTraits(`for` proxy: GeometryProxy) -> LayoutTraits {
        let landscape = proxy.size.width > proxy.size.height
        
        return LayoutTraits(
            bannerOffset: landscape
                ? .init(width: proxy.safeAreaInsets.leading + 32, height: 0)
                : .init(width: 0, height: proxy.safeAreaInsets.top + 32),
            newOffset: landscape
                ? .init(width: proxy.size.width - proxy.safeAreaInsets.trailing - 200, height: 0)
                : .init(width: 0, height: proxy.size.height - proxy.safeAreaInsets.bottom - 100),
            containerAlignment: landscape ? .leading : .top,
            scoreOffset: landscape
                ? .init(width: proxy.safeAreaInsets.leading + 32, height: 40)
                : .init(width: 0, height: proxy.safeAreaInsets.top + 72)
        )
    }
        
    var gesture: some Gesture {
        let threshold: CGFloat = 44
        let drag = DragGesture()
            .onChanged { v in
                guard !self.ignoreGesture else { return }
                guard abs(v.translation.width) > threshold ||
                    abs(v.translation.height) > threshold else { return }
                
                withTransaction(Transaction()) {
                    self.ignoreGesture = true
                    if v.translation.width > threshold {
                        // Move right
                        self.gameLogic.move(.right)
                    } else if v.translation.width < -threshold {
                        // Move left
                        self.gameLogic.move(.left)
                    } else if v.translation.height > threshold {
                        // Move down
                        self.gameLogic.move(.down)
                    } else if v.translation.height < -threshold {
                        // Move up
                        self.gameLogic.move(.up)
                    }
                }
        }
        .onEnded { _ in self.ignoreGesture = false }
        return drag
    }
    
    var content: some View {
        GeometryReader { proxy in
            bind(self.layoutTraits(for: proxy)) { layoutTraits in
                ZStack(alignment: layoutTraits.containerAlignment) {
                    VStack{
                        Text("2048")
                            .font(Font.system(size: 48).weight(.black))
                            .foregroundColor(Color.pFont)
                        VStack {
                            Text("Score")
                                .font(Font.system(size: 16).weight(.medium))
                                .foregroundColor(Color.pBackground)
                            
                            Text("\(self.gameLogic.score)")
                                .font(Font.system(size: 26).weight(.black))
                                .foregroundColor(Color.pBackground)
                                .frame(width: 150, height: nil, alignment: .center)
                        }
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                        .foregroundColor(Color.pBackground)
                        .background(
                            Rectangle().fill(Color.playfield)
                        )
                            .cornerRadius(6)
                    }
                    .offset(layoutTraits.bannerOffset)
                    
                    ZStack(alignment: .center) {
                        GridView(matrix: self.gameLogic.blockMatrix,
                                 blockEnterEdge: .from(self.gameLogic.lastGestureDirection))
                        
                        if self.gameLogic.hasWon || self.gameLogic.hasLost {
                            ZStack(alignment: .center) {
                                VStack {
                                    Text(self.gameLogic.hasWon ? "You Win!!" : self.gameLogic.hasLost ? "Game Over" : "")
                                        .font(Font.system(size: 48).weight(.black))
                                        .foregroundColor(Color.pFont)
                                    
                                    if self.gameLogic.hasWon && self.gameLogic.continueGame == false {
                                        Button("Keep going", action: {
                                            self.gameLogic.continueGame = true
                                        })
                                            .padding(6)
                                            .font(Font.system(size: 22).weight(.black))
                                            .foregroundColor(Color.pBackground)
                                            .background(
                                                Rectangle().fill(Color.pFont)
                                        )
                                            .cornerRadius(6)
                                    }
                                }
                            }.background(
                                Rectangle()
                                    .fill(Color.playfield)
                                    .frame(width: 320, height: 320, alignment: .center)
                                    .clipped()
                                    .cornerRadius(6)
                                    .opacity(0.9)
                            )
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    
                    Button("New Game", action: { self.gameLogic.newGame() })
                        .padding(6)
                        .font(Font.system(size: 32).weight(.black))
                        .foregroundColor(Color.pBackground)
                        .background(
                            Rectangle().fill(Color.p512)
                    )
                        .cornerRadius(6)
                        .offset(layoutTraits.newOffset)
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(
                    Rectangle().fill(Color.pBackground)
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var body: AnyView {
        return content.gesture(gesture, including: .all)>*
    }
    
}

#if DEBUG
struct GameView_Previews : PreviewProvider {
    
    static var previews: some View {
        GameView().environmentObject(Logic())
    }
    
}
#endif
