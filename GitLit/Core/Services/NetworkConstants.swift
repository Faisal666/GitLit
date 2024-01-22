//
//  NetworkConstants.swift
//  MailAI
//
//  Created by Faisal AlSaadi on 5/4/23.
//

import Foundation

struct K {

    struct ProductionServer {
        static let baseURL = "https://api.github.com"
    }

    struct APIParameterKey {

//        static let email = "email"
    }

    struct APIParameterValue {
//        static let iOS = "ios"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-language"
}

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
    case jsonGit = "application/vnd.github+json"
}
