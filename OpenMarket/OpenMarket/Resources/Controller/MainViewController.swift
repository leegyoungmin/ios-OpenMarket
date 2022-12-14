//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    var dataSource: UITableViewDiffableDataSource<Int, AnyTargetAPI>?
    let APITableView = UITableView()
    
    var apiList: [AnyTargetAPI] = AnyTargetAPI.allCases
    
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
        APITableView.register(ListTableCell.self, forCellReuseIdentifier: ListTableCell.identifier)
        
        dataSource = UITableViewDiffableDataSource<Int, AnyTargetAPI>(tableView: APITableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.identifier, for: indexPath) as? ListTableCell
            cell?.updateTarget(targetAPI: self.apiList[indexPath.row])
            return cell
        }
        
        APITableView.dataSource = dataSource
        APITableView.delegate = self
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, AnyTargetAPI>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(apiList)
        dataSource?.apply(snapshot)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 새로운 ViewController로 변경하기
        
        var controller: UIViewController?
        let selectedAPI = apiList[indexPath.row]
        
        switch selectedAPI {
        case .OpenMarket:
            controller = OpenMarketViewController()
        }
        
        guard let controller = controller else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let navController = UINavigationController(rootViewController: controller)
        
        navController.modalPresentationStyle = .currentContext

        present(navController, animated: true)
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
