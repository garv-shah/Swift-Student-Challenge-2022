//
//  File.swift
//  Swift Student Challenge 2022
//
//  Created by Garv Shah on 19/4/2022.
//

import Foundation
import SwiftUI

enum ButtonAlign {
    case left, right, centre
}

struct FloatingActionButton<ImageView: View>: ViewModifier {
    let color: Color
    let image: ImageView
    let action: () -> Void
    let customY: CGFloat?
    let customX: CGFloat?
    let opacity: CGFloat?
    let align: ButtonAlign
    
    private let size: CGFloat = 60
    private let margin: CGFloat = 15
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                Color.clear
                content
                button(geo)
            }
        }
    }
    
    func getAlign() -> CGFloat {
        switch align {
        case .right:
            return 1
        case .left:
            return -1
        case .centre:
            return 0
        }
    }
    
    @ViewBuilder private func button(_ geo: GeometryProxy) -> some View {
        image
            .imageScale(.large)
            .frame(width: size, height: size)
            .background(Circle().fill(color))
            .onTapGesture(perform: action)
            .opacity(opacity ?? 1)
            .offset(x: getAlign() * ((geo.size.width - size) / 2 - margin*2) + (customX ?? 0),
                    y: ((geo.size.height - size) / 2 - margin) - (customY ?? 0)
            )
    }
}

extension View {
    func floatingActionButton<ImageView: View>(
        color: Color,
        image: ImageView,
        align: ButtonAlign,
        customY: CGFloat? = nil,
        customX: CGFloat? = nil,
        opacity: CGFloat? = nil,
        action: @escaping () -> Void) -> some View {
            self.modifier(FloatingActionButton(color: color,
                                               image: image,
                                               action: action,
                                               customY: customY,
                                               customX: customX,
                                               opacity: opacity,
                                               align: align))
        }
}

extension Array {
    subscript( circular index: Int ) -> Element? {
        guard !isEmpty else { return nil }
        let modIndex = index % count
        return self[ modIndex < 0 ? modIndex + count : modIndex ]
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
