//
//  NavigationListView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import SwiftUI

struct NavigationListView: View {

    @StateObject var viewModel: PullRequestsViewModel = PullRequestsViewModel.shared
    @Binding var selectedOption: Option
    let options: [Option] = [.pulls, .awaitingYourFix, .awaitingPeerFix, .toRelease]
    
    var body: some View {
        VStack {
            ForEach(options, id: \.self) { option in
                HStack(alignment: .top) {
                    Image(systemName: option.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                        .foregroundColor(getOptionColor(option: option))
                    Text(option.title)
                        .foregroundColor(getOptionColor(option: option))
                    Spacer()
                    ZStack {
                        if option != .toRelease {
                            Circle()
                                .frame(width: 25)
                                .foregroundColor(getOptionColor(option: option))
                            Text(getCountOf(option: option))
                                .bold()
                        }
                    }
                    .padding(.trailing, 10)
                }
                .onTapGesture {
                    if option == .toRelease, PullRequestsViewModel.shared.notAuthorized {
                        return
                    }
                    if viewModel.needToSetRepoInfo {
                        selectedOption = .switchRepository
                    } else {
                        selectedOption = Option(rawValue: option.rawValue) ?? .pulls
                    }
                }
            }
            Spacer()
            Button("Switch\nRepositories ") {
                selectedOption = .switchRepository
            }.disabled(PullRequestsViewModel.shared.notAuthorized && !viewModel.needToSetRepoInfo)
            .roundedButtonStyle(backgroundColor: .white.opacity(0.1))

            Button("Logout") {
                PullRequestsViewModel.shared.notAuthorized = true
                UserSettings().logout()
                selectedOption = .pulls
            }
            .roundedButtonStyle(backgroundColor: .red.opacity(0.1))
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
        .frame(minWidth: 200)
    }

    private func getOptionColor(option: Option) -> Color {
        let purple = Color(red: 0.62, green: 0.35, blue: 0.99, opacity: 1.0)
        return selectedOption == option ? purple : .gray
    }

    private func getCountOf(option: Option) -> String {
        var count: Int = 0
        switch option {
        case .pulls:
            count = viewModel.allPullRequests.count
        case .toRelease:
            count = 0
        case .awaitingYourFix:
            count = viewModel.myPendingPullRequests.count
        case .awaitingPeerFix:
            count = viewModel.pendingMyCommentsPullRequests.count
        default:
            return ""
        }
        return "\(count)"
    }
}

struct NavigationListView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedOption: Option = .awaitingYourFix
        NavigationListView(selectedOption: $selectedOption)
    }
}
