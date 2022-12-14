//
//  APIListCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class APIListCell: UITableViewCell {
    static let identifier = String(describing: APIListCell.self)

    private var indexPath: IndexPath?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var contentConfig = defaultContentConfiguration().updated(for: state)
        let backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        
        contentConfig.text = indexPath?.description
        contentConfig.image = UIImage(systemName: "person")
        
        contentConfiguration = contentConfig
        backgroundConfiguration = backgroundConfig
    }
    
    func updateIndex(index: IndexPath) {
        indexPath = index
    }
}
