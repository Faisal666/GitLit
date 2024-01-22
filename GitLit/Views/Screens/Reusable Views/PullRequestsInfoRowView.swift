//
//  PullRequestsInfoRowView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/13/23.
//

import SwiftUI

struct PullRequestsInfoRowView: View {
    @StateObject var viewModel: PullRequestsViewModel = PullRequestsViewModel.shared
    var allPullRequests: [PullRequestSimplified]

    var body: some View {
        HStack {
            Group {
                Text("All:")
                Text("\(viewModel.getPullRequestCount(pullRequests: allPullRequests, of: .all))")
                    .bold()
                Spacer()
                Text("Approved:")
                    .foregroundColor(.green)
                Text("\(viewModel.getPullRequestCount(pullRequests: allPullRequests, of: .approved))")
                    .bold()
                Spacer()
                Text("Review Requested:")
                    .foregroundColor(.yellow)
                Text("\(viewModel.getPullRequestCount(pullRequests: allPullRequests, of: .changesRequested))")
                    .bold()
            }

            Group {
                Spacer()
                Text("Changes Requested:")
                    .foregroundColor(.red)
                Text("\(viewModel.getPullRequestCount(pullRequests: allPullRequests, of: .changesRequested))")
                    .bold()
                Spacer()
                Button("Refresh") {
                    viewModel.fetchPullRequests()
                }.disabled(viewModel.isLoading)
            }
        }
    }
}

struct PullRequestsInfoRowView_Previews: PreviewProvider {
    static var previews: some View {
        PullRequestsInfoRowView(allPullRequests: [])
    }
}
