//
//  PullsViewModel.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import Foundation

class PullRequestsViewModel: ObservableObject {

    static let shared = PullRequestsViewModel()
    private var meUserName: String = ""
    @Published var needToSetRepoInfo: Bool = false
    @Published var isLoading: Bool = false
    @Published var didRecieveError: Bool = false
    @Published var notAuthorized: Bool = false
    @Published var allPullRequests: [PullRequestSimplified] = []
    @Published var myPendingPullRequests: [PullRequestSimplified] = []
    @Published var pendingMyCommentsPullRequests: [PullRequestSimplified] = []
    var pullRequestsFromPastFetch: [PullRequestSimplified] = []

    private var timer: Timer?

    init() {
        startTimer()
        fetchPullRequests()
    }

    func startTimer() {
        let minutes: Double = 10
        timer = Timer.scheduledTimer(withTimeInterval: minutes * 60, repeats: true) { [weak self] _ in
            self?.fetchPullRequests()
        }
    }

    func fetchPullRequests() {
        guard UserSettings().getGithubToken() != nil, UserSettings().getGithubToken()?.isEmpty == false else {
            notAuthorized = true
            return
        }

        guard let repoName = UserSettings().getSelectedRepo(), let ownerName = UserSettings().getSelectedRepoOwner() else {
            needToSetRepoInfo = true
            return
        }

        needToSetRepoInfo = false
        isLoading = true
        APIClient.getPullRequests(repoName: repoName, ownerName: ownerName) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let pullRequests):
                let simplifiedPullRequests = UserPullRequestsResponseSimplified(repository: pullRequests.data?.repository, viewer: pullRequests.data?.viewer)
                self.didRecieveError = false
                self.meUserName = simplifiedPullRequests.userName
                UserSettings().setUserName(simplifiedPullRequests.userName)
                if self.pullRequestsFromPastFetch.isEmpty {
                    self.allPullRequests = simplifiedPullRequests.pullRequests
                } else {
                    self.allPullRequests = simplifiedPullRequests.pullRequests.checkIfUpdated(comparedTo: self.pullRequestsFromPastFetch)
                }
                self.prepareMyPendingPullRequests()
                self.preparePendingMyCommentsPullRequests()
                self.notAuthorized = false
                self.pullRequestsFromPastFetch = simplifiedPullRequests.pullRequests
                NotificationManager.shared.fireNotification()
            case .failure(let error):
                switch error {
                case .unauthorized:
                    UserSettings().setGithubToken(nil)
                    self.notAuthorized = true
                    self.didRecieveError = true
                default:
                    break
                }
            }
        }
    }

    func getPullRequests(for type: PullRequestsFilterType) -> [PullRequestSimplified] {
        switch type {
        case .allPullRequests:
            return allPullRequests
        case .myPendingPullRequests:
            return myPendingPullRequests
        case .pendingMyCommentsPullRequests:
            return pendingMyCommentsPullRequests
        case .toRelease(let ids):
            let objectsDictionary = Dictionary(uniqueKeysWithValues: allPullRequests.map { ("\($0.number ?? 0)", $0) })
            return ids.map { id -> PullRequestSimplified in
                if let foundPullRequest = objectsDictionary[id.id] {
                    return foundPullRequest
                } else {
                    return PullRequestSimplified(reviewDecision: .merged, number: Int(id.id), title: id.title, url: id.url, autherUserName: nil, autherId: nil, threads: [])
                }
            }
        }
    }

    func getPullRequestCount(pullRequests: [PullRequestSimplified], of type: PullRequestsCountFilterType) -> Int {
        switch type {
        case .all:
            return pullRequests.count

        case .approved:
            return pullRequests.filter { pull in
                pull.reviewDecision == .approved
            }.count

        case .changesRequested:
            return pullRequests.filter { pull in
                pull.reviewDecision == .changesRequested
            }.count

        case .reviewRequested:
            return pullRequests.filter { pull in
                pull.reviewDecision == .reviewRequired
            }.count
        }
    }

    private func prepareMyPendingPullRequests() {
        myPendingPullRequests = allPullRequests.filter { pull in
            let isMyPr = pull.autherUserName
            let threadsUnresolved = pull.threads.filter { $0.isResolved == false }
            let shouldInclude = isMyPr == meUserName && threadsUnresolved.isEmpty == false
            return shouldInclude
        }
    }

    private func preparePendingMyCommentsPullRequests() {
        pendingMyCommentsPullRequests = allPullRequests.filter { pull in
            let myUnresolvedThreads = pull.threads.filter { thread in
                let isMyThread = thread.comments.first?.autherUserName == meUserName
                let isResolved = thread.isResolved ?? false
                return isMyThread && !isResolved
            }

            return !myUnresolvedThreads.isEmpty
        }
    }
}
