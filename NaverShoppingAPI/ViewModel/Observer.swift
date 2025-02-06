//
//  Observer.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/6/25.
//

import Foundation

final class Observer<T> {
    var value: T {
        didSet(oldVal) {
            self.closure?(self.value)
            self.oldClosure?(oldVal)
        }
    }
    
    var closure: ((T) -> ())?
    
    var oldClosure: ((T) -> ())?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> ()) {
        closure(self.value)
        self.closure = closure
    }
}
