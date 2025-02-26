//
//  NetworkManager.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/16/25.
//

import Alamofire
import RxSwift

enum SortOption: String {
    case accuracy = "정확도"
    case date = "날짜순"
    case highPrice = "가격높은순"
    case lowPrice = "가격낮은순"
    
    var queryString: String {
        switch self {
        case .accuracy:
            return "sim"
        case .date:
            return "date"
        case .highPrice:
            return "dsc"
        case .lowPrice:
            return "asc"
        }
    }
}

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private var query: String = ""
    private var queryURLString: String {
        return "query=\(query)"
    }
    
    private var displayPerPage: Int = 100
    private var displayPerPageURLString: String {
        return "display=\(displayPerPage)"
    }
    
    private var pageOffset: Int = 1
    private var pageOffsetURLString: String {
        return "start=\(pageOffset)"
    }
    
    private var sort: SortOption = .accuracy
    private var sortURLString: String {
        return "sort=\(sort.queryString)"
    }
    /*
    var isEnd: Bool {
        if totalCount == 0 || totalCount > pageOffset {
            return false
        } else {
            return true
        }
    }
    */
    private init() {}
    
    func naverShoppingSearchRequest(completionHandler: @escaping (SearchResult) -> ()) {
        let urlString = APIURL.naverShoppingBaseURL + getQueryString(queryStrings: queryURLString, displayPerPageURLString, pageOffsetURLString, sortURLString)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverShoppingID,
            "X-Naver-Client-Secret": APIKey.naverShoppingScret
        ]
        AF.request(urlString, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let data):
                self.pageOffset += self.displayPerPage
                completionHandler(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func naverShoppingSearchRequestWithRx(searchText: String, completionHandler: @escaping (SearchResult) -> ()) {
        self.query = searchText
        let urlString = APIURL.naverShoppingBaseURL + getQueryString(queryStrings: queryURLString, displayPerPageURLString, pageOffsetURLString, sortURLString)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverShoppingID,
            "X-Naver-Client-Secret": APIKey.naverShoppingScret
        ]
        AF.request(urlString, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let data):
                self.pageOffset += self.displayPerPage
                completionHandler(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func naverShoppingSearchRequestWithRx(searchText: String) -> Single<Result<SearchResult, APIError>> {
        return Single<Result<SearchResult, APIError>>.create { value in
            self.query = searchText
            let urlString = APIURL.naverShoppingBaseURL + self.getQueryString(queryStrings: self.queryURLString, self.displayPerPageURLString, self.pageOffsetURLString, self.sortURLString)
            let headers: HTTPHeaders = [
                "X-Naver-Client-Id": APIKey.naverShoppingID,
                "X-Naver-Client-Secret": APIKey.naverShoppingScret
            ]
            AF.request(urlString, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: SearchResult.self) { response in
                switch response.result {
                case .success(let data):
                    self.pageOffset += self.displayPerPage
                    value(.success(.success(data)))
                case .failure(let error):
                    print(error)
                    value(.success((.failure(.unknownResponse))))
                }
            }
            return Disposables.create {
                print("완료")
            }
        }
        
    }
    
    private func getQueryString(queryStrings: String...) -> String {
        return queryStrings.joined(separator: "&")
    }
    
    func setQuery(_ term: String) {
        self.query = term
    }
    
    func getPageOffset() -> Int {
        return self.pageOffset
    }
    
    func resetAllSharedData() {
        self.query = ""
        self.pageOffset = 1
        self.sort = .accuracy
    }
    
    func resetSharedDataWithChangeSort(sort: SortOption) {
        self.pageOffset = 1
        self.sort = sort
    }
}
