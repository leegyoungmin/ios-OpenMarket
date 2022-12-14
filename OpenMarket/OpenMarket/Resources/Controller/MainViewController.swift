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
        
        setUpNavigationBar()
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
        APITableView.delegate = self
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        
        snapshot.appendSections([0])
        snapshot.appendItems([UUID(), UUID(), UUID()])
        dataSource?.apply(snapshot)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 새로운 ViewController로 변경하기
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UI Configure
private extension MainViewController {
    
    func setUpNavigationBar() {
        self.navigationItem.title = "API 리스트 보기"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
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
