//
//  APIClient.swift
//  MailAI
//
//  Created by Faisal AlSaadi on 5/4/23.
//

import Foundation
import Alamofire

class APIClient {

    static var session: Session = {
//        let evaluators: [String : ServerTrustEvaluating] = [
//            "api.openai.com" : PublicKeysTrustEvaluator(),
//            "jsonplaceholder.typicode.com" : PublicKeysTrustEvaluator()
//        ]
//
//        let manager = ServerTrustManager(evaluators: evaluators)
        let session = Session()
        return session
    }()

    @discardableResult
    private static func performRequest<T:Decodable>(route: APIRouter, decoder: JSONDecoder = newJSONDecoder(), completion:@escaping (Result<T, MailAIError>)->Void) -> DataRequest {
//        Loader.showLoader()

        return session.request(route)
            .validate()
            .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
                let dictionary = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: Any?]
                #if DEBUG || DEBUG_SIM
                print("\n\n\n\n ===================== BEGIN  ====================================== \n\n\n\n")
                    print("API Path: \(route.urlRequest?.url?.absoluteString ?? "")")
                    print("Status Code: \(response.response?.statusCode ?? 00)")
                    response.data?.printJSON()
                print("\n\n\n\n ===================== END  ====================================== \n\n\n\n")
                #endif

//                Loader.hideLoader()

                switch response.result {
                case .success(let decodable):
                    completion(.success(decodable))
                case .failure(let error):
                    NSLog(error.localizedDescription)
                    #if DEBUG || DEBUG_SIM
                        print(error)
                        print(error.localizedDescription)
                    #endif
                    if response.response?.statusCode == 401 {
                        completion(.failure(.unauthorized))
                    } else if let errorMessage = dictionary?["error"] as? String, errorMessage != "" {
                        completion(.failure(MailAIError.getErrorType(errorMessage: errorMessage)))
                    } else if let errorMessage = dictionary?["message"] as? String, errorMessage != "" {
                        let code = (dictionary?["code"] as? String) ?? ""
                        completion(.failure(MailAIError.getErrorType(errorMessage: errorMessage, errorCode: code)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
        }
    }

    static func getPullRequests(repoName: String, ownerName: String, completion: @escaping (Result<PullRequestsGraphQL, MailAIError>) -> Void){
        performRequest(route: APIRouter.getPullRequests(repoName: repoName, ownerName: ownerName), completion: completion)
    }

    static func getUserRepos(completion: @escaping (Result<RepositoryResponse, MailAIError>) -> Void){
        performRequest(route: APIRouter.getUserRepos, completion: completion)
    }

    static func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
}


enum MailAIError: Error {
    case networkError(AFError)
    case unknownErrorMessage(String)
    case unauthorized

    static func getErrorType(errorMessage: String, errorCode: String = "") -> MailAIError {

        return .unknownErrorMessage("Unknown")
    }
}

extension MailAIError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .networkError(let networkError):
            return networkError.localizedDescription
        case .unknownErrorMessage(let serverErrorErrorMessage):
            return serverErrorErrorMessage
        case .unauthorized:
            return "unauthorized"
        }
    }
}
