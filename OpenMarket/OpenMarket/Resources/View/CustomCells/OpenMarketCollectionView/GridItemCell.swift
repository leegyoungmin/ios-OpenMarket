//
//  GridItemCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class GridItemCell: UICollectionViewCell, CustomCollectionCell {
    private var task: URLSessionDataTask? {
        didSet {
            if task != nil {
                task?.resume()
            }
        }
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        [
            imageView,
            titleLabel,
            priceLabel,
            stockLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        task?.cancel()
        task = nil
        imageView.image = nil
        super.prepareForReuse()
    }
    
    func configure(model: Decodable) {
        guard let model = model as? Product else { return }
        setUpTask(urlString: model.thumbnail) { image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
        
        [titleLabel, stockLabel, priceLabel].forEach {
            $0.textAlignment = .center
            $0.textColor = .label
        }
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.text = model.name
        stockLabel.text = model.stock.description
        priceLabel.text = model.price.description
    }
    
    private func setUpTask(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        let imageTask = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                completion(UIImage(data: data))
            }
        }
        
        task = imageTask
    }
}
