//
//  PullsView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import SwiftUI

struct PullsView: View {

    @StateObject var viewModel = PullRequestsViewModel.shared
    @State var type: PullRequestsFilterType

    var body: some View {
        VStack {
            if UserSettings().getGithubToken() == nil || viewModel.notAuthorized {
                GHTokenView()
            } else {
                PullsListView(viewModel: viewModel, type: type)
            }
        }
    }
}

struct PullsView_Previews: PreviewProvider {
    static var previews: some View {
        PullsView(type: .allPullRequests)
    }
}
