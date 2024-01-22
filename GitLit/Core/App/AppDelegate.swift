//
//  AppDelegate.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 12/11/23.
//

import AppKit
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        NotificationManager.shared.requestNoificationAuth()
        FirebaseApp.configure()
    }
}
