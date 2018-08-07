//
//  SearchResult.swift
//  iTunes Search
//
//  Created by Jonathan T. Miles on 8/7/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    var title: String?
    var creator: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case creator = "artistName"
    }
}

struct SearchResults: Codable {
    let results: [SearchResult]
}
