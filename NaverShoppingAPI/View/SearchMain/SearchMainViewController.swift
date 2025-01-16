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
        navigationItem.searchController = CustomSearchController(searchResultsController: nil)
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
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.count > 1 {
            view.endEditing(true)
            let nextVC = SearchResultViewController()
            nextVC.searchTerm = text
            navigationController?.pushViewController(nextVC, animated: true)
            textField.text = nil
            return true
        } else {
            present(setActionSheet {
                // TODO: becomeFirstResponder에 대해 알아보기
                self.navigationItem.searchController?.searchBar.searchTextField.becomeFirstResponder()
            }, animated: true)
            return false
        }
    }
}

extension SearchMainViewController {
    func setAlert(completionHandler: @escaping () -> ()) -> UIAlertController {
        let ac = UIAlertController(title: "검색어 입력 오류", message: "검색어는 공백 제외 2글자 이상 입력해주세요.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        ac.addAction(cancelAction)
        ac.addAction(confirmAction)
        
        return ac
    }
    
    func setActionSheet(completionHandler: @escaping () -> ()) -> UIAlertController {
        let ac = UIAlertController(title: "검색어는 공백 제외 2글자 이상 입력해주세요.", message: nil, preferredStyle: .actionSheet)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        ac.addAction(confirmAction)
        
        return ac
    }
}
