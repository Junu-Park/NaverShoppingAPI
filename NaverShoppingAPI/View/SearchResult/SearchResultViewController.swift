//
//  SearchResultViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import SnapKit

class SearchResultViewController: CustomViewController {

    lazy var resultCountLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.systemGreen
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.text = getResultCountText()
        return lb
    }()
    
    lazy var resultCollectionView: SearchResultCollectionView = SearchResultCollectionView(superView: view)
    
    var searchTerm: String = ""
    
    var data: SearchResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchTerm
        connectionCollectionView()
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
        
        if let data {
            return "\(data.totalCount.formatted()) 개의 검색 결과"
        } else {
            return "0 개의 검색 결과"
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func connectionCollectionView() {
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        
        return cell
    }
}
