//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let netWorkHandler = NetworkService()

    var data: ProductListResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let type: apiType = .productList(pageNumber: pageNumber, rowCount: rowCount)
        
        netWorkHandler.fetch(endpoint: type, model: ProductListResponse.self) { decodeData in
            self.data = decodeData
            print(self.data)
        }
    }
}
