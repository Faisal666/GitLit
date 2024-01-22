//
//  VersionViewModel.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 12/11/23.
//

import Firebase
import Combine

// Define a new struct for holding both ID and URL
struct IDAndURL {
    let id: String
    let title: String
    let url: String
}

class VersionViewModel: ObservableObject {

    static var selectedVersionId: String?
    @Published var versions: [Version] = []
    @Published var selectedVersion: Version?
    @Published var appName: String {
        didSet {
            fetchAllVersions()
        }
    }

    private var dbRef: DatabaseReference

    init(appName: String) {
        self.appName = appName
        self.dbRef = Database.database().reference()
        fetchAllVersions()

    }

    func fetchAllVersions() {
        versions = [] // Clear existing data

        dbRef.child(appName).child("versions").observe(.value) { snapshot in
            var newVersions: [Version] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: AnyObject],
                   let isMarkedForRelease = value["isMarkedForRelease"] as? Bool,
                   let isReleased = value["isReleased"] as? Bool {
                    let idURLPairs = (value["ids"] as? [[String: String]]) ?? [[:]]
                    // Convert dictionaries to IDAndURL objects
                    let ids = idURLPairs.map { IDAndURL(id: $0["id"] ?? "", title: $0["title"] ?? "", url: $0["url"] ?? "") }
                    let version = Version(id: snapshot.key.decodeFirebaseKey(), prs: ids, isMarkedForRelease: isMarkedForRelease, isReleased: isReleased)
                    newVersions.append(version)
                }
            }
            self.versions = newVersions.sorted(by: { $0.id > $1.id })
        }
    }

    func createReleaseVersion(version: String) {
        // Example data with ID and URL
        let versionData = [
            "ids": [],
            "isMarkedForRelease": false,
            "isReleased": false
        ] as [String : Any]
        dbRef.child(appName.encodeFirebaseKey()).child("versions").child(version.encodeFirebaseKey()).setValue(versionData)
    }

    func addPullRequestToRelease(to version: String, id: String, url: String) {
        let versionRef = dbRef.child(appName.encodeFirebaseKey()).child("versions").child(version.encodeFirebaseKey())
        versionRef.child("ids").observeSingleEvent(of: .value) { snapshot in
            var idURLPairs: [[String: String]]
            if let existingPairs = snapshot.value as? [[String: String]] {
                idURLPairs = existingPairs
            } else {
                idURLPairs = []
            }
            idURLPairs.append(["id": id, "url": url])
            versionRef.child("ids").setValue(idURLPairs)
        }
    }

    func selectVersion(version: Version?) {
        VersionViewModel.selectedVersionId = version?.id
        selectedVersion = version
    }

    func updateIsReleased(versionId: String, isReleased: Bool) {
        let versionRef = dbRef.child(appName.encodeFirebaseKey()).child("versions").child(versionId.encodeFirebaseKey())
        selectedVersion?.isReleased = isReleased
        versionRef.updateChildValues(["isReleased": isReleased])
        fetchAllVersions()
    }

    static func addPRToRelease(id: String, url: String, title: String) -> Bool {
        let dbRef = Database.database().reference()
        let appName = UserSettings().getRepoAndUserFirebaseKey()
        guard let selectedVersionId else { return false }
        let versionRef = dbRef.child(appName.encodeFirebaseKey()).child("versions").child(selectedVersionId.encodeFirebaseKey())
        versionRef.child("ids").observeSingleEvent(of: .value) { snapshot in
            var idURLPairs: [[String: String]]
            if let existingPairs = snapshot.value as? [[String: String]] {
                idURLPairs = existingPairs
            } else {
                idURLPairs = []
            }
            idURLPairs.append(["id": id, "url": url, "title": title])
            versionRef.child("ids").setValue(idURLPairs)
        }
        return true
    }
}
