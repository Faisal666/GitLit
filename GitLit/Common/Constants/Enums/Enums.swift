//
//  Enums.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import SwiftUI

enum Option: Int, CaseIterable {
    case pulls
    case toRelease
    case awaitingYourFix
    case awaitingPeerFix
    case switchRepository

    var title: String {
        switch self {
        case .pulls:
            return "PullRequests"
        case .toRelease:
            return "To Release"
        case .awaitingYourFix:
            return "My Pending PRs"
        case .awaitingPeerFix:
            return "Peer Pending Your Feedback PRs"
        default:
            return ""
        }
    }

    var imageName: String {
        switch self {
        case .pulls:
            return "tray.full.fill"
        case .toRelease:
            return "icloud.and.arrow.up.fill"
        case .awaitingYourFix:
            return "person.badge.clock.fill"
        case .awaitingPeerFix:
            return "text.bubble.fill"
        default:
            return ""
        }
    }
}

enum PullRequestsFilterType {
    case allPullRequests
    case myPendingPullRequests
    case pendingMyCommentsPullRequests
    case toRelease(_ ids: [IDAndURL])
}

enum PullRequestsCountFilterType {
    case all
    case approved
    case changesRequested
    case reviewRequested
}
