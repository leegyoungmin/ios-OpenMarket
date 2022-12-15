//
//  APIListCollectionViewCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        

import UIKit

class APIListTableViewCell: UITableViewCell {
    static let identifier = String(describing: APIListTableViewCell.self)

    private var targetAPI: APIStore?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var contentConfig = defaultContentConfiguration().updated(for: state)
        let backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        
        contentConfig.text = self.targetAPI?.name
        
        contentConfiguration = contentConfig
        backgroundConfiguration = backgroundConfig
    }
    
    func configure(model: AnyTargetAPI) {
        targetAPI = model
    }
}
