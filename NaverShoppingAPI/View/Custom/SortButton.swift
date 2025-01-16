//
//  SortButton.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/16/25.
//

import UIKit

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

class SortOptionButton: UIButton {
    var sortOption: SortOption = .accuracy
    
    var isSelect: Bool = false {
        didSet {
            setButtonColor()
        }
    }
    
    init(sortOption: SortOption = .accuracy) {
        super.init(frame: .zero)
        self.sortOption = sortOption
        configureButton()
        setButtonColor()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
    }
    
    func setButtonColor() {
        self.setAttributedTitle(NSAttributedString(string: sortOption.rawValue, attributes: [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: isSelect ? UIColor.black : UIColor.white]), for: .normal)
        self.setAttributedTitle(NSAttributedString(string: sortOption.rawValue, attributes: [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.black]), for: .highlighted)
        self.backgroundColor = isSelect ? UIColor.white : UIColor.black
    }
}
