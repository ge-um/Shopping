//
//  ServerErrorResponse.swift
//  Shopping
//
//  Created by 금가경 on 7/30/25.
//

struct ServerErrorResponse: Decodable {
    let errorMessage: String
    let errorCode: String
}
