//
//  ShoppingResponse.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

struct ShoppingResponse: Decodable {
    let total: Int
    let items: [Item]
    
    var overview: String {
        "\(total.formatted(.number)) 개의 검색 결과"
    }
}

struct Item: Decodable {
    let image: String
    let mallName: String
    let title: String
    let lprice: String
}
