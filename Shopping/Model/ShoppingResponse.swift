//
//  ShoppingResponse.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import Foundation

struct ShoppingResponse: Decodable {
    let total: Int
    let items: [Item]
}

struct Item: Decodable {
    let image: String
    let mallName: String
    let title: String
    let lprice: String
}
