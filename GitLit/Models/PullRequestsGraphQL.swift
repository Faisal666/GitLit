//
//  PullRequestsGraphQL.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import Foundation

struct PullRequestsGraphQL: Codable {
    let data: DataClass?
}

struct DataClass: Codable {
    let viewer: Viewer?
    let repository: Repository?
}

struct Viewer: Codable {
    let login: String
}

struct Repository: Codable {
    let pullRequests: PullRequestsOpened?
}

struct PullRequestsOpened: Codable {
    let edges: [PullRequestEdge]?
}

struct PullRequestEdge: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let node: PullRequestNode?
}

struct PullRequestNode: Codable {
    let reviewDecision: ReviewDecision?
    let number: Int?
    let title: String?
    let url: String?
    let author: Author?
    let reviewThreads: ReviewThreads?

}

struct Author: Codable {
    let login: String?
    let id: String?
}

struct ReviewThreads: Codable {

    let edges: [ReviewThreadEdge]?
}

struct ReviewThreadEdge: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let node: ReviewThreadNode?
}

struct ReviewThreadNode: Codable {
    let isResolved: Bool?
    let comments: CommentsAdded?
}

enum ReviewDecision: String, Codable {
    case changesRequested = "CHANGES_REQUESTED"
    case approved = "APPROVED"
    case reviewRequired = "REVIEW_REQUIRED"
    case merged = "MERGED"
}

struct CommentsAdded: Codable {
    let edges: [CommentEdge]?
}

struct CommentEdge: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let node: CommentNode?
}

struct CommentNode: Codable {
    let url: String?
    let author: Author?
    let body: String?
}

struct UserPullRequestsResponseSimplified {
    var userName: String
    var pullRequests: [PullRequestSimplified]

    init(repository: Repository?, viewer: Viewer?) {
        userName = viewer?.login ?? ""
        let edges = repository?.pullRequests?.edges ?? []
        pullRequests = edges.map { edge in
            let node = edge.node
            let threadEdges = edge.node?.reviewThreads?.edges ?? []
            let threads = threadEdges.map({ edge in
                let threadNode = edge.node
                let commentsEdges = threadNode?.comments?.edges ?? []
                let comments = commentsEdges.map { edge in
                    let commentNode = edge.node
                    return PullRequestCommentSimplified(url: commentNode?.url, body: commentNode?.body, autherUserName: commentNode?.author?.login, autherId: commentNode?.author?.id)
                }
                return PullRequestThreadSimplified(isResolved: threadNode?.isResolved, comments: comments)
            })

            let pullRequest = PullRequestSimplified(reviewDecision: node?.reviewDecision,
                                                    number: node?.number,
                                                    title: node?.title,
                                                    url: node?.url,
                                                    autherUserName: node?.author?.login,
                                                    autherId: node?.author?.id,
                                                    threads: threads)
            return pullRequest
        }
    }
}

struct PullRequestSimplified: Identifiable {

    var id: String { UUID().uuidString }
    let reviewDecision: ReviewDecision?
    let number: Int?
    let title: String?
    let url: String?
    let autherUserName: String?
    let autherId: String?
    let threads: [PullRequestThreadSimplified]
    var isUpdated: Bool = false
    var isNew: Bool = false
}

struct PullRequestThreadSimplified: Identifiable  {
    var id: String { UUID().uuidString }
    let isResolved: Bool?
    let comments: [PullRequestCommentSimplified]
}

struct PullRequestCommentSimplified: Identifiable  {
    var id: String { UUID().uuidString }
    let url: String?
    let body: String?
    let autherUserName: String?
    let autherId: String?
}

extension PullRequestSimplified {
    func isUpdated(comparedTo other: PullRequestSimplified) -> Bool {
        if reviewDecision != other.reviewDecision || number != other.number || title != other.title || url != other.url || autherUserName != other.autherUserName || autherId != other.autherId || threads.count != other.threads.count {
            return true
        }
        return false
    }
}

extension Array where Element == PullRequestSimplified {
    func checkIfUpdated(comparedTo storedArray: [PullRequestSimplified]) -> [PullRequestSimplified] {
        var updatedArray: [PullRequestSimplified] = []

        for newPR in self {
            if let storedPR = storedArray.first(where: { $0.number == newPR.number }) {
                var newPRCopy = newPR
                newPRCopy.isUpdated = newPR.isUpdated(comparedTo: storedPR)
                if newPRCopy.isUpdated {
                    NotificationManager.shared.collectPRGeneralUpdate()
                }
                updatedArray.append(newPRCopy)
            } else {
                var newPRCopy = newPR
                newPRCopy.isUpdated = false
                newPRCopy.isNew = true
                NotificationManager.shared.collectNewPRAddedUpdate()
                updatedArray.append(newPRCopy)
            }
        }

        return updatedArray
    }
}
