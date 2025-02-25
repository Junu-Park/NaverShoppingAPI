//
//  SearchMainViewModelRx.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/25/25.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchMainViewModelRx {
    struct Input {
        let searchText: PublishRelay<String>
    }
    struct Output {
        let isValidSearchText: Driver<Bool>
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let isValidSearchText = PublishRelay<Bool>()
        
        input.searchText
            .map { $0.count >= 2 }
            .bind(to: isValidSearchText)
            .disposed(by: self.disposeBag)
        
        return Output(isValidSearchText: isValidSearchText.asDriver(onErrorJustReturn: false))
    }
}
