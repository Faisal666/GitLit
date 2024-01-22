//
//  SearchBar.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 1/15/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .padding(.trailing, 10)
                        }
                    }
                )
                .focused($isFocused)

            // Optionally, add more UI elements as needed
        }
        .onTapGesture {
            self.isFocused = true
        }
        .gesture(
            DragGesture().onChanged { _ in
                self.isFocused = false
            }
        )
    }
}

#Preview {
    @State var text: String = ""
    return SearchBar(text: $text)
}
