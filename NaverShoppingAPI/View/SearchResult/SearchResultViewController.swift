//
//  SearchResultViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import Kingfisher
import RealmSwift
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit


struct SearchResultCollectionViewSection {
    let header: SortOption // Section 타이틀
    var items: [Item] // Section 내의 Cell에 들어갈 정보
}
extension SearchResultCollectionViewSection: SectionModelType {
    // Cell에 들어갈 정보를 의미
//    typealias Item = String
    // 타입 커스텀
    typealias Item = SearchResultItem
    
    init(original: SearchResultCollectionViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class SearchResultViewController: CustomViewController {
    
    private lazy var resultCountLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.systemGreen
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()
    
    private lazy var resultCollectionView: SearchResultCollectionView = SearchResultCollectionView(superView: view)
    
    var searchText: String
    private var sortOption: PublishRelay<SortOption> = PublishRelay<SortOption>()
    private let viewModelRx: SearchResultViewModelRx = SearchResultViewModelRx()
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let realm: Realm = try! Realm()
    
    private var likedList: Results<LikedItem>!
    
    init(searchText: String) {
        self.searchText = searchText
        super.init()
        
        self.likedList = self.realm.objects(LikedItem.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.bind()
    }
    
    private func bind() {
        let likeButtonTapped = PublishRelay<SearchResultItem>()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SearchResultCollectionViewSection> { dataSource, view, indexPath, item in
            let cell = view.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
            
            let url = URL(string: item.image)
            cell.imageView.kf.setImage(with: url)
            cell.itemNameLabel.text = self.removeBoldTag(item.itemName)
            cell.mallNameLabel.text = item.mallName
            cell.priceLabel.text = Int(item.lowPrice)!.formatted()
            if self.likedList.contains(where: { $0.id == item.id }){
                cell.likeButton.imageView?.image = UIImage(systemName: "heart.fill")
            } else {
                cell.likeButton.imageView?.image = UIImage(systemName: "heart")
            }
            cell.likeButton.rx.tap
                .map { item }
                .bind(to: likeButtonTapped)
                .disposed(by: cell.disposeBag)
            return cell
        } configureSupplementaryView: { dataSource, view, kind, indexPath in
            let header = view.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultCollectionHeaderView.id, for: indexPath) as! SearchResultCollectionHeaderView

            header.selectedSortOption = dataSource.sectionModels[indexPath.section].header
            header.subviews.forEach { view in
                let button = view as! SortOptionButton
                if button.sortOption == dataSource.sectionModels[indexPath.section].header {
                    button.isSelect = true
                }
                button.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.sortOption.accept(button.sortOption)
                    }
                    .disposed(by: self.disposeBag)
            }
            return header
        }
        
        var input = SearchResultViewModelRx.Input(likeButtonTapped: likeButtonTapped)
        input.searchText.accept(searchText)
        input.searchTextWithSort = self.sortOption
        
        let output = viewModelRx.transform(input: input)
        output.searchResult
            .asObservable()
            .withUnretained(self, resultSelector: { owner, value in
                return [SearchResultCollectionViewSection(header: value.0, items: value.1)]
            })
            .bind(to: self.resultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(resultCountLabel)
        view.addSubview(resultCollectionView)
    }
    
    override func configureLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        self.navigationItem.title = self.searchText
    }
}

extension SearchResultViewController {
    
    func removeBoldTag(_ string: String) -> String {
        var replacedString: String = string.replacingOccurrences(of: "<b>", with: "")
        replacedString = replacedString.replacingOccurrences(of: "</b>", with: "")
        return replacedString
    }
}
