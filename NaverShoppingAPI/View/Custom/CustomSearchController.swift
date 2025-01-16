//
//  CustomSearchController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

class CustomSearchController: UISearchController {
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        
        searchBar.tintColor = UIColor.white
        searchBar.showsCancelButton = false
        hidesNavigationBarDuringPresentation = false
        
        searchBar.searchTextField.attributedText = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.white])
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [.font: UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.lightGray])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



