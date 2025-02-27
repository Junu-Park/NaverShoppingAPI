//
//  SearchMainViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SearchMainViewController: CustomViewController {

    private let mainImageView: UIImageView = {
        let iv: UIImageView = UIImageView()
        iv.image = UIImage(resource: .wallet)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let viewModelRx: SearchMainViewModelRx = SearchMainViewModelRx()
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        self.bind()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "준우의 쇼핑쇼핑"
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.searchController = CustomSearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.searchTextField.textColor = UIColor.white
        let right = UIBarButtonItem(image: UIImage(systemName: "list.bullet.clipboard"), style: .done, target: self, action: #selector(self.transitionToList))
        navigationItem.setRightBarButton(right, animated: true)
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
    
    private func bind() {
        
        let searchText = PublishRelay<String>()
        
        self.navigationItem.searchController?.searchBar.rx.searchButtonClicked
            .withLatestFrom(self.navigationItem.searchController!.searchBar.rx.text.orEmpty)
            .bind(to: searchText)
            .disposed(by: self.disposeBag)
        
        let input = SearchMainViewModelRx.Input(searchText: searchText)
        let output = self.viewModelRx.transform(input: input)
        
        output.isValidSearchText
            .drive(with: self) { owner, value in
                if value {
                    owner.view.endEditing(true)
                    let nextVC = SearchResultViewController(searchText: owner.navigationItem.searchController!.searchBar.text!)
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                    owner.navigationItem.searchController?.searchBar.text = nil
                } else {
                    owner.present(owner.setActionSheet { owner.navigationItem.searchController?.searchBar.becomeFirstResponder() }, animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc private func transitionToList() {
        self.navigationController?.pushViewController(ListCollectionViewController(), animated: true)
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
