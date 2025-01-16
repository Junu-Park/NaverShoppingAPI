//
//  NetworkManager.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/16/25.
//

import Alamofire

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

class NetworkManager {
    static let shared = NetworkManager()
    
    private var totalCount: Int = 0
    
    private var query: String = ""
    private var queryURLString: String {
        return "query=\(query)"
    }
    
    private var displayPerPage: Int = 30
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
                if self.totalCount == 0 {
                    self.totalCount = data.totalCount
                }
                self.pageOffset += self.displayPerPage
                completionHandler(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getQueryString(queryStrings: String...) -> String {
        return queryStrings.joined(separator: "&")
    }
    
    func setQuery(_ term: String) {
        self.query = term
    }
    
    func getTotalCount() -> Int {
        return self.totalCount
    }
    
    func getPageOffset() -> Int {
        return self.pageOffset
    }
    
    func resetAllSharedData() {
        self.query = ""
        self.pageOffset = 1
        self.sort = .accuracy
        self.totalCount = 0
    }
    
    func resetSharedDataWithChangeSort(sort: SortOption) {
        self.pageOffset = 1
        self.sort = sort
    }
}
