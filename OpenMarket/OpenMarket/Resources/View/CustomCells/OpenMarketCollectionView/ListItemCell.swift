//
//  ListItemCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import UIKit

class ListItemCell: UICollectionViewListCell, CustomCollectionCell {
    var task: URLSessionDataTask? {
        didSet {
            task?.resume()
        }
    }
    
    private var product: Product? = nil
    private var thumbnailImage: UIImage? = nil {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    private func defaultItemContent() -> UIListContentConfiguration {
        return UIListContentConfiguration.subtitleCell()
    }
    
    func configure(model: Decodable) {
        guard let model = model as? Product else { return }
        product = model
        setUpImageTask(thumbnailUrlString: model.thumbnail)
    }
    
    private func setUpImageTask(thumbnailUrlString: String) {
        guard let url = URL(string: thumbnailUrlString) else { return }
        
        task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.thumbnailImage = UIImage(data: data)
                }
            }
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)
        content.image = thumbnailImage
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        content.imageProperties.cornerRadius = 15
        content.text = product?.name
        content.secondaryText = product?.price.description
        contentConfiguration = content
    }
    
    
    override func prepareForReuse() {
        task?.cancel()
        task = nil
        contentConfiguration = defaultContentConfiguration()
        super.prepareForReuse()
    }
}
