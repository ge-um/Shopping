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
    
    func callRequest<T: Decodable>(api: ShoppingRouter, type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {

        guard let endPoint = api.endPoint else {
            completionHandler(.failure(AppError.invalidURL))
            return
        }
        
        // TODO: - 나은 방법 + 앱 상태 (ex- 네트워크 처리)에 따라 분기처리 필요
        AF.request(endPoint, method: .get, parameters: api.parameters, headers: api.header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                    
                case .success(let result):
                    completionHandler(.success(result))
                    
                case .failure(_):
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
