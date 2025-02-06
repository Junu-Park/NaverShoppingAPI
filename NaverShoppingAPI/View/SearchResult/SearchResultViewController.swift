//
//  SearchResultViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import Kingfisher
import SnapKit

final class SearchResultViewController: CustomViewController {
    
    private lazy var resultCountLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.systemGreen
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()
    
    private lazy var resultCollectionView: SearchResultCollectionView = SearchResultCollectionView(superView: view)
    
    let viewModel: SearchResultViewModel = SearchResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.connectionCollectionView()
        
        self.viewModel.outputQuery.bind { [weak self] query in
            self?.navigationItem.title = query
        }
        
        self.viewModel.outputData.closure = { [weak self] data in
            
            self?.resultCollectionView.reloadData()
        }
        
        self.viewModel.outputTotal.bind { [weak self] count in
            self?.resultCountLabel.text = "\(count.formatted()) 개의 검색 결과"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.inputReset.value = ()
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
    
    func removeBoldTag(_ string: String) -> String {
        var replacedString: String = string.replacingOccurrences(of: "<b>", with: "")
        replacedString = replacedString.replacingOccurrences(of: "</b>", with: "")
        return replacedString
    }
    
    @objc func sortButtonTapped(_ sender: SortOptionButton) {
        self.viewModel.inputSortOption.value = sender.sortOption
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func connectionCollectionView() {
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = resultCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultCollectionHeaderView.id, for: indexPath) as! SearchResultCollectionHeaderView
        
        header.selectedSortOption = self.viewModel.inputSortOption.value
        
        header.subviews.forEach { view in
            let button = view as! SortOptionButton
            if button.sortOption == self.viewModel.inputSortOption.value {
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
        return self.viewModel.outputData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        
        let url = URL(string: self.viewModel.outputData.value[indexPath.row].image)
        cell.imageView.kf.setImage(with: url)
        cell.itemNameLabel.text = removeBoldTag(self.viewModel.outputData.value[indexPath.row].itemName)
        cell.mallNameLabel.text = self.viewModel.outputData.value[indexPath.row].mallName
        cell.priceLabel.text = Int(self.viewModel.outputData.value[indexPath.row].lowPrice)!.formatted()
        
        self.viewModel.inputPagination.value = indexPath.item
        
        return cell
    }
}
