//
//  APIListCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class ListTableCell: UITableViewCell {
    static let identifier = String(describing: ListTableCell.self)

    private var indexPath: IndexPath?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var contentConfig = defaultContentConfiguration().updated(for: state)
        let backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        
        contentConfig.text = indexPath?.description
        
        contentConfiguration = contentConfig
        backgroundConfiguration = backgroundConfig
    }
    
    func updateIndex(index: IndexPath) {
        indexPath = index
    }
}
