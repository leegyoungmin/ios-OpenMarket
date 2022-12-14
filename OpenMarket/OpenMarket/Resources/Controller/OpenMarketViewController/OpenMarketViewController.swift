//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class OpenMarketViewController: UIViewController {
    let layoutSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.selectedSegmentIndex = .zero
        return segment
    }()
    
    let collectionView: UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setSegmentAction()
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UserInteraction
extension OpenMarketViewController {
    func setSegmentAction() {
        layoutSegment.addTarget(self, action: #selector(didChangeSegmentIndex), for: .valueChanged)
    }
    
    @objc func didChangeSegmentIndex(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}

extension OpenMarketViewController {
    func setUpNavigationBar() {
        let dismissAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        navigationItem.titleView = layoutSegment
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = AnyTargetAPI.OpenMarket.rawValue
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: dismissAction)
    }
}
