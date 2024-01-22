//
//  MainNavigationViewModel.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/18/23.
//

import Foundation

class MainNavigationViewModel: ObservableObject {

    static var shared: MainNavigationViewModel = MainNavigationViewModel()

    @Published var selectedOption: Option = PullRequestsViewModel.shared.needToSetRepoInfo ? .switchRepository : .pulls
}
