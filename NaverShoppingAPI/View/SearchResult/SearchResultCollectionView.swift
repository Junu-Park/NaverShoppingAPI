//
//  SearchResultCollectionView.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

class SearchResultCollectionView: UICollectionView {
    
    init(superView : UIView) {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (superView.frame.width - 48) / 2, height: superView.frame.height / 3.5)
        layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        register(SearchResultCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultCollectionHeaderView.id)
        
        backgroundColor = UIColor.clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
