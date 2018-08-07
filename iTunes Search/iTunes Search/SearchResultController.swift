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
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (NSError?) -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        let searchQueryItem = URLQueryItem(name: "term", value: searchTerm)
        urlComponents.queryItems = [searchQueryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(searchTerm)")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(NSError())
            }
            guard let data = data else {
                NSLog("Error fetching data. No data returned.")
                completion(NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let theseSearchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = theseSearchResults.results
                completion(nil)
            } catch {
                NSLog("Unable to encode")
                completion(NSError())
                return
            }
        }
        dataTask.resume()
    }
}
