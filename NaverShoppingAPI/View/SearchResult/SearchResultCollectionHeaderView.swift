//
//  SearchResultCollectionHeaderView.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/16/25.
//

import UIKit

import SnapKit

class SearchResultCollectionHeaderView: UICollectionReusableView, CustomViewControllerProtocol {
    static let id: String = "SearchResultCollectionHeaderView"
    
    var selectedSortOption: SortOption = .accuracy {
        didSet {
            self.subviews.forEach { view in
                let button = view as! SortOptionButton
                
                button.isSelect = button.sortOption == self.selectedSortOption
            }
        }
    }
    
    let accuracyButton: SortOptionButton = SortOptionButton()
    let dateButton: SortOptionButton = SortOptionButton(sortOption: .date)
    let highPriceButton: SortOptionButton = SortOptionButton(sortOption: .highPrice)
    let lowPriceButton: SortOptionButton = SortOptionButton(sortOption: .lowPrice)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(accuracyButton)
        addSubview(dateButton)
        addSubview(highPriceButton)
        addSubview(lowPriceButton)
    }
    
    func configureLayout() {
        accuracyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
        
        dateButton.snp.makeConstraints { make in
            make.leading.equalTo(accuracyButton.snp.trailing).offset(16)
            make.verticalEdges.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
        
        highPriceButton.snp.makeConstraints { make in
            make.leading.equalTo(dateButton.snp.trailing).offset(16)
            make.verticalEdges.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
        
        lowPriceButton.snp.makeConstraints { make in
            make.leading.equalTo(highPriceButton.snp.trailing).offset(16)
            make.verticalEdges.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
    }
}
