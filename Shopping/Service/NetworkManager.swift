//
//  NetworkManager.swift
//  Shopping
//
//  Created by 금가경 on 7/29/25.
//

import Alamofire
import Foundation

// TODO: - api 통신 실패시 대응
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func callRequest(query: String = "강아지", start: Int, type: SortType = .sim, completionHandler: @escaping (Result<ShoppingResponse, Error>) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&start=\(start)&sort=\(type.rawValue)"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id":
                Bundle.main.infoDictionary?["NaverClientId"] as! String,
            "X-Naver-Client-Secret":
                Bundle.main.infoDictionary?["NaverClientSecret"] as! String
        ]
        
        // TODO: - 나은 방법 + 앱 상태 (ex- 네트워크 처리)에 따라 분기처리 필요
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResponse.self) { response in
                switch response.result {
                    
                case .success(let shoppingResponse):
                    completionHandler(.success(shoppingResponse))
                    
                case .failure(let error):
                    guard let data = response.data else {
                        completionHandler(.failure(AppError.unknown))
                        return
                    }
                    
                    do {
                        let errorResponse = try JSONDecoder().decode(ServerErrorResponse.self, from: data)
                        completionHandler(.failure(AppError.server(message: errorResponse.errorMessage)))
                    } catch {
                        completionHandler(.failure(AppError.unknown))
                    }
                }
            }
    }
}
