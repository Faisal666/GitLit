//
//  AlertsPresenter.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 12/16/23.
//

import SwiftUI
import AppKit

class AlertsPresenter {

    func presentAddNewReleaseAlert(completion: @escaping (String) -> Void) {
        let alert = NSAlert()
        alert.messageText = "Add New Release"
        alert.informativeText = "Enter the name of the new release:"
        alert.addButton(withTitle: "Add")
        alert.addButton(withTitle: "Cancel")

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textField.placeholderString = "Release Name"
        alert.accessoryView = textField

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            completion(textField.stringValue)
        }
    }

    func presentVersionNotSelectedError() {
        let alert = NSAlert()
        alert.messageText = "Please select a version"
        alert.informativeText = "Go to \"To Release\" and select version to add PR to it"
        alert.addButton(withTitle: "Ok")

        let response = alert.runModal()
    }
}
