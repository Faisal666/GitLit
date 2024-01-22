//
//  GitLitApp.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import SwiftUI

@main
struct GitLitApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainNavigation()
                .frame(minWidth: 1000, minHeight: 600)
        }
    }
}
