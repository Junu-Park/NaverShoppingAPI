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
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.searchController = CustomSearchController()
        navigationItem.searchController?.searchBar.searchTextField.textColor = UIColor.white
        navigationItem.searchController?.searchBar.searchTextField.delegate = self
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

// TODO: UISearchBarDelegate / UISearchTextFieldDelegate 중에 뭘 사용해야할까?
extension SearchMainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count ?? 0 > 1 {
            view.endEditing(true)
            let nextVC = SearchResultViewController()
            nextVC.navigationItem.title = textField.text
            navigationController?.pushViewController(nextVC, animated: true)
            textField.text = nil
            return true
        } else {
            return false
        }
    }
}
