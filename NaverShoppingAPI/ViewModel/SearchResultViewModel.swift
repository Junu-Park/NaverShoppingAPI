//
//  SearchResultViewModel.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/6/25.
//

import Foundation

final class SearchResultViewModel {
    
    let networkManager: NetworkManager = NetworkManager.shared
    
    let inputQuery: Observer<String> = Observer("검색어 오류")
    
    let inputPagination: Observer<Int> = Observer(0)
    
    let inputSortOption: Observer<SortOption> = Observer(.accuracy)
    
    let inputReset: Observer<Void> = Observer(())
    
    let outputQuery: Observer<String> = Observer("검색어 오류")
    
    let outputData: Observer<[SearchResultItem]> = Observer([])
    
    let outputTotal: Observer<Int> = Observer(0)
    
    init() {
        
        self.inputQuery.closure = { [weak self] query in
            self?.networkManager.setQuery(query)
            self?.outputQuery.value = query
            self?.request()
        }
        self.inputPagination.closure = { [weak self] count in
            if count + 2 == self?.networkManager.getPageOffset() {
                self?.request()
            }
        }
        self.inputSortOption.oldClosure = { [weak self] option in
            if self?.inputSortOption.value != option {
                self?.networkManager.resetSharedDataWithChangeSort(sort: self?.inputSortOption.value ?? .accuracy)
                self?.outputData.value = []
                self?.request()
            }
            
        }
        self.inputReset.closure = { [weak self] _ in
            self?.networkManager.resetAllSharedData()
        }
    }
    
    private func request() {
        self.networkManager.naverShoppingSearchRequest {[weak self] response in
            self?.outputData.value += response.items
            self?.outputTotal.value = response.totalCount
        }
    }
}
