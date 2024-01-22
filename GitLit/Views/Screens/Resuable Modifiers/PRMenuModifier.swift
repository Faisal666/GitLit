//
//  PRMenuModifier.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 12/16/23.
//

import SwiftUI

struct PRMenuModifier: ViewModifier {
    var addAction: () -> Void

    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button("Add for Release", action: addAction)
            }
    }
}

extension View {
    func addForReleaseContextMenu(addAction: @escaping () -> Void) -> some View {
        self.modifier(PRMenuModifier(addAction: addAction))
    }
}
