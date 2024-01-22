//
//  Version.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 12/11/23.
//

import Foundation

struct Version: Identifiable {
    var id: String
    var prs: [IDAndURL] = []
    var isMarkedForRelease: Bool
    var isReleased: Bool
}
