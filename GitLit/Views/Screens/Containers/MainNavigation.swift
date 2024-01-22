//
//  MainNavigation.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import SwiftUI

struct MainNavigation: View {

    @StateObject var viewModel: MainNavigationViewModel = MainNavigationViewModel.shared

    var body: some View {
        NavigationView {
            NavigationListView(selectedOption: $viewModel.selectedOption)
            
            switch viewModel.selectedOption {
            case .pulls:
                PullsView(type: .allPullRequests)

            case .toRelease:
                ReleaseView()

            case .awaitingYourFix:
                PullsView(type: .myPendingPullRequests)

            case .awaitingPeerFix:
                PullsView(type: .pendingMyCommentsPullRequests)
                
            case .switchRepository:
                RepositoriesView()
                    .frame(alignment: .topLeading)
            }
        }
        .onAppear {
            print("FFFF", "text https://stackoverflow.com/questions/52584510/show-metadata-of-file-with-url".extractURLs().first?.getURLMetaData())
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

struct MainNavigation_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigation()
    }
}
