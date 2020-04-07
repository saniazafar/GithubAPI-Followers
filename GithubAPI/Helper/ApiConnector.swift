//
//  ApiConnector.swift
//  GithubAPI
//
//  Created by sania zafar on 06/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import Foundation

struct Pagination {
    
    var nextPage = -1
    var lastPage = -1
    
}

class ApiConnector: NSObject {
    
    var pagination = Pagination()
    
    func fetchFollowers(for userName: String, pageNo: Int, success: @escaping (Any?, Int) -> Void, fail: @escaping(Error) -> Void) {
        guard pageNo != -1 else {
            return
        }
        
        var urlString = "https://api.github.com/users/{username}/followers?page={pageNo}"
        urlString = urlString.replacingOccurrences(of: "{username}", with: userName)
        urlString = urlString.replacingOccurrences(of: "{pageNo}", with: "\(pageNo)")
        let url = URL(string: urlString)
        guard url != nil else {
            
            return
        }
        let urlRequest = URLRequest(url: url!)
        let urlSession = URLSession.shared
        let data = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard error == nil, let dataObject = data, let httpResponse = response as? HTTPURLResponse else {
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: dataObject, options: .fragmentsAllowed)
                let link = httpResponse.value(forHTTPHeaderField: "Link") ?? ""
                if link.isEmpty {
                    success(jsonObject, -1)
                } else if pageNo != self?.pagination.lastPage {
                    self?.setPaginationInfo(from: link)
                    success(jsonObject, self?.pagination.nextPage ?? -1)
                } else {
                    success(jsonObject, -1)
                }
            } catch {}
        }
        data.resume()
    }
    
    private func setPaginationInfo(from linkHeader: String) {
        let links = linkHeader.components(separatedBy: ", ")
        var dictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy:"; ")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            dictionary[components[1]] = cleanPath
        })

        if let nextPagePath = dictionary["rel=\"next\""] {
            let url = URL(string: nextPagePath)
            if url != nil, let params = url?.params(),
                let pageString = params["page"] as? String,
                let page = Int(pageString) {
                pagination.nextPage = page
            }
        }

        if let lastPagePath = dictionary["rel=\"last\""] {
            let url = URL(string: lastPagePath)
            if url != nil, let params = url?.params(),
                let pageString = params["page"] as? String,
                let page = Int(pageString) {
                pagination.lastPage = page
            }
        }
    }
    
}

extension URL {

    func params() -> [String: Any] {
        var dict = [String: Any]()

        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems {
            for item in queryItems {
                if let itemValue = item.value {
                    dict[item.name] = itemValue
                }
            }
        }

        return dict
    }

}
