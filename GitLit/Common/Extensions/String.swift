//
//  Strings.swift
//  GitLit
//
//  Created by Faisal AlSaadi on 9/11/23.
//

import Foundation

extension String {

    func extractURLs() -> [URL] {
        var urls = [URL]()
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        let range = NSRange(location: 0, length: self.utf16.count)

        detector?.enumerateMatches(in: self, options: [], range: range) { (result, _, _) in
            if let url = result?.url {
                urls.append(url)
            }
        }

        return urls
    }

    func encodeFirebaseKey() -> String {
        return self
            .replacingOccurrences(of: ".", with: "_P")
            .replacingOccurrences(of: "#", with: "_H")
            .replacingOccurrences(of: "$", with: "_D")
            .replacingOccurrences(of: "[", with: "_O")
            .replacingOccurrences(of: "]", with: "_C")
    }

    func decodeFirebaseKey() -> String {
        return self
            .replacingOccurrences(of: "_P", with: ".")
            .replacingOccurrences(of: "_H", with: "#")
            .replacingOccurrences(of: "_D", with: "$")
            .replacingOccurrences(of: "_O", with: "[")
            .replacingOccurrences(of: "_C", with: "]")
    }
}
