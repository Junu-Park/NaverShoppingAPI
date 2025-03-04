//
//  RealmModel.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 3/4/25.
//

import Foundation

import RealmSwift

class LikedItem: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted(indexed: true) var itemName: String
    @Persisted var mallName: String
    @Persisted var image: String
    @Persisted var lowPrice: String
    
    convenience init(id: String, itemName: String, mallName: String, image: String, lowPrice: String) {
        self.init()
        self.id = id
        self.itemName = itemName
        self.mallName = mallName
        self.image = image
        self.lowPrice = lowPrice
    }
}
