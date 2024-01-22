//
//  InfoPopover.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/11/23.
//

import SwiftUI

struct InfoPopover: View {
    var body: some View {
        VStack {
            Text("Check out https://www.example.com and http://www.another-example.com")
            
            Spacer()
        }
        .frame(width: 300, height: 300)
        .padding()
    }
}

struct InfoPopover_Previews: PreviewProvider {
    static var previews: some View {
        InfoPopover()
    }
}
