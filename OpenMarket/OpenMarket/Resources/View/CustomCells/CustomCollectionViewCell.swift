//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

protocol CustomCell {
    associatedtype Model
    
    func configure(model: Model)
}

protocol CustomCollectionCell: CustomCell where Model == Decodable { }
protocol CustomTableCell: CustomCell where Model == AnyHashable { }
