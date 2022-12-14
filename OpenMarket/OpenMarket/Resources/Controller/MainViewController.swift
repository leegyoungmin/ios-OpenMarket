//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    var dataSource: UITableViewDiffableDataSource<Int, UUID>?
    
    let APITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUpTableViewDataSource()
        setUpConstraints()
        
    }
}

// MARK: - TableViewDataSource
private extension MainViewController {
    func setUpTableViewDataSource() {
        APITableView.register(APIListCell.self, forCellReuseIdentifier: APIListCell.identifier)
        
        dataSource = UITableViewDiffableDataSource<Int, UUID>(tableView: APITableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: APIListCell.identifier, for: indexPath) as? APIListCell
            cell?.updateIndex(index: indexPath)
            return cell
        }
        
        APITableView.dataSource = dataSource
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        
        snapshot.appendSections([0])
        snapshot.appendItems([UUID(), UUID(), UUID()])
        dataSource?.apply(snapshot)
    }
}

// MARK: - UI Configure
private extension MainViewController {
    func setUpConstraints() {
        view.addSubview(APITableView)
        APITableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            APITableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            APITableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            APITableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            APITableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
