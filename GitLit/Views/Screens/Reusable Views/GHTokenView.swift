//
//  GHTokenView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/17/23.
//

import SwiftUI

struct GHTokenView: View {

    @State var token: String = ""
    @StateObject var reposViewModel = RepositoriesViewModel()

    var body: some View {
        VStack {

            if reposViewModel.isLoading {
                ProgressView()
            }

            Text("Hello, Struggling Developer!")
                .font(.largeTitle)
                .padding()

            Text("In order to make your life better with your reviews")
                .font(.headline)

            Text("You'll need to enter your github token")
                .lineLimit(2)
                .font(.headline)

            Text("And don't worry, GitLit is just viewing tool")

            Text("These are the permissions you need:")
                .font(.headline)
                .padding()

            Image("git-permissions")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 200)

            TextField("GitHub Token", text: $token)
                .frame(width: 400)
                .padding()
                .multilineTextAlignment(.center)
                .font(.title)
                .cornerRadius(16)

            Button {
                UserSettings().setGithubToken(token)
                reposViewModel.fetchRepos(loginFetch: true)
            } label: {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .frame(width: 140, height: 40)
                        .foregroundColor(.orange)
                    Text("Let's GitLit 🔥")
                        .font(.headline)
                }
            }
            .disabled(reposViewModel.isLoading)
            .buttonStyle(.plain)

            if reposViewModel.didRecieveError {
                Text("Something bad happened 😕")
                Text("Please check your token")
            }
        }
    }
}

struct GHTokenView_Previews: PreviewProvider {

    static var previews: some View {
        GHTokenView()
    }
}
