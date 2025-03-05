//
//  LikedItemCollectionViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 3/4/25.
//

import UIKit

import Kingfisher
import RealmSwift
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class LikedItemCollectionViewController: CustomViewController {

    private lazy var collectionView: SearchResultCollectionView = SearchResultCollectionView(superView: self.view)
    
    private let realm: Realm = try! Realm()
    
    private lazy var observable: BehaviorSubject<Results<LikedItem>> = BehaviorSubject(value: self.likedList)
    
    private var likedList: Results<LikedItem> {
        get {
            guard let text = self.navigationItem.searchController?.searchBar.text, !text.isEmpty else {
                return self.realm.objects(LikedItem.self)
            }
            return self.realm.objects(LikedItem.self).where { $0.itemName.contains(text, options: .caseInsensitive) }
        }
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        print(self.self, "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationItem()
        self.bind()
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = "좋아요 목록"
        self.navigationItem.backButtonDisplayMode = .minimal
        self.navigationItem.searchController = CustomSearchController(searchResultsController: nil)
        self.navigationItem.searchController?.searchBar.searchTextField.textColor = UIColor.white
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func configureHierarchy() {
        self.view.addSubview(self.collectionView)
    }
    
    override func configureLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        self.observable
            .bind(to: self.collectionView.rx.items(cellIdentifier: SearchResultCollectionViewCell.id, cellType: SearchResultCollectionViewCell.self)) { [weak self] item, value, cell in
                let url = URL(string: value.image)
                cell.imageView.kf.setImage(with: url)
                cell.itemNameLabel.text = self?.removeBoldTag(value.itemName)
                cell.mallNameLabel.text = value.mallName
                cell.priceLabel.text = Int(value.lowPrice)!.formatted()
                if self?.likedList.contains(where: { $0.id == value.id }) ?? false {
                    cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: [])
//                    cell.likeButton.imageView?.image = UIImage(systemName: "heart.fill")
                } else {
                    cell.likeButton.setImage(UIImage(systemName: "heart"), for: [])
//                    cell.likeButton.imageView?.image = UIImage(systemName: "heart")
                }
                cell.likeButton.rx.tap
                    .map { value }
                    .bind(with: self ?? LikedItemCollectionViewController(), onNext: { owner, value in
                        do {
                            try owner.realm.write {
                                owner.realm.delete(value)
                                owner.observable.onNext(owner.realm.objects(LikedItem.self))
                            }
                        } catch {
                            
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationItem.searchController?.searchBar.rx.text.orEmpty.distinctUntilChanged()
            .withUnretained(self, resultSelector: { owner, value in
                if value == "" {
                    return owner.realm.objects(LikedItem.self)
                } else {
                    return owner.realm.objects(LikedItem.self).where { $0.itemName.contains(value, options: .caseInsensitive) }
                }
            })
            .bind(to: self.observable)
            .disposed(by: self.disposeBag)
    }
}

extension LikedItemCollectionViewController {
    
    func removeBoldTag(_ string: String) -> String {
        var replacedString: String = string.replacingOccurrences(of: "<b>", with: "")
        replacedString = replacedString.replacingOccurrences(of: "</b>", with: "")
        return replacedString
    }
}
