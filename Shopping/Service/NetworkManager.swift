//
//  NetworkManager.swift
//  Shopping
//
//  Created by 금가경 on 7/29/25.
//

import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest(query: String, start: Int, type: SortType = .sim, completionHandler: @escaping (ShoppingResponse) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&start=\(start)&sort=\(type.rawValue)"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id":
                Bundle.main.infoDictionary?["NaverClientId"] as! String,
            "X-Naver-Client-Secret":
                Bundle.main.infoDictionary?["NaverClientSecret"] as! String
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResponse.self) { response in
                switch response.result {
                case .success(let shoppingResponse):
                    print("success", shoppingResponse)
                    
                    completionHandler(shoppingResponse)
                    
                case .failure(let error):
                    print("error", error)
                }
            }
    }
    
}
