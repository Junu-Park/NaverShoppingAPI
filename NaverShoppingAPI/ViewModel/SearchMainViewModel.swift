//
//  SearchMainViewModel.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/6/25.
//

import Foundation

final class SearchMainViewModel {
    
    let inputQuery: Observer<String?> = Observer(nil)
    
    let outputAlert: Observer<Void> = Observer(())
    
    let outputQuery: Observer<String> = Observer("")
    
    init() {
        self.inputQuery.closure = { [weak self] _ in
            self?.checkSearchTerm()
        }
    }
    
    private func checkSearchTerm() {
        if let searchTerm = self.inputQuery.value?.trimmingCharacters(in: .whitespacesAndNewlines), searchTerm.count >= 2 {
            self.outputQuery.value = searchTerm
            return
        }
        self.outputAlert.value = ()
    }
}
