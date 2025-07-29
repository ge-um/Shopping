//
//  APIError.swift
//  Shopping
//
//  Created by 금가경 on 7/29/25.
//

import Foundation

enum AppError: Error {
    case server(message: String)
    case unknown
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .server(let message):
            return message
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
