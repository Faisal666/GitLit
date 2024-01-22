//
//  RepoistoriesViewModel.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/17/23.
//

import Foundation

class RepositoriesViewModel: ObservableObject {

    static var shared: RepositoriesViewModel = RepositoriesViewModel()
    @Published var isLoading: Bool = false
    @Published var repositories: [RepoNode] = []
    @Published var isReload: Bool = false
    @Published var didRecieveError: Bool = false
    @Published var notAuthorized: Bool = false
    @Published var successfulCall: Bool = false

    init() {
        fetchRepos()
    }

    func fetchRepos(loginFetch: Bool = false) {
        guard UserSettings().getGithubToken() != nil, UserSettings().getGithubToken()?.isEmpty == false else { return }

        isLoading = true
        APIClient.getUserRepos { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let repositories):
                if loginFetch {
                    MainNavigationViewModel.shared.selectedOption = .switchRepository
                }
                self?.repositories = repositories.data?.viewer?.repositories?.nodes ?? []

            case .failure(let error):
                switch error {
                case .unauthorized:
                    UserSettings().setGithubToken(nil)
                    self?.notAuthorized = true
                    self?.didRecieveError = true
                default:
                    print("")
                }
            }
        }
    }

    func isRepoSelected(repo: RepoNode) -> Bool {
        guard let ownerUserName = repo.owner?.login else { return false }
        return ownerUserName == UserSettings().getSelectedRepoOwner() && repo.name == UserSettings().getSelectedRepo()
    }

    func setRepoSelected(repo: RepoNode) {
        guard let ownerUserName = repo.owner?.login else { return }
        UserSettings().setSelectedRepo(repo.name)
        UserSettings().setSelectedRepoOwner(ownerUserName)
        PullRequestsViewModel.shared.fetchPullRequests()
    }
}
