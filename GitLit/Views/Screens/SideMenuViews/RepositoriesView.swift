//
//  RepositoriesView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/13/23.
//

import SwiftUI
import Kingfisher

struct RepositoriesView: View {

    @StateObject var viewModel = RepositoriesViewModel()
    @StateObject var pullViewModel = PullRequestsViewModel.shared
    
    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        VStack {
            let isLoading = viewModel.isLoading || pullViewModel.isLoading
            if isLoading {
                ProgressView()
            }
            List(viewModel.repositories.indices, id: \.self) { index in
                let repo = viewModel.repositories[index]
                HStack {
                    KFImage.url(URL(string: repo.owner?.avatarURL ?? ""))
                        .placeholder { _ in
                            Image(systemName: "photo")
                                .frame(width: 25, height: 25)
                        }
                      .loadDiskFileSynchronously()
                      .cacheMemoryOnly()
                      .fade(duration: 0.25)
                      .resizable()
                      .frame(width: 25, height: 25)

                    Text(repo.owner?.login ?? "No Name")
                        .bold()
                    Text(repo.name)
                    Spacer()
                    Button(viewModel.isRepoSelected(repo: repo) ? "Selected" : "Select") {
                        viewModel.setRepoSelected(repo: repo)
                        viewModel.isReload.toggle()
                    }.disabled(viewModel.isRepoSelected(repo: repo) || isLoading)
                }
                .listRowBackground(index % 2 == 0 ? Color.white.opacity(0.05) : Color.clear)
            }
        }
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
            .frame(minWidth: 500)
    }
}
