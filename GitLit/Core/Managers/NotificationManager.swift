//
//  NotificationManager.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 12/21/23.
//

import Foundation
import UserNotifications

class NotificationManager {

    static var shared: NotificationManager = NotificationManager()
    var numberOfUpdates: Int = 0
    var numberOfNewPrs: Int = 0

    func requestNoificationAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func collectPRGeneralUpdate() {
        numberOfUpdates+=1
    }

    func collectNewPRAddedUpdate() {
        numberOfNewPrs+=1
    }

    func fireNotification() {
        guard numberOfNewPrs != 0 || numberOfUpdates != 0  else { return }
        let content = UNMutableNotificationContent()
        content.title = "GitLit"
        var updateText: String = ""

        if numberOfNewPrs != 0 {
            updateText += "You have \(numberOfNewPrs) New PRs"
        }

        if numberOfUpdates != 0 {
            updateText += "\n"
            updateText += "You have \(numberOfUpdates) PRs Updated"
        }

        print(updateText)

        content.subtitle =  "New Lit Updates!"
        content.body = updateText
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
        reset()
    }

    private func reset() {
        numberOfUpdates = 0
        numberOfNewPrs = 0
    }
}
