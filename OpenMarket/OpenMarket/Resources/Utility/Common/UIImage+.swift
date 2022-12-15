//
//  UIImage+.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

extension UIImage {
    static func setURLImage(urlString: String, completion: @escaping (Self?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(Self.init(data: data))
            }
        }.resume()
    }
}
