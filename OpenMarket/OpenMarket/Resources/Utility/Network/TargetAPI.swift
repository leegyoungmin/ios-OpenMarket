//
//  TargetAPI.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

protocol TargetAPI {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: String] { get }
    var header: [String: String] { get }
    
    func generateURL() -> URL?
}

extension TargetAPI {
    func generateURL() -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            return nil
        }
        
        components.path = path
        components.queryItems = query.queryItems
        
        return components.url
    }
}
