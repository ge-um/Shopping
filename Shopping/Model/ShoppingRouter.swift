//
//  ShoppingRouter.swift
//  Shopping
//
//  Created by 금가경 on 8/13/25.
//

import Alamofire
import Foundation

/// query / start = 1 / sort = .sim
/// query/ start = 1/ sort =
/// let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=100&start=\(start)&sort=\(type.rawValue)"
///
enum ShoppingRouter {
    case getShoppingResponse(query: String)
    case getSortedShoppingResponse(query: String, sort: SortType)
    case addShoppingResponse(query: String, start: Int, sort: SortType)

    var baseURL: String {
        "https://openapi.naver.com/v1/search/shop.json?"
    }
    
    var endPoint: URL? {
        switch self {
        case .getShoppingResponse(let query):
            guard let url = URL(string: baseURL + "query=\(query)&display=100") else {
                return nil
            }
            return url
            
        case .getSortedShoppingResponse(let query, let sort):
            guard let url = URL(string: baseURL + "query=\(query)&display=100&sort=\(sort)") else {
                return nil
            }
            return url
            
        case .addShoppingResponse(let query, let start, let sort):
            guard let url = URL(string: baseURL + "query=\(query)&display=100&start=\(start)&sort=\(sort)") else {
                return nil
            }
            return url
        }
    }
    
    var header: HTTPHeaders {
        return ["X-Naver-Client-Id":
            Bundle.main.infoDictionary?["NaverClientId"] as! String,
        "X-Naver-Client-Secret":
            Bundle.main.infoDictionary?["NaverClientSecret"] as! String]
    }
    
//    var parameter: Parameters {
//        switch self {
//        case .getShoppingResponse(let query):
//            ["query": ]
//        case .getSortedShoppingResponse(let query, let sort):
//            <#code#>
//        case .addShoppingResponse(let query, let start, let sort):
//            <#code#>
//        }
//    }
}
