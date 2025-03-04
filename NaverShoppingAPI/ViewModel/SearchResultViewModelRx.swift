//
//  SearchResultViewModelRx.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/25/25.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchResultViewModelRx {
    struct Input {
        let searchText: BehaviorRelay<String> = BehaviorRelay(value: "")
        var searchTextWithSort: PublishRelay<SortOption> = PublishRelay()
    }
    struct Output {
        let searchResult: Driver<(SortOption, [SearchResultItem])>
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let searchResult = PublishSubject<(SortOption, [SearchResultItem])>()
        
        input.searchText
            .flatMap{ NetworkManager.shared.naverShoppingSearchRequestWithRx(searchText: $0) }
            .subscribe { value in
                switch value {
                case .success(let result):
                    NetworkManager.shared.resetPageOffset()
                    searchResult.onNext((.accuracy, result.items))
                case .failure(let error):
                    searchResult.onNext((.accuracy,[]))
                }
            } onError: { error in
                print("input.searchText \(error)")
            } onCompleted: {
                print("input.searchText onCompleted")
            } onDisposed: {
                print("input.searchText onDisposed")
            }
            .disposed(by: self.disposeBag)
        
        input.searchTextWithSort
            .withLatestFrom(input.searchText) { sort, text in
                return (sort, text)
            }
            .subscribe { value in
                NetworkManager.shared.resetSharedDataWithChangeSort(sort: value.0)
                NetworkManager.shared.naverShoppingSearchRequestWithRx(searchText: value.1) { response in
                    searchResult.onNext((value.0 ,response.items))
                }
            } onError: { error in
                print("input.searchTextWithSort \(error)")
            } onCompleted: {
                print("input.searchTextWithSort onCompleted")
            } onDisposed: {
                print("input.searchTextWithSort onDisposed")
            }
            .disposed(by: self.disposeBag)

        
        return Output(searchResult: searchResult.asDriver(onErrorJustReturn: (SortOption.accuracy, [])))
    }
}
