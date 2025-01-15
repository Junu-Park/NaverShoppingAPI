//
//  SearchResult.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import Foundation

struct SearchResult: Decodable {
    var totalCount: Int
    var start: Int
    var display: Int
    var items: [SearchResultItem]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total"
        case start
        case display
        case items
    }
}

struct SearchResultItem: Decodable {
    var title: String
    var mallName: String
    var image: String
    var lowPrice: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case mallName
        case image
        case lowPrice = "lprice"
    }
}
