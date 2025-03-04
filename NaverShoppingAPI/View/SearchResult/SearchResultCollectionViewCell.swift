//
//  SearchResultCollectionViewCell.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell, CustomViewControllerProtocol {
    static let id: String = "SearchResultCollectionViewCell"
    
    let imageView: UIImageView = {
        let iv: UIImageView = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    let mallNameLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.darkGray
        lb.font = UIFont.systemFont(ofSize: 11)
        return lb
    }()
    
    let itemNameLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.numberOfLines = 2
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    
    let likeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.baseForegroundColor = .systemRed
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(self.likeButton)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        self.likeButton.snp.makeConstraints { make in
            make.size.equalTo(self.imageView.snp.width).multipliedBy(0.2)
            make.trailing.bottom.equalTo(self.imageView).offset(-4)
        }
    }
}
