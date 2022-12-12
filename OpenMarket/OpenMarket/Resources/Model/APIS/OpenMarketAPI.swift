//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum OpenMarketAPI: TargetAPI {
    case searchList(_ pageNumber: Int, _ rowCount: Int)
    case searchItem(_ itemNumber: Int)
    case addItem
    case searchRemoveItemURL
    case removeItem
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchList(_, _):
            return .Get
        case .searchItem(_):
            return .Get
        case .addItem:
            return .Post
        case .searchRemoveItemURL:
            return .Post
        case .removeItem:
            return .Remove
        }
    }
    
    var path: String {
        switch self {
        case .searchList(_, _):
            return "/api/products"
        case .searchItem(let itemID):
            return "/api/products/\(itemID)"
        default:
            return ""
        }
        
    }
    
    var query: [String : String] {
        switch self {
        case .searchList(let pageNumber, let rowCount):
            return [
                "page_no": pageNumber.description,
                "items_per_page": rowCount.description
            ]
        default:
            return [:]
        }
    }
    
    var header: [String : String] {
        return [:]
    }
}
