//
//  SearchResultViewModelRx.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/25/25.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class SearchResultViewModelRx {
    struct Input {
        let searchText: BehaviorRelay<String> = BehaviorRelay(value: "")
        var searchTextWithSort: PublishRelay<SortOption> = PublishRelay()
        let likeButtonTapped: PublishRelay<SearchResultItem>
    }
    struct Output {
        let searchResult: Driver<(SortOption, [SearchResultItem])>
    }
    
    private let realm: Realm = try! Realm()
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
        
        input.likeButtonTapped
            .withLatestFrom(input.searchText, resultSelector: { value, text in
                return (value, text)
            })
            .bind(with: self) { owner, value in
                do {
                    try self.realm.write {
                        guard let data = self.realm.object(ofType: LikedItem.self, forPrimaryKey: value.0.id) else {
                            self.realm.add(LikedItem(id: value.0.id, itemName: value.0.itemName, mallName: value.0.mallName, image: value.0.image, lowPrice: value.0.lowPrice))
                            input.searchText.accept(value.1)
                            return
                        }
                        self.realm.delete(data)
                        input.searchText.accept(value.1)
                    }
                } catch {
                    print("좋아요 버튼 로직 에러")
                }
            }
            .disposed(by: self.disposeBag)
        
        return Output(searchResult: searchResult.asDriver(onErrorJustReturn: (SortOption.accuracy, [])))
    }
}
