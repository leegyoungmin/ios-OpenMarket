//
//  NetworkManager.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum apiType {
    static let baseURL: String = "https://openmarket.yagom-academy.kr"
    case healthChecker
    case productList(pageNumber: Int, rowCount: Int)
    case searchProduct(id: Int)
    
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productList:
            return "/api/products"
        case .searchProduct(let id):
            return "/api/products/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .productList(let pageNumber, let rowCount):
            return [
                URLQueryItem(name: "page_no", value: "\(pageNumber)"),
                URLQueryItem(name: "items_per_page", value: "\(rowCount)")
            ]
        default:
            return []
        }
    }

    func generateURL() -> URL? {
        guard var components = URLComponents(string: Self.baseURL) else {
            return nil
        }
        
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

protocol Networkable {
    var session: URLSession { get }
    func fetch<Model: Decodable>(
        endpoint: apiType,
        model: Model.Type,
        completion: @escaping (Model) -> Void
    )
}

extension Networkable {
    func fetch<Model: Decodable>(
        endpoint: apiType,
        model: Model.Type,
        completion: @escaping (Model) -> Void
    ) {
        guard let url = endpoint.generateURL() else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(Model.self, from: data)
                completion(decodeData)
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

struct NetworkService: Networkable {
    var session: URLSession = URLSession(configuration: .default)
}
