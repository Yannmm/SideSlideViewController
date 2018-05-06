//
//  MainViewController.swift
//  side-slide-controller
//
//  Created by yannmm on 18/5/6.
//  Copyright © 2018 ddpc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        view.addSubview(headerView)
        view.addSubview(lowerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 100.0)
            ])
        
        NSLayoutConstraint.activate([
            lowerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lowerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            lowerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    // MARK: - Lazy
    private lazy var headerView: HeaderView = {
        let v = HeaderView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var lowerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
