//
//  TargetAPI.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

protocol APIStore {
    var name: String { get }
}

protocol TargetAPI {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: String] { get }
    var header: [String: String] { get }
    
    func generateRequest() -> URLRequest?
}

extension TargetAPI {
    private func generateURL() -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = query.queryItems
        
        return components?.url
    }
    func generateRequest() -> URLRequest? {
        guard let url = generateURL() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}

enum AnyTargetAPI: String, APIStore, CaseIterable {
    var name: String {
        return self.rawValue
    }
    
    case OpenMarket = "오픈 마켓"
}
