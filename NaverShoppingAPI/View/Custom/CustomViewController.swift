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
}
