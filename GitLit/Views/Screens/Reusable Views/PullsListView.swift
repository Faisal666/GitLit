//
//  PullsListView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/17/23.
//

import SwiftUI

struct PullsListView: View {

    @StateObject var viewModel: PullRequestsViewModel
    @State var type: PullRequestsFilterType
    @State private var selectedItemId: Int?
    @State private var searchedText: String = ""

    var filteredPullRequests: [PullRequestSimplified] {
        if searchedText.isEmpty {
            return viewModel.getPullRequests(for: type)
        } else {
            return viewModel.getPullRequests(for: type).filter { pullRequest in
                pullRequest.title?.localizedCaseInsensitiveContains(searchedText) ?? false ||
                pullRequest.autherUserName?.localizedCaseInsensitiveContains(searchedText) ?? false ||
                String(pullRequest.number ?? 0).contains(searchedText)
            }
        }
    }

    var body: some View {
        let pullRequests = filteredPullRequests
        VStack {

            if viewModel.isLoading {
                ProgressView()
            }

            SearchBar(text: $searchedText)

            PullRequestsInfoRowView(allPullRequests: pullRequests).padding()

            if pullRequests.isEmpty {
                Text("Nothing here yet mate!")
            }

            List(pullRequests.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading) {
                        Text("@" + (pullRequests[index].autherUserName ?? "NON"))
                            .fontWeight(.bold)
                        Text(pullRequests[index].title ?? "")
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    }
                    Spacer()

                    let reviewDecision = pullRequests[index].reviewDecision ?? .approved
                    let unresolvedComments = pullRequests[index].threads.filter { $0.isResolved == false }.count 
                    if pullRequests[index].isUpdated {
                        Text("Updated 🔔")
                    }

                    if pullRequests[index].isNew {
                        Text("New 🔔")
                    }
                    switch reviewDecision {

                    case .approved:
                        Text("Approved ✅")
                            .foregroundColor(.green)

                    case .changesRequested:
                        Text("Changes Requested ⛔️\n (\(unresolvedComments) unresovled comments)")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.red)
                        Image(systemName: "text.bubble.fill")
                            .onTapGesture {
                                selectedItemId = index
                            }.popover(isPresented: Binding<Bool>(
                                get: { self.selectedItemId == index },
                                set: { newValue in
                                    if !newValue {
                                        selectedItemId = nil
                                    }
                                }
                            ), arrowEdge: .bottom) {
                                CommentsPopoverView(threads: pullRequests[index].threads)
                            }

                    case .reviewRequired:
                        Text("Review Required ⚠️")
                            .foregroundColor(.yellow)
                    case .merged:
                        Text("Merged or Deleted")
                            .bold()
                            .foregroundColor(.white)
                            .padding(3)
                            .background(.green)
                            .cornerRadius(5)
                    }

                    if let urlString = pullRequests[index].url,
                       let url = URL(string: urlString) {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .onTapGesture {
                                NSWorkspace.shared.open(url)
                            }
                    }
                }
                .listRowBackground(index % 2 == 0 ? Color.white.opacity(0.05) : Color.clear)
                .modifier(PRMenuModifier(addAction: {
                    guard let url = pullRequests[index].url, let id = pullRequests[index].number, let title = pullRequests[index].title else { return }
                    let isAddedToRelease = VersionViewModel.addPRToRelease(id: "\(id)", url: url, title: title)
                    if !isAddedToRelease {
                        AlertsPresenter().presentVersionNotSelectedError()
                    }
                }))
            }
        }
    }
}

struct PullsListView_Previews: PreviewProvider {
    static var previews: some View {
        PullsListView(viewModel: PullRequestsViewModel.shared, type: .allPullRequests)
    }
}
