//
//  UserSettings.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/11/23.
//

import Foundation

class UserSettings {

    private var showUnresolvedComments: String = "showUnresolvedComments"
    private var showMyComments: String = "showMyComments"
    private var userNameKey: String = "userNameKey"
    private var selectedRepo: String = "selectedRep1o"
    private var selectedRepoOwner: String = "selectedRepoOwn1er"
    private var githubToken: String = "githubToken"

//    private var selectedRepo: String = "selectedRepo"
//    private var selectedRepoOwner: String = "selectedRepoOwner"

    func getShowUnresolvedComments() -> Bool {
        return UserDefaults.standard.bool(forKey: showUnresolvedComments)
    }

    func setShowUnresolvedComments(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: showUnresolvedComments)
    }

    func getShowMyComments() -> Bool {
        return UserDefaults.standard.bool(forKey: showMyComments)
    }

    func setShowMyComments(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: showMyComments)
    }

    func setUserName(_ userName: String) {
        UserDefaults.standard.set(userName, forKey: userNameKey)
    }

    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: userNameKey)
    }

    func setSelectedRepo(_ repoName: String) {
        UserDefaults.standard.set(repoName, forKey: selectedRepo)
    }

    func getSelectedRepo() -> String? {
        return UserDefaults.standard.string(forKey: selectedRepo)
    }

    func setSelectedRepoOwner(_ repoOwnerName: String) {
        UserDefaults.standard.set(repoOwnerName, forKey: selectedRepoOwner)
    }

    func getSelectedRepoOwner() -> String? {
        return UserDefaults.standard.string(forKey: selectedRepoOwner)
    }

    func setGithubToken(_ token: String?) {
        UserDefaults.standard.set(token, forKey: githubToken)
    }

    func getGithubToken() -> String? {
        return UserDefaults.standard.string(forKey: githubToken)
    }

    func getRepoAndUserFirebaseKey() -> String {
        (getSelectedRepoOwner() ?? "") + "-" + (getSelectedRepo() ?? "")
    }

    func logout() {
        UserDefaults.standard.set(nil, forKey: githubToken)
        UserDefaults.standard.set(nil, forKey: selectedRepo)
        UserDefaults.standard.set(nil, forKey: selectedRepoOwner)
    }
}
