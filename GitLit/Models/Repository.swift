//
//  Repository.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/13/23.
//

import Foundation

// MARK: - RepositoryData
struct RepositoryResponse: Codable {
    let data: RepositoryData?
}

// MARK: - DataClass
struct RepositoryData: Codable {
    let viewer: RepoViewer?
}

// MARK: - Viewer
struct RepoViewer: Codable {
    let repositories: Repositories?
}

// MARK: - Repositories
struct Repositories: Codable {
    let nodes: [RepoNode]?
}

// MARK: - Node
struct RepoNode: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let name: String
    let owner: Owner?
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatarUrl"
    }
}
