//
//  NumberFormatter.swift
//  Shopping
//
//  Created by 금가경 on 7/27/25.
//

import Foundation

final class ShoppingNumberFormatter {
    static let shared = ShoppingNumberFormatter()
    
    private init() {}
    
    private var priceNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    func formatted(number: String) -> String? {
        guard let number = Int(number) as? NSNumber else { return nil }
        return priceNumberFormatter.string(from: number)
    }
}
