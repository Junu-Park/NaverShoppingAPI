//
//  CustomViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 1/15/25.
//

import UIKit

protocol CustomViewControllerProtocol {
    func configureHierarchy()
    func configureLayout()
}

class CustomViewController: UIViewController, CustomViewControllerProtocol {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
    }
    
    func configureLayout() {
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
