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
    
    let layoutSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.selectedSegmentIndex = .zero
        return segment
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    var collectionView: UICollectionView? = nil
    
    var selectedSectionIndex: Int = .zero {
        didSet {
            collectionView?.collectionViewLayout = createLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setSegmentAction()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        configureDataSource()
        applySnapshot()
        
        setUpConstraints()
        view.backgroundColor = .systemBackground
        
        let endPoint = OpenMarketAPI.searchList(1, 100)
        NetworkManager().fetchData(endPoint: endPoint, model: ProductList.self) { result in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UserInteraction
extension OpenMarketViewController {
    func setSegmentAction() {
        layoutSegment.addTarget(self, action: #selector(didChangeSegmentIndex), for: .valueChanged)
    }
    
    @objc func didChangeSegmentIndex(_ sender: UISegmentedControl) {
        selectedSectionIndex = sender.selectedSegmentIndex
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

extension OpenMarketViewController {
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
        
        let gridCellRegistration = UICollectionView
            .CellRegistration<UICollectionViewCell, Int> { (cell, indexPath, itemIdentifier) in
            var content = UIListContentConfiguration.cell()
            content.image = UIImage(systemName: "person")
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
        }
        
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, itemIdentifier) in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "person")
            content.text = itemIdentifier.description
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
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
        
        var snapshot = NSDiffableDataSourceSectionSnapshot<Int>()
        snapshot.append(Array(1...1000))
        dataSource?.apply(snapshot, to: section, animatingDifferences: true)
    }
}
