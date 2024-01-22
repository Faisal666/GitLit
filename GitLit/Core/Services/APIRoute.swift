//
//  APIRoute.swift
//  MailAI
//
//  Created by Faisal AlSaadi on 5/4/23.
//

import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {

    case getPullRequests(repoName: String, ownerName: String)
    case getUserRepos

    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getPullRequests, .getUserRepos:
            return .post
        }
    }

    // MARK: - Path
    private var path: String {
        switch self {
        case .getPullRequests, .getUserRepos:
            return "/graphql"
        }
    }

    private var queryParameters: [URLQueryItem]? {
        switch self {

        default:
            return nil
        }
    }

    private var parameters: Parameters? {

        switch self {

        case .getPullRequests(let repoName, let ownerName):
            let graphqlQuery = """
            {
              viewer {
                 login
              }
              repository(owner: "\(ownerName)", name: "\(repoName)") {

                pullRequests(states: [OPEN], first: 50, orderBy: {field: CREATED_AT, direction: DESC}) {
                  edges {
                    node {
                      reviewDecision
                      number
                      title
                      url
                      author {
                        login
                      }
                      reviewThreads(first: 100) {
                        edges {
                          node {
                            isResolved
                            comments(first: 50) {
                              edges {
                                node {
                                  url
                                  author {
                                    login
                                  }
                                  body
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            """
            return ["query": graphqlQuery]

        case .getUserRepos:
            let graphqlQuery = """
            {
              viewer {
                repositories(first: 100) {
                  nodes {
                    name
                    owner {
                      login
                      avatarUrl
                    }
                  }
                }
              }
            }
            """
            return ["query": graphqlQuery]

        default:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: try K.ProductionServer.baseURL.asURL().appendingPathComponent(path).absoluteString) //try K.ProductionServer.baseURL.asURL()

        urlComponents?.queryItems = queryParameters
        var urlRequest = URLRequest(url: urlComponents!.url!)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Header
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        if let token = UserSettings().getGithubToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        

        // Parameters
        if let parameters = parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                #if DEBUG
                  data.printJSON()
                #endif
                urlRequest.httpBody = data
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }
}

extension Data{
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}
