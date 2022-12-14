//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class OpenMarketViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case list
        case grid
    }

    // MARK: - Properties
    var selectedSectionIndex: Int = .zero {
        didSet {
            collectionView?.collectionViewLayout = createLayout()
        }
    }
    
    var endPoint = OpenMarketAPI.searchList(1, 100)
    var networkManager = NetworkManager()
    var productList: ProductList? {
        didSet {
            if let products = productList?.products {
                self.products = products
            }
        }
    }
    var products: [Product] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    // MARK: - View Properties
    let layoutSegment: UISegmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>?
    var collectionView: UICollectionView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        createCollectionView()
        setUpNavigationBar()
        setSegmentAction()
        setUpConstraints()
        
        networkManager.fetchData(endPoint: endPoint, model: ProductList.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productList):
                    self?.productList = productList
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - UserInteraction
private extension OpenMarketViewController {
    func setSegmentAction() {
        layoutSegment.selectedSegmentIndex = 0
        layoutSegment.addTarget(self, action: #selector(didChangeSegmentIndex), for: .valueChanged)
    }
    
    @objc func didChangeSegmentIndex(_ sender: UISegmentedControl) {
        selectedSectionIndex = sender.selectedSegmentIndex
    }
}

// MARK: - Configure UI
private extension OpenMarketViewController {
    func setUpNavigationBar() {
        let dismissAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        navigationItem.titleView = layoutSegment
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = AnyTargetAPI.OpenMarket.rawValue
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: dismissAction)
    }
    
    func setUpConstraints() {
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Configure CollectionView
private extension OpenMarketViewController {
    func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layout: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: self.selectedSectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .grid:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.3)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
            case .list:
                let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                section = NSCollectionLayoutSection.list(
                    using: configuration,
                    layoutEnvironment: layout
                )
            }
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func configureDataSource() {
        guard let collectionView = collectionView else { return }
        
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Product> { (cell, indexPath, itemIdentifier) in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "person")
            content.text = itemIdentifier.name
            cell.contentConfiguration = content
        }
        
        let gridCellRegistration = UICollectionView
            .CellRegistration<UICollectionViewCell, Product> { (cell, indexPath, itemIdentifier) in
            var content = UIListContentConfiguration.cell()
            content.image = UIImage(systemName: "person")
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            if let section = Section(rawValue: self.selectedSectionIndex) {
                switch section {
                case .grid:
                    return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: item)
                case .list:
                    return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
                }
            }
            
            return UICollectionViewCell()
        }
    }
    
    func applySnapshot() {
        guard let section = Section(rawValue: selectedSectionIndex) else {
            return
        }
        
        var snapshot = NSDiffableDataSourceSectionSnapshot<Product>()
        snapshot.append(products)
        dataSource?.apply(snapshot, to: section, animatingDifferences: true)
    }
}
