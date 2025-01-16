//
//  SearchResultViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import Kingfisher
import SnapKit

class SearchResultViewController: CustomViewController {

    let networkManager: NetworkManager = NetworkManager.shared
    
    lazy var resultCountLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.systemGreen
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.text = getResultCountText()
        return lb
    }()
    
    lazy var resultCollectionView: SearchResultCollectionView = SearchResultCollectionView(superView: view)
    
    var searchTerm: String = ""
    
    var searchData: SearchResult? {
        didSet {
            self.resultCollectionView.reloadData()
        }
    }
    
    var searchSort: SortOption = .accuracy {
        didSet(oldValue) {
            if oldValue != searchSort {
                self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                networkManager.resetSharedDataWithChangeSort(sort: searchSort)
                networkManager.naverShoppingSearchRequest { data in
                    self.searchData = data
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.setQuery(searchTerm)
        navigationItem.title = searchTerm
        connectionCollectionView()
        networkManager.naverShoppingSearchRequest { data in
            self.searchData = data
            self.resultCountLabel.text = self.getResultCountText()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        networkManager.resetAllSharedData()
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
}

extension SearchResultViewController {
    func getResultCountText() -> String {
        return "\(networkManager.getTotalCount().formatted()) 개의 검색 결과"
    }
    
    func removeBoldTag(_ string: String) -> String {
        var replacedString: String = string.replacingOccurrences(of: "<b>", with: "")
        replacedString = replacedString.replacingOccurrences(of: "</b>", with: "")
        return replacedString
    }
    
    @objc func sortButtonTapped(_ sender: SortOptionButton) {
        searchSort = sender.sortOption
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func connectionCollectionView() {
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = resultCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultCollectionHeaderView.id, for: indexPath) as! SearchResultCollectionHeaderView
        
        header.selectedSortOption = self.searchSort
        
        header.subviews.forEach { view in
            let button = view as! SortOptionButton
            if button.sortOption == self.searchSort {
                button.isSelect = true
            }
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        
        if let data = searchData?.items[indexPath.row]{
            let url = URL(string: data.image)
            cell.imageView.kf.setImage(with: url)
            cell.itemNameLabel.text = removeBoldTag(data.itemName)
            cell.mallNameLabel.text = data.mallName
            cell.priceLabel.text = Int(data.lowPrice)!.formatted()
        }
        
        if (indexPath.item + 2) == networkManager.getPageOffset() {
            networkManager.naverShoppingSearchRequest { data in
                self.searchData?.items += data.items
            }
        }
        return cell
    }
}
