//
//  SearchResultViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit

class SearchResultViewController: CustomViewController {

    lazy var resultCountLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.systemGreen
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.text = getResultCountText()
        return lb
    }()
    
    lazy var resultCollectionView: SearchResultCollectionView = SearchResultCollectionView(superView: view)
    
    var searchTerm: String = ""
    
    var searchData: SearchResult? {
        didSet {
            resultCountLabel.text = self.getResultCountText()
            resultCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchTerm
        connectionCollectionView()
        naverShoppingSearchRequest()
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
    func getResultCountText() -> String {
        if let searchData {
            return "\(searchData.totalCount.formatted()) 개의 검색 결과"
        } else {
            return "0 개의 검색 결과"
        }
    }
    
    func removeBoldTag(_ string: String) -> String {
        var replacedString: String = string.replacingOccurrences(of: "<b>", with: "")
        replacedString = replacedString.replacingOccurrences(of: "</b>", with: "")
        return replacedString
    }
    
    func naverShoppingSearchRequest() {
        let urlString = APIURL.naverShoppingBaseURL + "query=\(searchTerm)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverShoppingID,
            "X-Naver-Client-Secret": APIKey.naverShoppingScret
        ]
        AF.request(urlString, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let data):
                self.searchData = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func connectionCollectionView() {
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        if let data = searchData?.items[indexPath.row]{
            let url = URL(string: data.image)
            cell.imageView.kf.setImage(with: url)
            cell.itemNameLabel.text = removeBoldTag(data.title)
            cell.mallNameLabel.text = data.mallName
            cell.priceLabel.text = Int(data.lowPrice)!.formatted()
        }
        
        return cell
    }
}
