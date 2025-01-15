//
//  SearchMainViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import SnapKit

class SearchMainViewController: CustomViewController {

    let mainImageView: UIImageView = {
        let iv: UIImageView = UIImageView()
        iv.image = UIImage(resource: .wallet)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
    }
    
    func configureNavigationItem() {
        navigationItem.title = "아서의 쇼핑쇼핑"
        navigationItem.searchController = CustomSearchController()
    }
    
    override func configureHierarchy() {
        view.addSubview(mainImageView)
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(mainImageView.snp.width)
        }
    }
}
