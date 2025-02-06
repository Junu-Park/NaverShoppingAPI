//
//  Observer.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/6/25.
//

import Foundation

final class Observer<T> {
    var value: T {
        didSet {
            self.closure?(self.value)
        }
    }
    
    var closure: ((T) -> ())?
    
    init(_ value: T) {
        self.value = value
    }
}
