//
//  QueryTextError.swift
//  Shopping
//
//  Created by 금가경 on 8/12/25.
//

import Foundation

enum QueryTextError: Error {
    case `nil`
    case outOfRange
}

extension QueryTextError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nil: "텍스트가 nil입니다."
        case .outOfRange: "텍스트를 두 글자 이상 입력하세요."
        }
    }
}
