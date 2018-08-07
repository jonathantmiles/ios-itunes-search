//
//  SearchResultController.swift
//  iTunes Search
//
//  Created by Jonathan T. Miles on 8/7/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation

class SearchResultController {
    let baseURL: URL = URL(string: "https://itunes.apple.com/search")!
    
    var searchResults: [SearchResult] = []
    
    private enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping ([SearchResult]?, NSError?) -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        let searchQueryItem = URLQueryItem(name: "term", value: searchTerm)
        urlComponents.queryItems = [searchQueryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(nil, NSError())
            }
            guard let data = data else {
                NSLog("Error fetching data. No data returned.")
                completion(nil, NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let theseSearchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                let results = theseSearchResults.results
                completion(results, nil)
            } catch {
                NSLog("Unable to encode")
                completion(nil, NSError())
                return
            }
        }
        dataTask.resume()
    }
}
