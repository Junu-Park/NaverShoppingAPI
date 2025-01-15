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
        layout.itemSize = CGSize(width: (superView.frame.width - 48) / 2, height: superView.frame.height / 4)
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        backgroundColor = UIColor.clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
