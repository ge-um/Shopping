//
//  ShoppingRouter.swift
//  Shopping
//
//  Created by 금가경 on 8/13/25.
//

import Alamofire
import Foundation

enum ShoppingRouter {
    case getSortedShoppingResponse(query: String, sort: SortType)
    case addShoppingResponse(query: String, start: Int, sort: SortType)

    var baseURL: String {
        "https://openapi.naver.com/v1/search/shop.json?"
    }
    
    var endPoint: URL? {
        guard let url = URL(string: baseURL) else {
            return nil
        }
        return url
    }
    
    var header: HTTPHeaders {
        return ["X-Naver-Client-Id":
            Bundle.main.infoDictionary?["NaverClientId"] as! String,
        "X-Naver-Client-Secret":
            Bundle.main.infoDictionary?["NaverClientSecret"] as! String]
    }
    
    var parameters: Parameters {
        switch self {
        case .getSortedShoppingResponse(let query, let sort):
            ["query": "\(query)", "sort": "\(sort)"]
        case .addShoppingResponse(let query, let start, let sort):
            ["query": "\(query)", "start": "\(start)", "sort": "\(sort)"]
        }
    }
}
