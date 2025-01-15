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
    
    var data: SearchResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(resultCountLabel)
    }
    
    override func configureLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
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
