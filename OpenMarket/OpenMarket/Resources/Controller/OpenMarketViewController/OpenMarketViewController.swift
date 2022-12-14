//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class OpenMarketViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        view.backgroundColor = .systemBackground
    }
}

extension OpenMarketViewController {
    func setUpNavigationBar() {
        let dismissAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        navigationItem.title = AnyTargetAPI.OpenMarket.rawValue
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: dismissAction)
    }
}
