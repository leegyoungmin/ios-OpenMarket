//
//  ProductList.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import Foundation

struct ProductList: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let hasNext: Bool
    let hasPrev: Bool
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case itemsPerPage, totalCount, offset, limit, hasNext, hasPrev
        case pageNumber = "pageNo"
        case products = "pages"
    }
}

struct Product: Codable, Hashable {
    let id: Int
    let vendorId: Int
    let vendorName: String
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdDate: String
    let issuedDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, vendorName, name, description, thumbnail, currency, price, stock
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdDate = "created_at"
        case issuedDate = "issued_at"
    }
}

enum Currency: String, Codable {
    case KRW, USD
}
