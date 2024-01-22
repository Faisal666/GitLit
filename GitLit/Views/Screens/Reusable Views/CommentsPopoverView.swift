//
//  CommentsView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/11/23.
//

import SwiftUI

struct CommentsPopoverView: View {

    @State var threads: [PullRequestThreadSimplified] = []
    @State var showNotResolved: Bool = UserSettings().getShowUnresolvedComments()
    @State var showMyComments: Bool = UserSettings().getShowMyComments()

    var body: some View {
        return VStack(alignment: .leading) {
            HStack {
                Toggle("Show my comments only", isOn: $showMyComments)
                    .padding()
                    .onChange(of: showMyComments) { newValue in
                        UserSettings().setShowMyComments(showMyComments)
                    }
                Spacer()
                Toggle("Show unresolved comments only", isOn: $showNotResolved)
                    .padding()
                    .onChange(of: showNotResolved) { newValue in
                        UserSettings().setShowUnresolvedComments(showNotResolved)
                    }
            }

            let filteredThreads = getFilteredThreads()
            
            ZStack {
                List(Array(filteredThreads.enumerated()), id: \.offset) { index, thread in
                    let comments = thread.comments
                    Section {
                        ForEach(Array(comments.enumerated()), id: \.offset) { indexOfComment, comment in
                            VStack(alignment: .leading) {
                                let userName: String = comment.autherUserName ?? ""
                                let body: String = comment.body ?? ""
                                Text("@" + userName)
                                    .foregroundColor(Color(red: 0.62, green: 0.35, blue: 0.99, opacity: 1.0))
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 2,
                                                        leading: 0,
                                                        bottom: 0,
                                                        trailing: 0))
                                Text(body)
                                    .padding(EdgeInsets(top: 2,
                                                        leading: 0,
                                                        bottom: 8,
                                                        trailing: 16))
                            }
                            .listRowBackground(indexOfComment % 2 == 0 ? Color.white.opacity(0.05) : Color.clear)
                        }

                    } header: {
                        HStack {
                            Text("Thread \(index + 1)")
                            Spacer()
                            let isResolved: Bool = thread.isResolved ?? false
                            if isResolved {
                                Text("Resolved ✅")
                                    .foregroundColor(.green)
                            } else {
                                if comments.count > 1 {
                                    Text("Review Required ⚠️")
                                        .foregroundColor(.yellow)
                                } else {
                                    Text("Not Responded yet ⚠️")
                                        .foregroundColor(.yellow)
                                }
                            }
                            if let urlString = comments.first?.url,
                               let url = URL(string: urlString) {
                                Image(systemName: "arrow.up.right.circle.fill")
                                    .onTapGesture {
                                        NSWorkspace.shared.open(url)
                                    }
                            }
                        }
                    }
                    Divider()
                        .foregroundColor(.purple)
                }

                if filteredThreads.isEmpty {
                    Text("Nothing here to see buddy!")
                }
            }
        }
        .frame(width: 600, height: 600)
    }

    private func getFilteredThreads() -> [PullRequestThreadSimplified] {
        var filteredThread = threads
        filteredThread = showNotResolved ? filteredThread.filter { !($0.isResolved ?? false) } : threads
        filteredThread = showMyComments ? filteredThread.filter { $0.comments.first?.autherUserName == UserSettings().getUserName() } : filteredThread
        return filteredThread
    }
}


//struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dummyData = ReviewThreads(edges: [
//            ReviewThreadEdge(node: ReviewThreadNode(isResolved: true, comments: CommentsAdded(edges: [
//                CommentEdge(node: CommentNode(url: "", author: Author(login: "REVIEWER", id: "001"), body: "I think this needs some changes.")),
//                CommentEdge(node: CommentNode(url: "", author: Author(login: "REVIWEE", id: "002"), body: "fixed")),
//            ]))),
//            ReviewThreadEdge(node: ReviewThreadNode(isResolved: false, comments: CommentsAdded(edges: [
//                CommentEdge(node: CommentNode(url: "https://www.google.com/", author: Author(login: "Charlie789", id: "003"), body: "Great work!")),
//                CommentEdge(node: CommentNode(url: "https://www.google.com/", author: Author(login: "Dave012", id: "004"), body: "Approved.")),
//            ]))),
//        ])
//
//        return CommentsPopoverView(threads: dummyData.edges ?? [])
//    }
//}
