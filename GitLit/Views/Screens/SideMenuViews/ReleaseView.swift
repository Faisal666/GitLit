//
//  ReleaseView.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/4/23.
//

import SwiftUI

struct ReleaseView: View {
    @StateObject var viewModel = VersionViewModel(appName: "InitialAppName")
    @State var appName: String = "\(UserSettings().getSelectedRepoOwner() ?? "")/\(UserSettings().getSelectedRepo() ?? "")"
    var body: some View {
//        PullsView(type: .allPullRequests)
        VStack {
            getViewToDisplay()
            Text(UserSettings().getRepoAndUserFirebaseKey())
                .bold()

            Button("New Release") {
                AlertsPresenter().presentAddNewReleaseAlert { newVersion in
                    viewModel.createReleaseVersion(version: newVersion)
                }
            }.onAppear {
                viewModel.appName = UserSettings().getRepoAndUserFirebaseKey()
                viewModel.fetchAllVersions()
            }.padding()
        }
    }

    func getViewToDisplay() -> some View  {
        Group {
            if let version = viewModel.selectedVersion {
                VStack {
                    HStack {
                        Button("Select Different Version") {
                            viewModel.selectVersion(version: nil)
                        }
                        Spacer()
                        Text("Version: \(version.id)")
                        Spacer()
                        if version.isReleased {
                            Text("Released")
                                .foregroundStyle(.green)
                            Button("Mark as unreleased") {
                                viewModel.updateIsReleased(versionId: version.id, isReleased: false)
                            }
                        } else {
                            Button("Mark as released") {
                                viewModel.updateIsReleased(versionId: version.id, isReleased: true)
                                viewModel.selectVersion(version: nil)
                            }
                        }
                    }
                    .padding()
                    PullsView(type: .toRelease(version.prs))
                }
            } else {
                if viewModel.versions.isEmpty {
                    Text("No release versions added yet on")
                } else {
                    ReleaseListView(viewModel: viewModel)
                }
            }
        }
    }
}

struct ReleaseListView: View {
    @ObservedObject var viewModel: VersionViewModel

    var body: some View {
        List(viewModel.versions) { version in
            VStack {
                HStack {
                    Text(version.id)
                    version.isReleased ? Text("Released").foregroundColor(.green) : Text("Pending").foregroundColor(.gray)
                    Spacer()
                    Button("Select & Check PRs") {
                        viewModel.selectVersion(version: version)
                    }
                    if !version.isReleased {
                        Button("Mark as released") {
                            viewModel.updateIsReleased(versionId: version.id, isReleased: true)
                        }
                    }
                }
            }
            .listRowBackground(version.isReleased ? Color.green.opacity(0.44) : .clear)

        }
    }
}

struct ReleaseView_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseView()
    }
}
