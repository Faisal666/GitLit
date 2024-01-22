//
//  RoundedButtonModifier.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 1/16/24.
//

import SwiftUI

struct RoundedButtonModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white.opacity(0.7))
            .buttonStyle(.borderless)
            .padding(EdgeInsets(top: 4, leading: 14, bottom: 5, trailing: 14))
            .background(backgroundColor)
            .clipShape(Capsule())
            .shadow(radius: 10)
            .padding(.bottom, 16)
    }
}

extension View {
    func roundedButtonStyle(backgroundColor: Color) -> some View {
        self.modifier(RoundedButtonModifier(backgroundColor: backgroundColor))
    }
}
